from __future__ import annotations

import logging
import threading

from django.conf import settings
from django.db.models import Count, F, Q
from django.db import transaction
from ninja import Router

from dabble.accounts.models import Block
from dabble.common import push
from dabble.common.errors import ApiError, Forbidden, NotFound
from dabble.common.pagination import decode_cursor, encode_cursor
from dabble.common.ratelimit import hit
from dabble.social.models import Comment, Reaction, Report
from dabble.social.schemas import (
    CommentIn,
    CommentPageOut,
    CommentOut,
    ReactionCountsOut,
    ReportIn,
    comment_payload,
)
from dabble.submissions.models import Submission

social_router = Router()
comments_router = Router()
reports_router = Router()

logger = logging.getLogger(__name__)


def _visible_submission(request, submission_id: str) -> Submission:
    submission = (
        Submission.objects.select_related("user")
        .filter(id=submission_id, status=Submission.Status.PUBLISHED, is_removed=False)
        .first()
    )
    if submission is None:
        raise NotFound("That creation is gone.", code="submission_not_found")
    if Block.objects.filter(blocker=request.user, blocked=submission.user).exists():
        raise NotFound("That creation is gone.", code="submission_not_found")
    return submission


def _reaction_state(submission: Submission, viewer) -> dict:
    counts = {
        row["emoji"]: row["total"]
        for row in Reaction.objects.filter(submission=submission)
        .values("emoji")
        .annotate(total=Count("id"))
    }
    mine = list(
        Reaction.objects.filter(submission=submission, user=viewer).values_list(
            "emoji", flat=True
        )
    )
    return {
        "reaction_counts": counts,
        "my_reactions": mine,
        "reaction_count": sum(counts.values()),
    }


# --- reactions --------------------------------------------------------------


@social_router.put("/{submission_id}/reactions/{emoji}", response=ReactionCountsOut)
def add_reaction(request, submission_id: str, emoji: str):
    if emoji not in settings.REACTION_EMOJIS:
        raise ApiError("That reaction isn't available.", code="invalid_emoji")
    submission = _visible_submission(request, submission_id)
    with transaction.atomic():
        _, created = Reaction.objects.get_or_create(
            submission=submission, user=request.user, emoji=emoji
        )
        if created:
            Submission.objects.filter(id=submission.id).update(
                reaction_count=F("reaction_count") + 1
            )
    return _reaction_state(submission, request.user)


@social_router.delete("/{submission_id}/reactions/{emoji}", response=ReactionCountsOut)
def remove_reaction(request, submission_id: str, emoji: str):
    submission = _visible_submission(request, submission_id)
    with transaction.atomic():
        deleted, _ = Reaction.objects.filter(
            submission=submission, user=request.user, emoji=emoji
        ).delete()
        if deleted:
            Submission.objects.filter(id=submission.id, reaction_count__gt=0).update(
                reaction_count=F("reaction_count") - 1
            )
    return _reaction_state(submission, request.user)


# --- comments ---------------------------------------------------------------


@social_router.get("/{submission_id}/comments", response=CommentPageOut)
def list_comments(request, submission_id: str, cursor: str | None = None, limit: int = 30):
    submission = _visible_submission(request, submission_id)
    blocked_ids = Block.objects.filter(blocker=request.user).values_list("blocked_id", flat=True)
    qs = (
        Comment.objects.filter(submission=submission, is_removed=False, parent__isnull=True)
        .exclude(user_id__in=blocked_ids)
        .select_related("user")
        .order_by("created_at", "id")
    )
    decoded = decode_cursor(cursor)
    if decoded:
        ts, last_id = decoded
        qs = qs.filter(Q(created_at__gt=ts) | Q(created_at=ts, id__gt=last_id))

    limit = max(1, min(limit, 50))
    roots = list(qs[: limit + 1])
    has_more = len(roots) > limit
    roots = roots[:limit]

    # One query for every reply on the page rather than one per comment.
    replies_by_parent: dict = {}
    if roots:
        for reply in (
            Comment.objects.filter(parent_id__in=[r.id for r in roots], is_removed=False)
            .exclude(user_id__in=blocked_ids)
            .select_related("user")
            .order_by("created_at", "id")
        ):
            replies_by_parent.setdefault(reply.parent_id, []).append(reply)

    return {
        "items": [
            comment_payload(
                root,
                request.user,
                replies=[
                    comment_payload(r, request.user)
                    for r in replies_by_parent.get(root.id, [])
                ],
            )
            for root in roots
        ],
        "next_cursor": encode_cursor(roots[-1].created_at, roots[-1].id) if has_more and roots else None,
    }


