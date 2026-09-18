"""Sign in with Apple: verify the identity token against Apple's JWKS."""

from __future__ import annotations

import time

import jwt
import requests
from django.conf import settings
from jwt import PyJWKClient

from teja.common.errors import Unauthorized

_jwk_client: PyJWKClient | None = None
_jwk_fetched_at = 0.0
_JWK_TTL = 60 * 60 * 6


def _keys() -> PyJWKClient:
    global _jwk_client, _jwk_fetched_at
    if _jwk_client is None or time.time() - _jwk_fetched_at > _JWK_TTL:
        _jwk_client = PyJWKClient(settings.APPLE_KEYS_URL)
        _jwk_fetched_at = time.time()
    return _jwk_client


def verify_identity_token(identity_token: str, nonce: str | None = None) -> dict:
    """Return the verified Apple claims: {sub, email?, email_verified?}."""
    try:
        signing_key = _keys().get_signing_key_from_jwt(identity_token)
        claims = jwt.decode(
            identity_token,
            signing_key.key,
            algorithms=["RS256"],
            audience=settings.APPLE_BUNDLE_ID,
            issuer=settings.APPLE_ISSUER,
        )
    except (jwt.PyJWTError, requests.RequestException) as exc:
        raise Unauthorized("Couldn't verify your Apple ID.", code="apple_token_invalid") from exc

    if nonce and claims.get("nonce") != nonce:
        raise Unauthorized("Couldn't verify your Apple ID.", code="apple_nonce_mismatch")
    if not claims.get("sub"):
        raise Unauthorized("Couldn't verify your Apple ID.", code="apple_token_invalid")
    return claims
