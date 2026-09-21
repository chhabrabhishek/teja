from __future__ import annotations

import uuid
from datetime import timedelta

from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin
from django.db import models
from django.utils import timezone
from django.utils.timezone import now as tz_now


class UserManager(BaseUserManager):
    def create_user(self, email: str, **extra):
        if not email:
            raise ValueError("Email is required")
        user = self.model(email=self.normalize_email(email).lower(), **extra)
        user.set_unusable_password()
        user.save(using=self._db)
        Streak.objects.get_or_create(user=user)
        return user

    def create_superuser(self, email: str, password: str, **extra):
        extra.setdefault("is_staff", True)
        extra.setdefault("is_superuser", True)
        user = self.model(email=self.normalize_email(email).lower(), **extra)
        if not user.username:
            user.username = email.split("@")[0][:20]
        user.set_password(password)
        user.save(using=self._db)
        Streak.objects.get_or_create(user=user)
        return user


class User(AbstractBaseUser, PermissionsMixin):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    email = models.EmailField(unique=True)
    apple_sub = models.CharField(max_length=255, unique=True, null=True, blank=True)
    username = models.CharField(max_length=20, unique=True)
    display_name = models.CharField(max_length=40, blank=True)
    bio = models.CharField(max_length=160, blank=True, default="")
    avatar_key = models.CharField(max_length=255, blank=True, default="")
    timezone = models.CharField(max_length=64, default="UTC")
    reminder_hour = models.SmallIntegerField(null=True, blank=True, default=9)
    # Push is opt-out; the daily reminder is local and unaffected by this.
    push_enabled = models.BooleanField(default=True)
    # JSON rather than a Postgres array: we never query it, and this keeps SQLite working.
    preferred_categories = models.JSONField(default=list, blank=True)

    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    # `timezone` is a field name on this model, so the module alias is used here.
    last_seen_at = models.DateTimeField(default=tz_now)

    objects = UserManager()
    USERNAME_FIELD = "email"
    REQUIRED_FIELDS: list[str] = []

    class Meta:
        db_table = "users"

    def __str__(self) -> str:
        return f"@{self.username}"

    @property
    def name(self) -> str:
        return self.display_name or self.username


class EmailCode(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    email = models.EmailField(db_index=True)
    code_hash = models.CharField(max_length=64)
    attempts = models.SmallIntegerField(default=0)
    expires_at = models.DateTimeField()
    consumed_at = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = "email_codes"
        indexes = [models.Index(fields=["email", "-created_at"])]

    def is_valid(self) -> bool:
        return self.consumed_at is None and self.expires_at > timezone.now()


class RefreshToken(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="refresh_tokens")
    token_hash = models.CharField(max_length=64, unique=True)
    device_label = models.CharField(max_length=64, blank=True, default="")
    expires_at = models.DateTimeField()
    revoked_at = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = "refresh_tokens"

    def is_valid(self) -> bool:
        return self.revoked_at is None and self.expires_at > timezone.now()


class Streak(models.Model):
    """One row per user. Written only on publish — no nightly cron."""

    user = models.OneToOneField(User, on_delete=models.CASCADE, primary_key=True, related_name="streak")
    current = models.IntegerField(default=0)
    longest = models.IntegerField(default=0)
    total = models.IntegerField(default=0)
    last_date = models.DateField(null=True, blank=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = "streaks"

    def current_for(self, today) -> int:
        """A stored streak is stale the moment a day is missed; resolve on read."""
        if self.last_date is None:
            return 0
        if self.last_date >= today - timedelta(days=1):
            return self.current
        return 0


class Device(models.Model):
    """An APNs device token. One row per install, not per user."""

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="devices")
    token = models.CharField(max_length=200, unique=True)
    platform = models.CharField(max_length=8, default="ios")
    app_version = models.CharField(max_length=16, blank=True, default="")
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    last_seen_at = models.DateTimeField(default=tz_now)

    class Meta:
        db_table = "devices"
        indexes = [models.Index(fields=["user", "is_active"])]

    def __str__(self) -> str:
        return f"{self.user.username} · {self.platform} · {self.token[:12]}…"


class Block(models.Model):
    blocker = models.ForeignKey(User, on_delete=models.CASCADE, related_name="blocking")
    blocked = models.ForeignKey(User, on_delete=models.CASCADE, related_name="blocked_by")
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = "blocks"
        constraints = [
            models.UniqueConstraint(fields=["blocker", "blocked"], name="uniq_block")
        ]
