from __future__ import annotations

import uuid

from django.db import models


class Reaction(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    submission = models.ForeignKey(
        "submissions.Submission", on_delete=models.CASCADE, related_name="reactions"
    )
    user = models.ForeignKey("accounts.User", on_delete=models.CASCADE, related_name="reactions")
    emoji = models.CharField(max_length=8)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = "reactions"
        constraints = [
            models.UniqueConstraint(
                fields=["submission", "user", "emoji"], name="uniq_reaction"
            )
        ]
        indexes = [models.Index(fields=["submission", "emoji"])]


class Comment(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    submission = models.ForeignKey(
        "submissions.Submission", on_delete=models.CASCADE, related_name="comments"
    )
    user = models.ForeignKey("accounts.User", on_delete=models.CASCADE, related_name="comments")
    body = models.CharField(max_length=500)
    is_removed = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = "comments"
        ordering = ["created_at"]
        indexes = [models.Index(fields=["submission", "created_at"])]


class Report(models.Model):
    class Reason(models.TextChoices):
        SPAM = "spam", "Spam"
        HARASSMENT = "harassment", "Harassment"
        NSFW = "nsfw", "Adult content"
        OTHER = "other", "Other"

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    reporter = models.ForeignKey("accounts.User", on_delete=models.CASCADE, related_name="reports")
    submission = models.ForeignKey(
        "submissions.Submission", on_delete=models.CASCADE, null=True, blank=True
    )
    comment = models.ForeignKey(Comment, on_delete=models.CASCADE, null=True, blank=True)
    reason = models.CharField(max_length=16, choices=Reason.choices)
    note = models.CharField(max_length=300, blank=True, default="")
    resolved_at = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = "reports"
        ordering = ["-created_at"]
