"""NinjaAPI assembly. One place to see the whole surface area."""

from __future__ import annotations

import logging

from ninja import NinjaAPI

from teja.accounts.api import auth_router, me_router, users_router
from teja.common.auth import JWTAuth
from teja.common.errors import ApiError
from teja.feed.api import feed_router
from teja.prompts.api import prompts_router
from teja.social.api import comments_router, reports_router, social_router
from teja.submissions.api import media_router, submissions_router
from teja.topics.api import topics_router

log = logging.getLogger(__name__)

api = NinjaAPI(title="Teja API", version="1.0.0", auth=JWTAuth(), urls_namespace="teja")

api.add_router("/auth", auth_router, tags=["auth"])
api.add_router("/me", me_router, tags=["me"])
api.add_router("/users", users_router, tags=["users"])
api.add_router("/prompts", prompts_router, tags=["prompts"])
api.add_router("/topics", topics_router, tags=["topics"])
api.add_router("/media", media_router, tags=["media"])
api.add_router("/submissions", submissions_router, tags=["submissions"])
api.add_router("/submissions", social_router, tags=["social"])
api.add_router("/comments", comments_router, tags=["social"])
api.add_router("/reports", reports_router, tags=["social"])
api.add_router("/feed", feed_router, tags=["feed"])


@api.exception_handler(ApiError)
def handle_api_error(request, exc: ApiError):
    return api.create_response(
        request, {"detail": exc.detail, "code": exc.code}, status=exc.status
    )


@api.exception_handler(Exception)
def handle_unexpected(request, exc: Exception):
    log.exception("unhandled api error")
    return api.create_response(
        request,
        {"detail": "Something went wrong.", "code": "internal_error"},
        status=500,
    )