@social_router.post("/{submission_id}/comments", response=CommentOut)
def create_comment(request, submission_id: str, data: CommentIn):
    hit(f"comment:{request.user.id}", limit=30, window_seconds=3600)
    body = data.body.strip()
    if not body:
        raise ApiError("Say something first.", code="empty_comment")
    submission = _visible_submission(request, submission_id)

    parent = None
    if data.parent_id:
        parent = Comment.objects.filter(
            id=data.parent_id, submission=submission, is_removed=False
        ).first()
        if parent is None:
            raise NotFound("That comment is gone.", code="comment_not_found")
        # Replies are one level deep; a reply to a reply attaches to its root.
        if parent.parent_id:
            parent = Comment.objects.filter(id=parent.parent_id).first()

    with transaction.atomic():
        comment = Comment.objects.create(
            submission=submission,
            user=request.user,
            body=body[:500],
            parent=parent,
        )
        Submission.objects.filter(id=submission.id).update(
            comment_count=F("comment_count") + 1
        )
        if parent is not None:
            Comment.objects.filter(id=parent.id).update(reply_count=F("reply_count") + 1)
        transaction.on_commit(
            lambda: _notify_comment(submission, request.user, body, parent)
        )
    comment.user = request.user
    return comment_payload(comment, request.user)


def _notify_comment(submission, commenter, body: str, parent=None) -> None:
    """Fire-and-forget push. Never blocks or fails the request."""
    # A reply notifies the comment's author; a top-level comment notifies the maker.
    target = parent.user if parent is not None else submission.user
    if target.id == commenter.id:
        return
    if Block.objects.filter(blocker=target, blocked=commenter).exists():
        return

    def _send():
        try:
            push.send_to_user(
                target,
                title=f"{commenter.name} {'replied' if parent else 'commented'}",
                body=body[:120],
                data={"submission_id": str(submission.id), "type": "comment"},
                collapse_id=f"comment-{submission.id}",
            )
        except push.PushNotConfigured:
            pass
        except Exception:
            logger.exception("comment push failed")

    threading.Thread(target=_send, daemon=True).start()


@comments_router.delete("/{comment_id}", response={204: None})
def delete_comment(request, comment_id: str):
    comment = Comment.objects.select_related("submission").filter(id=comment_id).first()
    if comment is None:
        raise NotFound("Comment not found.", code="comment_not_found")
    if comment.user_id != request.user.id and comment.submission.user_id != request.user.id:
        raise Forbidden()
    with transaction.atomic():
        comment.delete()
        Submission.objects.filter(id=comment.submission_id, comment_count__gt=0).update(
            comment_count=F("comment_count") - 1
        )
    return 204, None


# --- reports ----------------------------------------------------------------


@reports_router.post("", response={201: dict})
def create_report(request, data: ReportIn):
    hit(f"report:{request.user.id}", limit=20, window_seconds=86400)
    if not data.submission_id and not data.comment_id:
        raise ApiError("Nothing to report.", code="report_target_missing")
    Report.objects.create(
        reporter=request.user,
        submission_id=data.submission_id,
        comment_id=data.comment_id,
        reason=data.reason,
        note=data.note[:300],
    )
    return 201, {"received": True}
