from django.contrib import admin

from teja.submissions.models import Submission


@admin.register(Submission)
class SubmissionAdmin(admin.ModelAdmin):
    list_display = (
        "created_at",
        "user",
        "topic",
        "kind",
        "status",
        "excerpt",
        "reaction_count",
        "comment_count",
        "is_removed",
    )
    list_filter = ("status", "kind", "is_removed", "prompt__topic", "prompt__category")
    search_fields = ("user__username", "user__email", "body", "prompt__text")
    list_select_related = ("user", "prompt", "prompt__topic")
    readonly_fields = ("id", "created_at", "updated_at", "published_at", "reaction_count", "comment_count")
    date_hierarchy = "created_at"
    ordering = ("-created_at",)
    actions = ["remove_content", "restore_content"]

    @admin.display(description="Topic", ordering="prompt__topic")
    def topic(self, obj):
        return obj.prompt.topic.name if obj.prompt.topic_id else "—"

    @admin.display(description="Content")
    def excerpt(self, obj):
        if obj.image_key and not obj.body:
            return "[image]"
        return (obj.body[:60] + "…") if len(obj.body) > 60 else obj.body

    @admin.action(description="Remove (hide from feeds)")
    def remove_content(self, request, queryset):
        self.message_user(request, f"{queryset.update(is_removed=True)} removed.")

    @admin.action(description="Restore")
    def restore_content(self, request, queryset):
        self.message_user(request, f"{queryset.update(is_removed=False)} restored.")
