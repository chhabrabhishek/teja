"""Fill empty days with AI-drafted prompts: `python manage.py generate_prompts --days 30`.

Drafts land unpublished. Review them in /admin/ and publish. Run this monthly.
"""

from __future__ import annotations

from collections import defaultdict
from datetime import timedelta

from django.conf import settings
from django.conf import settings
from django.core.management.base import BaseCommand, CommandError
from django.utils import timezone

from teja.prompts.generator import generate
from teja.prompts.models import Prompt
from teja.topics.models import Topic


class Command(BaseCommand):
    help = "Draft prompts for days that don't have one yet."

    def add_arguments(self, parser):
        parser.add_argument("--days", type=int, default=30)
        parser.add_argument("--start", type=str, default=None, help="YYYY-MM-DD")
        parser.add_argument(
            "--ensure-runway",
            type=int,
            default=None,
            help="Top up so every day up to N days out has a prompt. Safe to cron daily.",
        )
        parser.add_argument("--topic", type=str, default=None, help="limit to one topic slug")
        parser.add_argument("--publish", action="store_true", help="Skip human review (dev only).")

    def handle(self, *args, **opts):
        runway = opts["ensure_runway"]
        if runway is not None:
            start = timezone.now().date()
            days = runway
        else:
            start = (
                timezone.datetime.fromisoformat(opts["start"]).date()
                if opts["start"]
                else timezone.now().date() + timedelta(days=1)
            )
            days = opts["days"]

        dates = [start + timedelta(days=i) for i in range(days)]
        topics = list(
            Topic.objects.filter(is_active=True, accepts_prompts=True).order_by("sort_order")
        )
        if not topics:
            raise CommandError("No topics. Run `manage.py seed_topics` first.")
        if opts["topic"]:
            topics = [t for t in topics if t.slug == opts["topic"]]
            if not topics:
                raise CommandError(f"No topic with slug '{opts['topic']}'.")

        # Every (topic, date) pair needs its own prompt now that the daily
        # challenge is drawn from the user's interests.
        existing = {
            (t, d)
            for t, d in Prompt.objects.filter(date__in=dates).values_list("topic_id", "date")
        }
        needed: dict = defaultdict(list)
        for topic in topics:
            for day in dates:
                if (topic.id, day) not in existing:
                    needed[topic].append(day)

        if not needed:
            self.stdout.write(self.style.SUCCESS("Every topic already has a prompt for every day."))
            return

        if not settings.OPENAI_API_KEY:
            raise CommandError(
                "OPENAI_API_KEY is not set. Add it to the environment, or seed "
                "hand-written prompts with `manage.py seed_prompts`."
            )

        created = 0
        for topic, topic_dates in needed.items():
            avoid = list(
                Prompt.objects.filter(topic=topic)
                .order_by("-date")
                .values_list("text", flat=True)[:60]
            )
            drafts = generate(
                topic.craft,
                len(topic_dates),
                avoid,
                topic_name=topic.name,
                topic_blurb=topic.blurb,
            )
            for day, draft in zip(topic_dates, drafts):
                Prompt.objects.create(
                    date=day,
                    topic=topic,
                    category=topic.craft,
                    text=draft["text"],
                    nudge=draft["nudge"],
                    source="openai",
                    is_published=opts["publish"],
                )
                created += 1
            self.stdout.write(f"  {topic.slug:22s} drafted {len(drafts)} for {len(topic_dates)} day(s)")

        state = "published" if opts["publish"] else "awaiting review in /admin/"
        self.stdout.write(self.style.SUCCESS(f"Created {created} prompts — {state}."))
