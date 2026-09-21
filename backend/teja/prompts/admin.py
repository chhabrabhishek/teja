from django.contrib import admin
from django.db.models import Count

from teja.prompts.models import Prompt


@admin.register(Prompt)
class PromptAdmin(admin.ModelAdmin):
    """The human-review queue. Nothing reaches a user until it's approved here."""

    list_display = ("date", "topic", "category", "text", "is_published", "submissions", "source")
    # `topic` is the leaf that actually decides who sees this; `category` is only
    # the craft it belongs to.
    list_filter = ("is_published", "topic", "category", "source")
    list_editable = ("is_published",)
    list_select_related = ("topic",)
    search_fields = ("text", "nudge", "topic__name")
    autocomplete_fields = ("topic",)
    date_hierarchy = "date"
    ordering = ("date", "topic__sort_order")
    actions = ["publish", "unpublish"]

    def get_queryset(self, request):
        return super().get_queryset(request).annotate(_subs=Count("submissions"))

    @admin.display(description="Responses", ordering="_subs")
    def submissions(self, obj):
        return obj._subs

    @admin.action(description="Publish selected prompts")
    def publish(self, request, queryset):
        updated = queryset.update(is_published=True)
        self.message_user(request, f"{updated} prompt(s) are now live.")

    @admin.action(description="Unpublish selected prompts")
    def unpublish(self, request, queryset):
        queryset.update(is_published=False)
