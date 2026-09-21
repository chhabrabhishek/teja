from django.contrib import admin
from django.db.models import Count

from teja.topics.models import Topic, UserTopic


class ChildInline(admin.TabularInline):
    model = Topic
    fk_name = "parent"
    extra = 0
    fields = ("name", "slug", "craft", "accepts_prompts", "sort_order", "is_active")
    show_change_link = True


@admin.register(Topic)
class TopicAdmin(admin.ModelAdmin):
    """The interest tree. Leaves carry prompts; roots only group and subscribe."""

    list_display = (
        "indented_name",
        "slug",
        "craft",
        "level",
        "accepts_prompts",
        "prompt_count",
        "subscriber_count",
        "is_active",
    )
    list_filter = ("craft", "is_active", "accepts_prompts", "parent")
    list_editable = ("is_active",)
    search_fields = ("name", "slug", "blurb")
    list_select_related = ("parent",)
    inlines = [ChildInline]
    ordering = ("craft", "sort_order")
    actions = ["activate", "deactivate"]

    def get_queryset(self, request):
        return (
            super()
            .get_queryset(request)
            .annotate(_prompts=Count("prompts", distinct=True))
            .annotate(_subs=Count("subscribers", distinct=True))
        )

    @admin.display(description="Topic", ordering="name")
    def indented_name(self, obj):
        return obj.name if obj.parent_id is None else f"— {obj.name}"

    @admin.display(description="Level")
    def level(self, obj):
        return "root" if obj.parent_id is None else "leaf"

    @admin.display(description="Prompts", ordering="_prompts")
    def prompt_count(self, obj):
        return obj._prompts

    @admin.display(description="Followers", ordering="_subs")
    def subscriber_count(self, obj):
        return obj._subs

    @admin.action(description="Activate selected topics")
    def activate(self, request, queryset):
        queryset.update(is_active=True)

    @admin.action(description="Deactivate selected topics")
    def deactivate(self, request, queryset):
        updated = queryset.update(is_active=False)
        self.message_user(
            request,
            f"{updated} deactivated. Run `seed_topics --remap` to re-home their prompts.",
        )


@admin.register(UserTopic)
class UserTopicAdmin(admin.ModelAdmin):
    list_display = ("user", "topic", "created_at")
    list_filter = ("topic__craft", "topic")
    search_fields = ("user__username", "user__email", "topic__name")
    list_select_related = ("user", "topic")
    autocomplete_fields = ("user", "topic")
