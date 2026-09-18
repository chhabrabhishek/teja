from django.contrib import admin
from django.utils import timezone

from teja.social.models import Comment, Report
from teja.submissions.models import Submission


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
