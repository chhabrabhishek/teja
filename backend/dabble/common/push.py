"""APNs HTTP/2 sender.

Talks to Apple directly rather than through Firebase: one fewer SDK, one fewer
vendor, and the whole protocol is a signed JWT plus an HTTP/2 POST.

Required settings:
    APNS_KEY_ID      — the 10-char key id from the .p8 filename
    APNS_TEAM_ID     — your Apple developer team id
    APNS_KEY_PATH    — path to AuthKey_XXXXXXXXXX.p8  (or APNS_KEY_CONTENT)
    APNS_BUNDLE_ID   — defaults to APPLE_BUNDLE_ID
    APNS_USE_SANDBOX — true for debug builds installed from Xcode
"""

from __future__ import annotations

import logging
import threading
import time
from dataclasses import dataclass

import httpx
import jwt
from django.conf import settings

logger = logging.getLogger(__name__)

_PROD_HOST = "https://api.push.apple.com"
_SANDBOX_HOST = "https://api.sandbox.push.apple.com"

# Apple rejects tokens older than 1h and throttles re-signing; 50m is the sweet spot.
_TOKEN_TTL = 50 * 60

_lock = threading.Lock()
_cached_jwt: str | None = None
_signed_at: float = 0.0


class PushNotConfigured(RuntimeError):
    pass


@dataclass(frozen=True)
class PushResult:
    sent: int
    failed: int
    deactivated: int


def is_configured() -> bool:
    return bool(
        settings.APNS_KEY_ID
        and settings.APNS_TEAM_ID
        and (settings.APNS_KEY_CONTENT or settings.APNS_KEY_PATH)
    )


def _private_key() -> str:
    if settings.APNS_KEY_CONTENT:
        return settings.APNS_KEY_CONTENT.replace("\\n", "\n")
    with open(settings.APNS_KEY_PATH) as handle:
        return handle.read()


def _provider_token() -> str:
    global _cached_jwt, _signed_at
    if _cached_jwt and time.monotonic() - _signed_at < _TOKEN_TTL:
        return _cached_jwt
    with _lock:
        if _cached_jwt and time.monotonic() - _signed_at < _TOKEN_TTL:
            return _cached_jwt
        if not is_configured():
            raise PushNotConfigured("APNS_KEY_ID, APNS_TEAM_ID and a key are required.")
        _cached_jwt = jwt.encode(
            {"iss": settings.APNS_TEAM_ID, "iat": int(time.time())},
            _private_key(),
            algorithm="ES256",
            headers={"kid": settings.APNS_KEY_ID},
        )
        _signed_at = time.monotonic()
        return _cached_jwt


def send(
    tokens: list[str],
    *,
    title: str,
    body: str,
    data: dict | None = None,
    collapse_id: str | None = None,
) -> PushResult:
    """Deliver to each token. Never raises for per-device failures."""
    if not tokens:
        return PushResult(0, 0, 0)

    from dabble.accounts.models import Device

    host = _SANDBOX_HOST if settings.APNS_USE_SANDBOX else _PROD_HOST
    auth = _provider_token()
    payload = {
        "aps": {
            "alert": {"title": title, "body": body},
            "sound": "default",
            # Let the client own the badge count; a wrong number is worse than none.
            "thread-id": "dabble",
        },
        **(data or {}),
    }

    sent = failed = deactivated = 0
    dead: list[str] = []

    with httpx.Client(http2=True, timeout=15.0) as client:
        for token in tokens:
            headers = {
                "authorization": f"bearer {auth}",
                "apns-topic": settings.APNS_BUNDLE_ID,
                "apns-push-type": "alert",
                "apns-priority": "10",
            }
            if collapse_id:
                headers["apns-collapse-id"] = collapse_id[:64]
            try:
                response = client.post(
                    f"{host}/3/device/{token}", headers=headers, json=payload
                )
            except httpx.HTTPError as exc:
                failed += 1
                logger.warning("APNs transport error for %s…: %s", token[:12], exc)
                continue

            if response.status_code == 200:
                sent += 1
                continue

            failed += 1
            reason = ""
            try:
                reason = response.json().get("reason", "")
            except Exception:
                reason = response.text[:120]

            # Apple's way of saying the app was deleted or the token is stale.
            if response.status_code in (400, 410) and reason in (
                "BadDeviceToken",
                "Unregistered",
                "DeviceTokenNotForTopic",
            ):
                dead.append(token)
            else:
                logger.warning("APNs %s for %s…: %s", response.status_code, token[:12], reason)

    if dead:
        deactivated = Device.objects.filter(token__in=dead).update(is_active=False)

    return PushResult(sent=sent, failed=failed, deactivated=deactivated)


def send_to_user(user, *, title: str, body: str, data: dict | None = None,
                 collapse_id: str | None = None) -> PushResult:
    from dabble.accounts.models import Device

    if not user.push_enabled:
        return PushResult(0, 0, 0)
    tokens = list(
        Device.objects.filter(user=user, is_active=True).values_list("token", flat=True)
    )
    return send(tokens, title=title, body=body, data=data, collapse_id=collapse_id)
