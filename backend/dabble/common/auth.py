"""JWT issuing / verification and the Ninja auth class."""

from __future__ import annotations

import hashlib
import secrets
import uuid
from datetime import datetime, timedelta, timezone

import jwt
from django.conf import settings
from ninja.security import HttpBearer

from dabble.common.errors import Unauthorized


def _now() -> datetime:
    return datetime.now(tz=timezone.utc)


def issue_access_token(user) -> tuple[str, int]:
    expires_in = settings.JWT_ACCESS_MINUTES * 60
    payload = {
        "sub": str(user.id),
        "typ": "access",
        "iat": int(_now().timestamp()),
        "exp": int((_now() + timedelta(seconds=expires_in)).timestamp()),
        "jti": uuid.uuid4().hex,
    }
    token = jwt.encode(payload, settings.JWT_SECRET, algorithm=settings.JWT_ALGORITHM)
    return token, expires_in


def hash_token(raw: str) -> str:
    return hashlib.sha256(raw.encode()).hexdigest()


def issue_refresh_token(user, device_label: str = "") -> str:
    from dabble.accounts.models import RefreshToken

    raw = secrets.token_urlsafe(48)
    RefreshToken.objects.create(
        user=user,
        token_hash=hash_token(raw),
        expires_at=_now() + timedelta(days=settings.JWT_REFRESH_DAYS),
        device_label=device_label[:64],
    )
    return raw


def rotate_refresh_token(raw: str):
    """Consume a refresh token and return (user, new_raw). Rotation detects replay."""
    from dabble.accounts.models import RefreshToken

    row = RefreshToken.objects.filter(token_hash=hash_token(raw)).select_related("user").first()
    if row is None or not row.is_valid():
        raise Unauthorized("Session expired. Please sign in again.", code="refresh_invalid")
    row.revoked_at = _now()
    row.save(update_fields=["revoked_at"])
    return row.user, issue_refresh_token(row.user, row.device_label)


def revoke_refresh_token(raw: str) -> None:
    from dabble.accounts.models import RefreshToken

    RefreshToken.objects.filter(token_hash=hash_token(raw), revoked_at__isnull=True).update(
        revoked_at=_now()
    )


class JWTAuth(HttpBearer):
    def authenticate(self, request, token: str):
        from dabble.accounts.models import User

        try:
            payload = jwt.decode(
                token, settings.JWT_SECRET, algorithms=[settings.JWT_ALGORITHM]
            )
        except jwt.PyJWTError:
            return None
        if payload.get("typ") != "access":
            return None
        user = User.objects.filter(id=payload.get("sub"), is_active=True).first()
        if user is None:
            return None
        request.user = user
        return user
