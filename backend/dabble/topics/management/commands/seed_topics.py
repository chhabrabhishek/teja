"""Seed the interest tree.

    python manage.py seed_topics --remap

Idempotent. Topics not in TREE are deactivated rather than deleted, so existing
prompts and subscriptions never break.

Deliberately shallow — four crafts, two topics each. Every leaf needs its own
prompt every day, so eight leaves is ~2,900 prompts a year. Sixteen would be
~5,800, which nobody can human-review, and prompt quality *is* the product.
Deepen a branch only once its feed is busy enough to justify the content cost.
"""

from __future__ import annotations

from collections import defaultdict

from django.core.management.base import BaseCommand

from dabble.topics.models import Craft, Topic

TREE: dict[str, list] = {
    "writing": [
        "Creative Writing",
        "Words on a page.",
        [
            ("poetry", "Poetry", "Line breaks and pressure."),
            ("storytelling", "Storytelling", "Scenes, voices, small fictions."),
        ],
    ],
    "photo": [
        "Photography",
        "Look again at what you already see.",
        [
            ("street", "Street & Life", "Strangers, accidents, the everyday."),
            ("still-life", "Still Life & Light", "Objects, shadow, arrangement."),
        ],
    ],
    "sketch": [
        "Sketch & Art",
        "Lines, not masterpieces.",
        [
            ("from-life", "From Life", "Draw what is in front of you."),
            ("from-imagination", "From Imagination", "Invent the thing."),
        ],
    ],
    "joke": [
        "Humour",
        "Make one person laugh.",
        [
            ("one-liners", "One-liners", "Setup and punch, fast."),
            ("absurd", "Absurdism", "Commit to the bit."),
        ],
    ],
}


class Command(BaseCommand):
    help = "Create or update the topic tree."

    def add_arguments(self, parser):
        parser.add_argument(
            "--remap",
            action="store_true",
            help="Move prompts off deactivated topics onto an active leaf.",
        )

    def handle(self, *args, **opts):
        assert set(TREE) == {c.value for c in Craft}, "TREE must cover every Craft"
        keep: set[str] = set()
        created = updated = 0

        for order, (craft, (name, blurb, children)) in enumerate(TREE.items()):
            root, made = Topic.objects.update_or_create(
                slug=craft,
                defaults={
                    "name": name,
                    "blurb": blurb,
                    "craft": craft,
                    "parent": None,
                    "sort_order": order,
                    # Roots group and allow broad subscription; prompts live on leaves.
                    "accepts_prompts": False,
                    "is_active": True,
                },
            )
            keep.add(root.slug)
            created += int(made)
            updated += int(not made)

            for child_order, (slug, child_name, child_blurb) in enumerate(children):
                _, child_made = Topic.objects.update_or_create(
                    slug=slug,
                    defaults={
                        "name": child_name,
                        "blurb": child_blurb,
                        "craft": craft,
                        "parent": root,
                        "sort_order": child_order,
                        "accepts_prompts": True,
                        "is_active": True,
                    },
                )
                keep.add(slug)
                created += int(child_made)
                updated += int(not child_made)

        retired = Topic.objects.exclude(slug__in=keep).update(is_active=False)

        self.stdout.write(
            self.style.SUCCESS(
                f"Topics: {created} created, {updated} updated, {retired} retired "
                f"({Topic.objects.filter(parent__isnull=True, is_active=True).count()} roots, "
                f"{Topic.objects.filter(accepts_prompts=True, is_active=True).count()} leaves)."
            )
        )

        if opts["remap"]:
            self._remap()

    def _remap(self) -> None:
        """Re-home prompts stranded on retired topics, respecting (topic, date)."""
        from dabble.prompts.models import Prompt

        leaves = defaultdict(list)
        for leaf in Topic.objects.filter(is_active=True, accepts_prompts=True).order_by(
            "sort_order"
        ):
            leaves[leaf.craft].append(leaf)

        moved = orphaned = 0
        cursor: dict[str, int] = defaultdict(int)

        for prompt in (
            Prompt.objects.filter(topic__is_active=False).select_related("topic").order_by("date")
        ):
            pool = leaves.get(prompt.category) or []
            placed = False
            for _ in range(len(pool)):
                candidate = pool[cursor[prompt.category] % len(pool)]
                cursor[prompt.category] += 1
                if not Prompt.objects.filter(topic=candidate, date=prompt.date).exists():
                    prompt.topic = candidate
                    prompt.save(update_fields=["topic"])
                    moved += 1
                    placed = True
                    break
            if not placed:
                orphaned += 1

        self.stdout.write(
            self.style.SUCCESS(f"Remap: {moved} moved, {orphaned} left on retired topics.")
        )
        if orphaned:
            self.stdout.write(
                "  (their date already had a prompt on every active leaf — unused, not lost)"
            )
