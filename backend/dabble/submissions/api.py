from __future__ import annotations

from collections import defaultdict

from django.db import transaction
from django.db.models import Q
from django.utils import timezone
from ninja import Router

from dabble.accounts.models import Block
from dabble.common.db import for_update
from dabble.common.errors import ApiError, Forbidden, NotFound
from dabble.common.pagination import decode_cursor, encode_cursor
from dabble.common.storage import presign_put
from dabble.prompts.models import Prompt
from dabble.submissions.models import Submission
from dabble.submissions.schemas import (
    PageOut,
    SubmissionOut,
    UploadUrlIn,
    UpsertSubmissionIn,
    submission_payload,
)
from dabble.submissions.streaks import record_publish

submissions_router = Router()
media_router = Router()


# --- shared serialisation ---------------------------------------------------


def annotate_reactions(submissions: list[Submission], viewer) -> tuple[dict, dict]:
    """Two queries for a whole page, instead of two per row."""
    from django.db.models import Count

    from dabble.social.models import Reaction

    ids = [s.id for s in submissions]
    counts: dict = defaultdict(dict)
    for row in (
        Reaction.objects.filter(submission_id__in=ids)
        .values("submission_id", "emoji")
        .annotate(total=Count("id"))
    ):
        counts[row["submission_id"]][row["emoji"]] = row["total"]

    mine: dict = defaultdict(list)
    for sid, emoji in Reaction.objects.filter(
        submission_id__in=ids, user=viewer
    ).values_list("submission_id", "emoji"):
        mine[sid].append(emoji)

    return counts, mine


def serialize_page(queryset, viewer, cursor: str | None, limit: int) -> dict:
    limit = max(1, min(limit, 50))
    decoded = decode_cursor(cursor)
    if decoded:
        ts, last_id = decoded
        queryset = queryset.filter(
            Q(published_at__lt=ts) | Q(published_at=ts, id__lt=last_id)
        )
    rows = list(queryset.select_related("user", "user__streak", "prompt")[: limit + 1])
    has_more = len(rows) > limit
    rows = rows[:limit]

    counts, mine = annotate_reactions(rows, viewer)
    items = [
        submission_payload(
            row,
            viewer,
            my_reactions=mine.get(row.id, []),
            reaction_counts=dict(counts.get(row.id, {})),
        )
        for row in rows
    ]
    next_cursor = (
        encode_cursor(rows[-1].published_at or rows[-1].created_at, rows[-1].id)
        if has_more and rows
        else None
    )
    return {"items": items, "next_cursor": next_cursor}


# --- media ------------------------------------------------------------------


@media_router.post("/upload-url")
def create_upload_url(request, data: UploadUrlIn):
    return presign_put(data.purpose, request.user.id, data.content_type)


# --- submissions ------------------------------------------------------------


@submissions_router.post("", response=SubmissionOut)
def upsert_draft(request, data: UpsertSubmissionIn):
    """Create or update today's draft. Called on every autosave."""
    prompt = Prompt.objects.filter(id=data.prompt_id, is_published=True).first()
    if prompt is None:
        raise NotFound("That prompt doesn't exist.", code="prompt_not_found")

    with transaction.atomic():
        submission, _ = for_update(Submission.objects).get_or_create(
            user=request.user, prompt=prompt, defaults={"kind": data.kind}
        )
        if submission.status == Submission.Status.PUBLISHED:
            raise ApiError("This one's already published.", code="already_published")

        submission.kind = data.kind
        submission.body = data.body[:5000]
        if data.image_key is not None:
            submission.image_key = data.image_key
            submission.image_width = data.image_width
            submission.image_height = data.image_height
        submission.save()

    submission.prompt = prompt
    return submission_payload(submission, request.user)


@submissions_router.post("/{submission_id}/publish")
def publish(request, submission_id: str):
    """The unlock event: publishes, bumps the streak, opens the feed."""
    with transaction.atomic():
        submission = (
            for_update(Submission.objects)
            .select_related("prompt", "user")
            .filter(id=submission_id, user=request.user)
            .first()
        )
        if submission is None:
            raise NotFound("Draft not found.", code="submission_not_found")
        if submission.status == Submission.Status.PUBLISHED:
            return {
                "submission": submission_payload(submission, request.user),
                "streak": record_publish(request.user),
            }

        has_content = bool(submission.body.strip()) or bool(submission.image_key)
        if not has_content:
            raise ApiError("Add something first.", code="empty_submission")
        if submission.kind == Submission.Kind.IMAGE and not submission.image_key:
            raise ApiError("Add a photo first.", code="missing_image")

        submission.status = Submission.Status.PUBLISHED
        submission.published_at = timezone.now()
        submission.save(update_fields=["status", "published_at", "updated_at"])
        streak = record_publish(request.user)

    return {"submission": submission_payload(submission, request.user), "streak": streak}


@submissions_router.get("/{submission_id}", response=SubmissionOut)
def get_submission(request, submission_id: str):
    submission = (
        Submission.objects.select_related("user", "user__streak", "prompt")
        .filter(id=submission_id, is_removed=False)
        .first()
    )
    if submission is None:
        raise NotFound("That creation is gone.", code="submission_not_found")
    if submission.user_id != request.user.id and not submission.is_published:
        raise Forbidden("That creation is still a draft.", code="submission_private")
    if Block.objects.filter(blocker=request.user, blocked=submission.user).exists():
        raise NotFound("That creation is gone.", code="submission_not_found")

    counts, mine = annotate_reactions([submission], request.user)
    return submission_payload(
        submission,
        request.user,
        my_reactions=mine.get(submission.id, []),
        reaction_counts=dict(counts.get(submission.id, {})),
    )


@submissions_router.delete("/{submission_id}", response={204: None})
def delete_submission(request, submission_id: str):
    deleted, _ = Submission.objects.filter(id=submission_id, user=request.user).delete()
    if not deleted:
        raise NotFound("Draft not found.", code="submission_not_found")
    return 204, None


@submissions_router.get("/", response=PageOut)
def my_submissions(request, cursor: str | None = None, limit: int = 20):
    qs = (
        Submission.objects.filter(
            user=request.user, status=Submission.Status.PUBLISHED, is_removed=False
        )
        .select_related("user", "prompt")
        .order_by("-published_at", "-id")
    )
    return serialize_page(qs, request.user, cursor, limit)


__all__ = ["submissions_router", "media_router", "serialize_page", "annotate_reactions"]
