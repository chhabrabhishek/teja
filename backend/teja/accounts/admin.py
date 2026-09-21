from django.contrib import admin

from teja.accounts.models import Block, Device, EmailCode, RefreshToken, Streak, User


class StreakInline(admin.StackedInline):
    model = Streak
    can_delete = False
    readonly_fields = ("current", "longest", "total", "last_date", "updated_at")
    extra = 0


class DeviceInline(admin.TabularInline):
    model = Device
    extra = 0
    fields = ("platform", "token", "app_version", "is_active", "last_seen_at")
    readonly_fields = ("token", "last_seen_at")


@admin.register(User)
class UserAdmin(admin.ModelAdmin):
    list_display = (
        "username",
        "email",
        "display_name",
        "streak_current",
        "streak_total",
        "topic_count",
        "reminder_hour",
        "push_enabled",
        "is_active",
        "created_at",
    )
    list_filter = ("is_active", "is_staff", "push_enabled", "timezone")
    search_fields = ("username", "email", "display_name", "bio")
    readonly_fields = ("id", "created_at", "last_seen_at", "apple_sub", "password")
    inlines = [StreakInline, DeviceInline]
    ordering = ("-created_at",)
    fieldsets = (
        (None, {"fields": ("id", "username", "email", "display_name", "bio", "avatar_key")}),
        ("Practice", {"fields": ("timezone", "reminder_hour", "push_enabled", "preferred_categories")}),
        ("Access", {"fields": ("is_active", "is_staff", "is_superuser", "groups", "user_permissions")}),
        ("Apple", {"fields": ("apple_sub",), "classes": ("collapse",)}),
        ("Timestamps", {"fields": ("created_at", "last_seen_at"), "classes": ("collapse",)}),
    )
    filter_horizontal = ("groups", "user_permissions")

    @admin.display(description="Streak")
    def streak_current(self, obj):
        return getattr(obj.streak, "current", 0) if hasattr(obj, "streak") else 0

    @admin.display(description="Made")
    def streak_total(self, obj):
        return getattr(obj.streak, "total", 0) if hasattr(obj, "streak") else 0

    @admin.display(description="Topics")
    def topic_count(self, obj):
        return obj.topic_links.count()


@admin.register(Device)
class DeviceAdmin(admin.ModelAdmin):
    list_display = ("user", "platform", "short_token", "app_version", "is_active", "last_seen_at")
    list_filter = ("platform", "is_active")
    search_fields = ("user__username", "user__email", "token")
    list_select_related = ("user",)
    readonly_fields = ("token", "created_at", "last_seen_at")

    @admin.display(description="Token")
    def short_token(self, obj):
        return f"{obj.token[:12]}…"


@admin.register(Streak)
class StreakAdmin(admin.ModelAdmin):
    list_display = ("user", "current", "longest", "total", "last_date", "updated_at")
    search_fields = ("user__username", "user__email")
    list_select_related = ("user",)
    ordering = ("-longest",)


@admin.register(Block)
class BlockAdmin(admin.ModelAdmin):
    list_display = ("blocker", "blocked", "created_at")
    search_fields = ("blocker__username", "blocked__username")
    list_select_related = ("blocker", "blocked")


@admin.register(EmailCode)
class EmailCodeAdmin(admin.ModelAdmin):
    """Read-only: codes are hashed, and this exists to debug delivery, not to log in."""

    list_display = ("email", "attempts", "expires_at", "consumed_at", "created_at")
    list_filter = ("consumed_at",)
    search_fields = ("email",)
    readonly_fields = ("email", "code_hash", "attempts", "expires_at", "consumed_at", "created_at")

    def has_add_permission(self, request):
        return False


@admin.register(RefreshToken)
class RefreshTokenAdmin(admin.ModelAdmin):
    list_display = ("user", "device_label", "expires_at", "revoked_at", "created_at")
    list_filter = ("revoked_at",)
    search_fields = ("user__username", "user__email")
    list_select_related = ("user",)
    readonly_fields = ("token_hash",)
    actions = ["revoke"]

    @admin.action(description="Revoke selected sessions")
    def revoke(self, request, queryset):
        from django.utils import timezone

        updated = queryset.filter(revoked_at__isnull=True).update(revoked_at=timezone.now())
        self.message_user(request, f"{updated} session(s) revoked.")
