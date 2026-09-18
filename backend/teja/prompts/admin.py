from django.contrib import admin

from teja.prompts.models import Prompt


@admin.register(Prompt)
class PromptAdmin(admin.ModelAdmin):
    """The human-review queue. Nothing reaches a user until it's approved here."""

    list_display = ("date", "category", "text", "is_published", "source")
    list_filter = ("is_published", "category", "source")
    list_editable = ("is_published",)
    search_fields = ("text",)
    date_hierarchy = "date"
    ordering = ("date",)
    actions = ["publish", "unpublish"]

    @admin.action(description="Publish selected prompts")
    def publish(self, request, queryset):
        updated = queryset.update(is_published=True)
        self.message_user(request, f"{updated} prompt(s) are now live.")

    @admin.action(description="Unpublish selected prompts")
    def unpublish(self, request, queryset):
        queryset.update(is_published=False)
