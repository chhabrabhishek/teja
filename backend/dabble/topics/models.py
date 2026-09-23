from __future__ import annotations

import uuid

from django.db import models


class Craft(models.TextChoices):
    """The response type. Inherited from a topic's root ancestor."""

    WRITING = "writing", "Creative Writing"
    PHOTO = "photo", "Photography"
    SKETCH = "sketch", "Sketch / Art"
    JOKE = "joke", "Joke"


class Topic(models.Model):
    """A node in the interest tree, e.g. Creative Writing → Poetry → Haiku.

    Deliberately an adjacency list rather than MPTT: the tree is two or three
    levels deep and edited by hand a few times a year, so the extra dependency
    and the write cost of nested sets buy nothing.
    """

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    slug = models.SlugField(max_length=64, unique=True)
    name = models.CharField(max_length=64)
    blurb = models.CharField(max_length=120, blank=True, default="")
    parent = models.ForeignKey(
        "self", on_delete=models.CASCADE, null=True, blank=True, related_name="children"
    )
    craft = models.CharField(max_length=16, choices=Craft.choices)
    sort_order = models.SmallIntegerField(default=0)
    is_active = models.BooleanField(default=True)
    # Only leaf-ish topics carry prompts; parents exist to group and subscribe.
    accepts_prompts = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = "topics"
        ordering = ["sort_order", "name"]
        indexes = [models.Index(fields=["parent", "is_active"])]

    def __str__(self) -> str:
        return self.path

    @property
    def is_root(self) -> bool:
        return self.parent_id is None

    @property
    def path(self) -> str:
        names, node, guard = [], self, 0
        while node is not None and guard < 8:
            names.append(node.name)
            node = node.parent
            guard += 1
        return " · ".join(reversed(names))

    def ancestors(self) -> list["Topic"]:
        out, node, guard = [], self.parent, 0
        while node is not None and guard < 8:
            out.append(node)
            node = node.parent
            guard += 1
        return out

    def descendant_ids(self) -> list[uuid.UUID]:
        """Self plus every descendant. Subscribing to a parent means all children."""
        ids = [self.id]
        frontier = [self.id]
        for _ in range(6):  # depth guard
            children = list(
                Topic.objects.filter(parent_id__in=frontier, is_active=True).values_list(
                    "id", flat=True
                )
            )
            if not children:
                break
            ids.extend(children)
            frontier = children
        return ids


class UserTopic(models.Model):
    """An explicit interest. Subscribing to a parent implies its descendants."""

    user = models.ForeignKey(
        "accounts.User", on_delete=models.CASCADE, related_name="topic_links"
    )
    topic = models.ForeignKey(Topic, on_delete=models.CASCADE, related_name="subscribers")
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = "user_topics"
        constraints = [
            models.UniqueConstraint(fields=["user", "topic"], name="uniq_user_topic")
        ]
        indexes = [models.Index(fields=["user"])]


def expand_topic_ids(topic_ids: list) -> list:
    """Expand subscriptions into the full set of topics they cover."""
    if not topic_ids:
        return []
    seen = set(topic_ids)
    frontier = list(topic_ids)
    for _ in range(6):
        children = list(
            Topic.objects.filter(parent_id__in=frontier, is_active=True).values_list(
                "id", flat=True
            )
        )
        children = [c for c in children if c not in seen]
        if not children:
            break
        seen.update(children)
        frontier = children
    return list(seen)
