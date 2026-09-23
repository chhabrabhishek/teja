"""Monitoring hook for the prompt pipeline.

    python manage.py check_prompts --min-runway 14

Exits non-zero when any active leaf topic is short. Runway is measured **per
topic**, because a global count can look healthy while one topic has nothing —
and its subscribers would silently fall back to another topic's prompt.
"""

from __future__ import annotations

from datetime import timedelta

from django.core.management.base import BaseCommand
from django.utils import timezone

from dabble.prompts.models import Prompt
from dabble.topics.models import Topic


class Command(BaseCommand):
    help = "Report how many days of published prompts remain, per topic."

    def add_arguments(self, parser):
        parser.add_argument("--min-runway", type=int, default=14)

    def handle(self, *args, **opts):
        today = timezone.now().date()
        minimum = opts["min_runway"]

        leaves = list(
            Topic.objects.filter(is_active=True, accepts_prompts=True).order_by(
                "sort_order", "name"
            )
        )
        if not leaves:
            self.stderr.write(self.style.ERROR("No active topics. Run `seed_topics`."))
            raise SystemExit(1)

        published = {
            (topic_id, date)
            for topic_id, date in Prompt.objects.filter(
                is_published=True, date__gte=today
            ).values_list("topic_id", "date")
        }

        worst: tuple[str, int] | None = None
        for leaf in leaves:
            runway = 0
            while (leaf.id, today + timedelta(days=runway)) in published:
                runway += 1
            flag = "  " if runway >= minimum else "!!"
            self.stdout.write(f"{flag} {leaf.slug:20s} {runway:3d} day(s)")
            if worst is None or runway < worst[1]:
                worst = (leaf.slug, runway)

        awaiting = Prompt.objects.filter(is_published=False, date__gte=today).count()
        self.stdout.write(f"   drafts awaiting review: {awaiting}")

        if worst and worst[1] < minimum:
            self.stderr.write(
                self.style.ERROR(
                    f"PROMPT RUNWAY LOW: '{worst[0]}' has {worst[1]} day(s), want {minimum}. "
                    f"Run `generate_prompts --ensure-runway 60` and review in /admin/."
                )
            )
            raise SystemExit(1)

        self.stdout.write(self.style.SUCCESS("Every topic has a healthy runway."))
