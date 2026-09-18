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


class TodayOut(Schema):
    prompt: PromptOut
    seconds_remaining: int
    creator_count: int
    my_submission: Optional[dict] = None
    streak: dict


def prompt_payload(prompt) -> dict:
    return {
        "id": str(prompt.id),
        "date": prompt.date,
        "category": prompt.category,
        "category_label": prompt.get_category_display(),
        "kind": prompt.kind,
        "text": prompt.text,
        "nudge": prompt.nudge,
    }
