from django.contrib import admin
from django.utils import timezone

from teja.social.models import Comment, Reaction, Report
from teja.submissions.models import Submission


@admin.register(Comment)
class CommentAdmin(admin.ModelAdmin):
    list_display = ("created_at", "user", "thread", "body", "reply_count", "is_removed")
    list_filter = ("is_removed",)
    search_fields = ("body", "user__username", "user__email")
    list_select_related = ("user", "parent", "submission")
    readonly_fields = ("id", "created_at", "reply_count")
    date_hierarchy = "created_at"
    ordering = ("-created_at",)
    actions = ["remove_content", "restore_content"]

    @admin.display(description="Thread")
    def thread(self, obj):
        return "reply" if obj.parent_id else "top level"

    @admin.action(description="Remove (hide from threads)")
    def remove_content(self, request, queryset):
        self.message_user(request, f"{queryset.update(is_removed=True)} removed.")

    @admin.action(description="Restore")
    def restore_content(self, request, queryset):
        self.message_user(request, f"{queryset.update(is_removed=False)} restored.")


@admin.register(Reaction)
class ReactionAdmin(admin.ModelAdmin):
    list_display = ("created_at", "user", "emoji", "submission")
    list_filter = ("emoji",)
    search_fields = ("user__username",)
    list_select_related = ("user", "submission")
    ordering = ("-created_at",)


@admin.register(Report)
class ReportAdmin(admin.ModelAdmin):
    """Moderation queue. Two actions: remove the content, or dismiss."""

    list_display = ("created_at", "reason", "reporter", "submission", "comment", "resolved_at")
    list_filter = ("reason", "resolved_at")
    actions = ["remove_content", "dismiss"]

    @admin.action(description="Remove reported content")
    def remove_content(self, request, queryset):
        for report in queryset:
            if report.submission_id:
                Submission.objects.filter(id=report.submission_id).update(is_removed=True)
            if report.comment_id:
                Comment.objects.filter(id=report.comment_id).update(is_removed=True)
        queryset.update(resolved_at=timezone.now())

    @admin.action(description="Dismiss")
    def dismiss(self, request, queryset):
        queryset.update(resolved_at=timezone.now())
