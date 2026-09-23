from __future__ import annotations

import hashlib
from datetime import date as date_cls
from datetime import datetime, time, timedelta
from zoneinfo import ZoneInfo

from django.utils import timezone
from ninja import Router

from dabble.accounts.schemas import streak_payload, user_today
from dabble.common.errors import NotFound
from dabble.prompts.models import Prompt
from dabble.prompts.schemas import PromptOut, TodayOut, prompt_payload
from dabble.topics.api import subscribed_topic_ids

prompts_router = Router()


def seconds_left_today(user) -> int:
    try:
        tz = ZoneInfo(user.timezone)
    except Exception:
        tz = ZoneInfo("UTC")
    now = timezone.now().astimezone(tz)
    midnight = datetime.combine(now.date() + timedelta(days=1), time.min, tzinfo=tz)
    return max(0, int((midnight - now).total_seconds()))


def prompts_for(user, day: date_cls) -> list[Prompt]:
    """Every published prompt available to this user on `day`."""
    topic_ids = subscribed_topic_ids(user)
    qs = Prompt.objects.filter(date=day, is_published=True).select_related("topic")
    if topic_ids:
        qs = qs.filter(topic_id__in=topic_ids)
    return list(qs.order_by("topic__sort_order", "id"))


def pick_daily(user, day: date_cls, candidates: list[Prompt]) -> Prompt | None:
    """Choose one challenge, stably.

    Deterministic on (user, date) so the answer never changes mid-day or between
    requests, but rotates across a user's topics day to day. Needs no stored state.
    """
    if not candidates:
        return None
    digest = hashlib.sha256(f"{user.id}:{day.isoformat()}".encode()).digest()
    return candidates[int.from_bytes(digest[:8], "big") % len(candidates)]


def resolve_prompt(user, day: date_cls) -> Prompt:
    chosen = pick_daily(user, day, prompts_for(user, day))
    if chosen is not None:
        return chosen

    # No topics picked, or none of them have a prompt today: fall back so the
    # home screen is never an error.
    fallback = (
        Prompt.objects.filter(date=day, is_published=True)
        .select_related("topic")
        .order_by("id")
        .first()
        or Prompt.objects.filter(is_published=True, date__lte=day)
        .select_related("topic")
        .order_by("-date")
        .first()
    )
    if fallback is None:
        raise NotFound("No prompt yet. Check back soon.", code="prompt_missing")
    return fallback


@prompts_router.get("/today", response=TodayOut)
def today(request):
    """One round trip powers the entire Today screen."""
    from dabble.submissions.models import Submission
    from dabble.submissions.schemas import submission_payload

    user = request.user
    day = user_today(user)
    prompt = resolve_prompt(user, day)

    mine = (
        Submission.objects.filter(user=user, prompt=prompt)
        .select_related("user", "prompt", "prompt__topic")
        .first()
    )
    creator_count = Submission.objects.filter(
        prompt=prompt, status=Submission.Status.PUBLISHED, is_removed=False
    ).count()

    others = [p for p in prompts_for(user, day) if p.id != prompt.id]

    return {
        "prompt": prompt_payload(prompt),
        "seconds_remaining": seconds_left_today(user),
        "creator_count": creator_count,
        "my_submission": submission_payload(mine, user) if mine else None,
        "streak": streak_payload(user),
        "other_prompts": [prompt_payload(p) for p in others],
    }


@prompts_router.get("/{prompt_id}", response=PromptOut)
def prompt_detail(request, prompt_id: str):
    prompt = (
        Prompt.objects.filter(id=prompt_id, is_published=True)
        .select_related("topic")
        .first()
    )
    if prompt is None:
        raise NotFound("That prompt doesn't exist.", code="prompt_missing")
    return prompt_payload(prompt)
