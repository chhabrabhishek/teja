from __future__ import annotations

import uuid

from django.db import models


class Category(models.TextChoices):
    WRITING = "writing", "Creative Writing"
    PHOTO = "photo", "Photography"
    SKETCH = "sketch", "Sketch / Art"
    JOKE = "joke", "Joke"


# Fixed, predictable weekly rotation. Predictability is a feature.
WEEKLY_ROTATION = [
    Category.WRITING,  # Mon
    Category.PHOTO,    # Tue
    Category.SKETCH,   # Wed
    Category.WRITING,  # Thu
    Category.JOKE,     # Fri
    Category.PHOTO,    # Sat
    Category.WRITING,  # Sun
]


class Prompt(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    date = models.DateField(unique=True, db_index=True)
    category = models.CharField(max_length=16, choices=Category.choices)
    text = models.CharField(max_length=240)
    nudge = models.CharField(max_length=120, default="Five minutes is enough.")
    source = models.CharField(max_length=16, default="openai")
    is_published = models.BooleanField(default=False, help_text="Human-reviewed and live.")
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = "prompts"
        ordering = ["-date"]

    def __str__(self) -> str:
        return f"{self.date} · {self.get_category_display()} · {self.text[:48]}"

    @property
    def kind(self) -> str:
        """What the client should render in Compose."""
        return "image" if self.category in {Category.PHOTO, Category.SKETCH} else "text"
