from __future__ import annotations

from django.conf import settings
from django.db.models import Count, F, Q
from django.db import transaction
from ninja import Router

from teja.accounts.models import Block
from teja.common.errors import ApiError, Forbidden, NotFound
from teja.common.pagination import decode_cursor, encode_cursor
from teja.common.ratelimit import hit
from teja.social.models import Comment, Reaction, Report
from teja.social.schemas import (
    CommentIn,
    CommentPageOut,
    CommentOut,
    ReactionCountsOut,
    ReportIn,
    comment_payload,
)
from teja.submissions.models import Submission

social_router = Router()
comments_router = Router()
reports_router = Router()


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
        Comment.objects.filter(submission=submission, is_removed=False)
        .exclude(user_id__in=blocked_ids)
        .select_related("user")
        .order_by("created_at", "id")
    )
    decoded = decode_cursor(cursor)
    if decoded:
        ts, last_id = decoded
        qs = qs.filter(Q(created_at__gt=ts) | Q(created_at=ts, id__gt=last_id))

    limit = max(1, min(limit, 50))
    rows = list(qs[: limit + 1])
    has_more = len(rows) > limit
    rows = rows[:limit]
    return {
        "items": [comment_payload(c, request.user) for c in rows],
        "next_cursor": encode_cursor(rows[-1].created_at, rows[-1].id) if has_more and rows else None,
    }


@social_router.post("/{submission_id}/comments", response=CommentOut)
def create_comment(request, submission_id: str, data: CommentIn):
    hit(f"comment:{request.user.id}", limit=30, window_seconds=3600)
    body = data.body.strip()
    if not body:
        raise ApiError("Say something first.", code="empty_comment")
    submission = _visible_submission(request, submission_id)
    with transaction.atomic():
        comment = Comment.objects.create(
            submission=submission, user=request.user, body=body[:500]
        )
        Submission.objects.filter(id=submission.id).update(
            comment_count=F("comment_count") + 1
        )
    comment.user = request.user
    return comment_payload(comment, request.user)


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
