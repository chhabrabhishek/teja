"""Presigned uploads for S3 / Cloudflare R2. Media never touches the API server."""

from __future__ import annotations

import uuid
from functools import lru_cache

import boto3
from botocore.client import Config
from django.conf import settings

from teja.common.errors import ApiError

_EXT = {
    "image/jpeg": "jpg",
    "image/png": "png",
    "image/heic": "heic",
    "image/webp": "webp",
}


@lru_cache(maxsize=1)
def _client():
    return boto3.client(
        "s3",
        region_name=settings.MEDIA_REGION,
        endpoint_url=settings.MEDIA_ENDPOINT_URL,
        config=Config(signature_version="s3v4"),
    )


def build_key(purpose: str, user_id, content_type: str) -> str:
    ext = _EXT.get(content_type, "bin")
    return f"{purpose}/{user_id}/{uuid.uuid4().hex}.{ext}"


def presign_put(purpose: str, user_id, content_type: str, expires_in: int = 300) -> dict:
    if content_type not in settings.MEDIA_ALLOWED_TYPES:
        raise ApiError("That file type isn't supported.", code="unsupported_media_type")
    key = build_key(purpose, user_id, content_type)
    url = _client().generate_presigned_url(
        "put_object",
        Params={
            "Bucket": settings.MEDIA_BUCKET,
            "Key": key,
            "ContentType": content_type,
        },
        ExpiresIn=expires_in,
    )
    return {
        "key": key,
        "upload_url": url,
        "headers": {"Content-Type": content_type},
        "public_url": public_url(key),
        "max_bytes": settings.MEDIA_MAX_BYTES,
        "expires_in": expires_in,
    }


def public_url(key: str | None) -> str | None:
    if not key:
        return None
    if settings.MEDIA_PUBLIC_BASE_URL:
        return f"{settings.MEDIA_PUBLIC_BASE_URL}/{key}"
    return f"{settings.MEDIA_ENDPOINT_URL}/{settings.MEDIA_BUCKET}/{key}"
