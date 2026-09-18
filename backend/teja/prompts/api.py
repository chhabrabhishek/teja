from __future__ import annotations

from datetime import date as date_cls
from datetime import datetime, time, timedelta
from zoneinfo import ZoneInfo

from django.utils import timezone
from ninja import Router

from teja.accounts.schemas import streak_payload, user_today
from teja.common.errors import NotFound
from teja.prompts.models import Prompt
from teja.prompts.schemas import PromptOut, TodayOut, prompt_payload

prompts_router = Router()


def seconds_left_today(user) -> int:
    try:
        tz = ZoneInfo(user.timezone)
    except Exception:
        tz = ZoneInfo("UTC")
    now = timezone.now().astimezone(tz)
    midnight = datetime.combine(now.date() + timedelta(days=1), time.min, tzinfo=tz)
    return max(0, int((midnight - now).total_seconds()))


def resolve_prompt(day: date_cls) -> Prompt:
    prompt = Prompt.objects.filter(date=day, is_published=True).first()
    if prompt is None:
        # Never show an error on the home screen: fall back to the most recent live prompt.
        prompt = Prompt.objects.filter(is_published=True, date__lte=day).order_by("-date").first()
    if prompt is None:
        raise NotFound("No prompt yet. Check back soon.", code="prompt_missing")
    return prompt


@prompts_router.get("/today", response=TodayOut)
def today(request):
    """One round trip powers the entire Today screen."""
    from teja.submissions.models import Submission
    from teja.submissions.schemas import submission_payload

    user = request.user
    day = user_today(user)
    prompt = resolve_prompt(day)

    mine = (
        Submission.objects.filter(user=user, prompt=prompt)
        .select_related("user", "prompt")
        .first()
    )
    creator_count = Submission.objects.filter(
        prompt=prompt, status=Submission.Status.PUBLISHED, is_removed=False
    ).count()

    return {
        "prompt": prompt_payload(prompt),
        "seconds_remaining": seconds_left_today(user),
        "creator_count": creator_count,
        "my_submission": submission_payload(mine, user) if mine else None,
        "streak": streak_payload(user),
    }


@prompts_router.get("/{prompt_date}", response=PromptOut)
def prompt_by_date(request, prompt_date: date_cls):
    prompt = Prompt.objects.filter(date=prompt_date, is_published=True).first()
    if prompt is None:
        raise NotFound("No prompt for that day.", code="prompt_missing")
    return prompt_payload(prompt)
