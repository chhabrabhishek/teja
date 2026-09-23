"""Passwordless email sign-in: a 6-digit code, hashed with a pepper."""

from __future__ import annotations

import hashlib
import hmac
import secrets
from datetime import timedelta

from django.conf import settings
from django.core.mail import send_mail
from django.utils import timezone

from dabble.accounts.models import EmailCode
from dabble.common.errors import ApiError

SUBJECT = "Your Dabble code"
BODY = (
    "{code} is your Dabble code.\n\n"
    "It expires in 10 minutes. If you didn't ask for this, you can ignore this email.\n"
)


def _hash(code: str) -> str:
    return hashlib.sha256(f"{code}{settings.EMAIL_CODE_PEPPER}".encode()).hexdigest()


def issue_code(email: str) -> int:
    email = email.strip().lower()
    code = f"{secrets.randbelow(1_000_000):06d}"
    EmailCode.objects.filter(email=email, consumed_at__isnull=True).update(
        consumed_at=timezone.now()
    )
    EmailCode.objects.create(
        email=email,
        code_hash=_hash(code),
        expires_at=timezone.now() + timedelta(seconds=settings.EMAIL_CODE_TTL_SECONDS),
    )
    send_mail(
        SUBJECT,
        BODY.format(code=code),
        settings.DEFAULT_FROM_EMAIL,
        [email],
        fail_silently=settings.DEBUG,
    )
    return settings.EMAIL_CODE_TTL_SECONDS


def verify_code(email: str, code: str) -> None:
    email = email.strip().lower()
    row = (
        EmailCode.objects.filter(email=email, consumed_at__isnull=True)
        .order_by("-created_at")
        .first()
    )
    if row is None or not row.is_valid():
        raise ApiError("That code has expired. Send a new one.", code="code_expired")
    if row.attempts >= settings.EMAIL_CODE_MAX_ATTEMPTS:
        raise ApiError("Too many attempts. Send a new code.", code="code_locked")

    if not hmac.compare_digest(row.code_hash, _hash(code.strip())):
        row.attempts += 1
        row.save(update_fields=["attempts"])
        raise ApiError("That code isn't right.", code="code_invalid")

    row.consumed_at = timezone.now()
    row.save(update_fields=["consumed_at"])
