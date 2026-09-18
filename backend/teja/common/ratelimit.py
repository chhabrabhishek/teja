"""Fixed-window rate limiting. Redis when available, Django cache otherwise."""

from __future__ import annotations

import time

from django.conf import settings
from django.core.cache import cache

from teja.common.errors import RateLimited

try:  # optional dependency
    import redis as _redis
except ImportError:  # pragma: no cover
    _redis = None

_client = None
if settings.REDIS_URL and _redis is not None:
    try:
        _client = _redis.from_url(settings.REDIS_URL)
        _client.ping()
    except Exception:  # pragma: no cover - fall back silently
        _client = None


def hit(key: str, limit: int, window_seconds: int, message: str | None = None) -> None:
    bucket = int(time.time() // window_seconds)
    full_key = f"rl:{key}:{bucket}"
    if _client is not None:
        count = _client.incr(full_key)
        if count == 1:
            _client.expire(full_key, window_seconds)
    else:
        count = (cache.get(full_key) or 0) + 1
        cache.set(full_key, count, window_seconds)
    if count > limit:
        raise RateLimited(message or RateLimited.detail)


def client_ip(request) -> str:
    forwarded = request.META.get("HTTP_X_FORWARDED_FOR", "")
    if forwarded:
        return forwarded.split(",")[0].strip()
    return request.META.get("REMOTE_ADDR", "unknown")
