from __future__ import annotations

from datetime import datetime
from typing import Literal, Optional

from ninja import Schema

from teja.common.storage import public_url


class CommentIn(Schema):
    body: str


class CommentOut(Schema):
    id: str
    body: str
    created_at: datetime
    is_mine: bool
    author_username: str
    author_name: str
    author_avatar_url: Optional[str] = None


class CommentPageOut(Schema):
    items: list[CommentOut]
    next_cursor: Optional[str] = None


class ReportIn(Schema):
    submission_id: Optional[str] = None
    comment_id: Optional[str] = None
    reason: Literal["spam", "harassment", "nsfw", "other"]
    note: str = ""


class ReactionCountsOut(Schema):
    reaction_counts: dict[str, int]
    my_reactions: list[str]
    reaction_count: int


def comment_payload(comment, viewer) -> dict:
    return {
        "id": str(comment.id),
        "body": comment.body,
        "created_at": comment.created_at,
        "is_mine": comment.user_id == viewer.id,
        "author_username": comment.user.username,
        "author_name": comment.user.name,
        "author_avatar_url": public_url(comment.user.avatar_key)
        if comment.user.avatar_key
        else None,
    }
