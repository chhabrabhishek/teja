from __future__ import annotations

import re
import secrets
from datetime import date
from typing import Optional
from zoneinfo import ZoneInfo, available_timezones

from django.utils import timezone
from ninja import Schema
from pydantic import EmailStr, field_validator

from dabble.accounts.models import Streak, User
from dabble.common.storage import public_url

USERNAME_RE = re.compile(r"^[a-z0-9_]{3,20}$")


# --- output -----------------------------------------------------------------


class StreakOut(Schema):
    current: int
    longest: int
    total: int
    last_date: Optional[date] = None


class UserOut(Schema):
    """Always built from a plain dict (see `me_payload`), never from a model
    instance — so no `resolve_*` hooks, which only work on attribute access."""

    id: str
    username: str
    display_name: str
    bio: str
    avatar_url: Optional[str] = None


class MeOut(UserOut):
    email: EmailStr
    timezone: str
    reminder_hour: Optional[int] = None
    push_enabled: bool = True
    preferred_categories: list[str] = []
    streak: StreakOut


class ProfileOut(UserOut):
    streak: StreakOut
    is_blocked: bool = False


class TokenPair(Schema):
    access_token: str
    refresh_token: str
    expires_in: int
    is_new_user: bool
    user: MeOut


# --- input ------------------------------------------------------------------


class AppleSignInIn(Schema):
    identity_token: str
    nonce: Optional[str] = None
    full_name: Optional[str] = None
    timezone: Optional[str] = None


class EmailRequestIn(Schema):
    email: EmailStr


class EmailVerifyIn(Schema):
    email: EmailStr
    code: str
    timezone: Optional[str] = None


class RefreshIn(Schema):
    refresh_token: str


class DeviceIn(Schema):
    token: str
    platform: str = "ios"
    app_version: str = ""


class UpdateMeIn(Schema):
    display_name: Optional[str] = None
    username: Optional[str] = None
    bio: Optional[str] = None
    avatar_key: Optional[str] = None
    timezone: Optional[str] = None
    reminder_hour: Optional[int] = None
    push_enabled: Optional[bool] = None
    preferred_categories: Optional[list[str]] = None

    @field_validator("username")
    @classmethod
    def _username(cls, v):
        if v is not None and not USERNAME_RE.match(v.lower()):
            raise ValueError("3–20 characters, lowercase letters, numbers or underscore.")
        return v.lower() if v else v

    @field_validator("timezone")
    @classmethod
    def _tz(cls, v):
        if v is not None and v not in available_timezones():
            raise ValueError("Unknown timezone.")
        return v


# --- helpers ----------------------------------------------------------------


def user_today(user: User) -> date:
    try:
        tz = ZoneInfo(user.timezone)
    except Exception:
        tz = ZoneInfo("UTC")
    return timezone.now().astimezone(tz).date()


def streak_payload(user: User) -> dict:
    streak, _ = Streak.objects.get_or_create(user=user)
    return {
        "current": streak.current_for(user_today(user)),
        "longest": streak.longest,
        "total": streak.total,
        "last_date": streak.last_date,
    }


def me_payload(user: User) -> dict:
    return {
        "id": str(user.id),
        "username": user.username,
        "display_name": user.name,
        "bio": user.bio,
        "avatar_url": public_url(user.avatar_key) if user.avatar_key else None,
        "email": user.email,
        "timezone": user.timezone,
        "reminder_hour": user.reminder_hour,
        "push_enabled": user.push_enabled,
        "preferred_categories": user.preferred_categories,
        "streak": streak_payload(user),
    }


def unique_username(seed: str) -> str:
    base = re.sub(r"[^a-z0-9_]", "", (seed or "maker").lower())[:14] or "maker"
    if len(base) < 3:
        base = f"{base}maker"[:14]
    candidate = base
    while User.objects.filter(username=candidate).exists():
        candidate = f"{base}{secrets.randbelow(9000) + 1000}"[:20]
    return candidate
