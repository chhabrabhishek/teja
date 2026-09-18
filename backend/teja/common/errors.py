"""Typed API errors. Every failure the client can act on has a stable `code`."""

from __future__ import annotations


class ApiError(Exception):
    status = 400
    code = "bad_request"
    detail = "Bad request."

    def __init__(self, detail: str | None = None, code: str | None = None, status: int | None = None):
        self.detail = detail or self.detail
        self.code = code or self.code
        self.status = status or self.status
        super().__init__(self.detail)


class Unauthorized(ApiError):
    status = 401
    code = "unauthorized"
    detail = "Sign in to continue."


class Forbidden(ApiError):
    status = 403
    code = "forbidden"
    detail = "You can't do that."


class NotFound(ApiError):
    status = 404
    code = "not_found"
    detail = "Not found."


class Conflict(ApiError):
    status = 409
    code = "conflict"
    detail = "Already exists."


class RateLimited(ApiError):
    status = 429
    code = "rate_limited"
    detail = "Too many attempts. Try again in a bit."
