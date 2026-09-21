from __future__ import annotations

from datetime import date, datetime
from typing import Literal, Optional

from ninja import Schema

from teja.common.storage import public_url


class UpsertSubmissionIn(Schema):
    prompt_id: str
    kind: Literal["text", "image"] = "text"
    body: str = ""
    image_key: Optional[str] = None
    image_width: Optional[int] = None
    image_height: Optional[int] = None


class UploadUrlIn(Schema):
    content_type: str
    purpose: Literal["submission", "avatar"] = "submission"


class AuthorOut(Schema):
    id: str
    username: str
    display_name: str
    avatar_url: Optional[str] = None
    streak: int = 0


class SubmissionOut(Schema):
    id: str
    kind: str
    body: str
    image_url: Optional[str] = None
    image_width: Optional[int] = None
    image_height: Optional[int] = None
    status: str
    published_at: Optional[datetime] = None
    created_at: datetime
    reaction_count: int
    comment_count: int
    is_mine: bool
    author: AuthorOut
    prompt_id: str
    prompt_text: str
    prompt_category: str
    prompt_nudge: str = ""
    prompt_date: Optional[date] = None
    topic_name: Optional[str] = None
    topic_path: Optional[str] = None
    my_reactions: list[str] = []
    reaction_counts: dict[str, int] = {}


class PageOut(Schema):
    items: list[SubmissionOut]
    next_cursor: Optional[str] = None


def author_payload(user) -> dict:
    streak = getattr(user, "streak", None)
    return {
        "id": str(user.id),
        "username": user.username,
        "display_name": user.name,
        "avatar_url": public_url(user.avatar_key) if user.avatar_key else None,
        "streak": streak.current if streak else 0,
    }


def submission_payload(
    submission,
    viewer,
    *,
    my_reactions: list[str] | None = None,
    reaction_counts: dict[str, int] | None = None,
) -> dict:
    topic = getattr(submission.prompt, "topic", None)
    return {
        "id": str(submission.id),
        "kind": submission.kind,
        "body": submission.body,
        "image_url": public_url(submission.image_key) if submission.image_key else None,
        "image_width": submission.image_width,
        "image_height": submission.image_height,
        "status": submission.status,
        "published_at": submission.published_at,
        "created_at": submission.created_at,
        "reaction_count": submission.reaction_count,
        "comment_count": submission.comment_count,
        "is_mine": viewer is not None and submission.user_id == viewer.id,
        "author": author_payload(submission.user),
        "prompt_id": str(submission.prompt_id),
        "prompt_text": submission.prompt.text,
        "prompt_category": submission.prompt.category,
        "prompt_nudge": submission.prompt.nudge,
        "prompt_date": submission.prompt.date,
        "topic_name": topic.name if topic else None,
        "topic_path": topic.path if topic else None,
        "my_reactions": my_reactions or [],
        "reaction_counts": reaction_counts or {},
    }
