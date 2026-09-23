"""The only real business logic in the product."""

from __future__ import annotations

from datetime import timedelta

from django.db import transaction

from dabble.accounts.models import Streak
from dabble.accounts.schemas import user_today
from dabble.common.db import for_update


@transaction.atomic
def record_publish(user) -> dict:
    """Idempotent per day. Called once, on publish."""
    streak, _ = for_update(Streak.objects).get_or_create(user=user)
    today = user_today(user)

    if streak.last_date == today:
        return _payload(streak, today)

    if streak.last_date == today - timedelta(days=1):
        streak.current += 1
    else:
        streak.current = 1

    streak.longest = max(streak.longest, streak.current)
    streak.total += 1
    streak.last_date = today
    streak.save(update_fields=["current", "longest", "total", "last_date", "updated_at"])
    return _payload(streak, today)


def _payload(streak: Streak, today) -> dict:
    return {
        "current": streak.current_for(today),
        "longest": streak.longest,
        "total": streak.total,
        "last_date": streak.last_date,
    }
