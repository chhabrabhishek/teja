from __future__ import annotations

import uuid

from django.db import models


class Submission(models.Model):
    class Kind(models.TextChoices):
        TEXT = "text", "Text"
        IMAGE = "image", "Image"

    class Status(models.TextChoices):
        DRAFT = "draft", "Draft"
        PUBLISHED = "published", "Published"

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey("accounts.User", on_delete=models.CASCADE, related_name="submissions")
    prompt = models.ForeignKey("prompts.Prompt", on_delete=models.PROTECT, related_name="submissions")

    kind = models.CharField(max_length=8, choices=Kind.choices, default=Kind.TEXT)
    body = models.TextField(blank=True, default="")  # markdown, or caption for images
    image_key = models.CharField(max_length=255, blank=True, default="")
    image_width = models.IntegerField(null=True, blank=True)
    image_height = models.IntegerField(null=True, blank=True)

    status = models.CharField(max_length=10, choices=Status.choices, default=Status.DRAFT)
    published_at = models.DateTimeField(null=True, blank=True)

    reaction_count = models.IntegerField(default=0)
    comment_count = models.IntegerField(default=0)
    is_removed = models.BooleanField(default=False)

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = "submissions"
        constraints = [
            models.UniqueConstraint(fields=["user", "prompt"], name="uniq_user_prompt")
        ]
        indexes = [
            models.Index(fields=["prompt", "status", "-published_at"]),
            models.Index(fields=["user", "-published_at"]),
        ]

    def __str__(self) -> str:
        return f"{self.user.username} · {self.prompt.date} · {self.status}"

    @property
    def is_published(self) -> bool:
        return self.status == self.Status.PUBLISHED
