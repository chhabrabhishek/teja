"""Opaque keyset cursors. No OFFSET, no duplicate rows on a live feed."""

from __future__ import annotations

import base64
import json
from datetime import datetime


def encode_cursor(dt: datetime, pk) -> str:
    raw = json.dumps({"t": dt.isoformat(), "i": str(pk)}).encode()
    return base64.urlsafe_b64encode(raw).decode().rstrip("=")


def decode_cursor(cursor: str | None) -> tuple[datetime, str] | None:
    if not cursor:
        return None
    try:
        pad = "=" * (-len(cursor) % 4)
        data = json.loads(base64.urlsafe_b64decode(cursor + pad))
        return datetime.fromisoformat(data["t"]), data["i"]
    except Exception:
        return None
