from __future__ import annotations

from typing import Optional

from django.db.models import Count
from ninja import Router, Schema

from teja.common.errors import ApiError, NotFound
from teja.topics.models import Topic, UserTopic, expand_topic_ids

topics_router = Router()


class TopicOut(Schema):
    id: str
    slug: str
    name: str
    blurb: str
    craft: str
    parent_id: Optional[str] = None
    accepts_prompts: bool
    subscriber_count: int = 0
    is_selected: bool = False
    children: list["TopicOut"] = []


TopicOut.model_rebuild()


class SetTopicsIn(Schema):
    topic_ids: list[str]


def _node(topic: Topic, selected: set, counts: dict) -> dict:
    return {
        "id": str(topic.id),
        "slug": topic.slug,
        "name": topic.name,
        "blurb": topic.blurb,
        "craft": topic.craft,
        "parent_id": str(topic.parent_id) if topic.parent_id else None,
        "accepts_prompts": topic.accepts_prompts,
        "subscriber_count": counts.get(topic.id, 0),
        "is_selected": topic.id in selected,
        "children": [],
    }


@topics_router.get("", response=list[TopicOut])
def list_topics(request):
    """The full tree, with the caller's selections marked."""
    topics = list(Topic.objects.filter(is_active=True).select_related("parent"))
    selected = set(
        UserTopic.objects.filter(user=request.user).values_list("topic_id", flat=True)
    )
    counts = {
        row["id"]: row["n"]
        for row in Topic.objects.filter(is_active=True)
        .annotate(n=Count("subscribers"))
        .values("id", "n")
    }

    nodes = {t.id: _node(t, selected, counts) for t in topics}
    roots = []
    for topic in topics:
        node = nodes[topic.id]
        if topic.parent_id and topic.parent_id in nodes:
            nodes[topic.parent_id]["children"].append(node)
        else:
            roots.append(node)
    return roots


@topics_router.put("/me", response=list[TopicOut])
def set_my_topics(request, data: SetTopicsIn):
    """Replaces the caller's interests wholesale."""
    if len(data.topic_ids) > 40:
        raise ApiError("That's a lot of interests. Pick up to 40.", code="too_many_topics")

    valid = list(
        Topic.objects.filter(id__in=data.topic_ids, is_active=True).values_list(
            "id", flat=True
        )
    )
    if len(valid) != len(set(data.topic_ids)):
        raise NotFound("One of those topics doesn't exist.", code="topic_not_found")

    UserTopic.objects.filter(user=request.user).exclude(topic_id__in=valid).delete()
    existing = set(
        UserTopic.objects.filter(user=request.user).values_list("topic_id", flat=True)
    )
    UserTopic.objects.bulk_create(
        [UserTopic(user=request.user, topic_id=tid) for tid in valid if tid not in existing]
    )
    return list_topics(request)


def subscribed_topic_ids(user) -> list:
    """Every topic the user covers, expanding parents into their children."""
    direct = list(
        UserTopic.objects.filter(user=user).values_list("topic_id", flat=True)
    )
    return expand_topic_ids(direct)
