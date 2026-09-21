from __future__ import annotations

from datetime import date
from typing import Optional

from ninja import Schema


class PromptOut(Schema):
    id: str
    date: date
    category: str
    category_label: str
    kind: str
    text: str
    nudge: str
    topic_id: Optional[str] = None
    topic_name: Optional[str] = None
    topic_path: Optional[str] = None


class TodayOut(Schema):
    prompt: PromptOut
    seconds_remaining: int
    creator_count: int
    my_submission: Optional[dict] = None
    streak: dict
    other_prompts: list[PromptOut] = []


def prompt_payload(prompt) -> dict:
    topic = getattr(prompt, "topic", None)
    return {
        "id": str(prompt.id),
        "date": prompt.date,
        "category": prompt.category,
        "category_label": prompt.get_category_display(),
        "kind": prompt.kind,
        "text": prompt.text,
        "nudge": prompt.nudge,
        "topic_id": str(topic.id) if topic else None,
        "topic_name": topic.name if topic else None,
        "topic_path": topic.path if topic else None,
    }
