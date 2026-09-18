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
from teja.prompts.models import WEEKLY_ROTATION, Prompt


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
        # Any existing row counts as taken, published or not, so repeated runs
        # never double-draft the same day.
        taken = set(Prompt.objects.filter(date__in=dates).values_list("date", flat=True))
        needed = defaultdict(list)
        for day in dates:
            if day not in taken:
                needed[WEEKLY_ROTATION[day.weekday()]].append(day)

        if not needed:
            self.stdout.write(self.style.SUCCESS("Every day already has a prompt."))
            return

        if not settings.OPENAI_API_KEY:
            raise CommandError(
                "OPENAI_API_KEY is not set. Add it to the environment, or seed "
                "hand-written prompts with `manage.py seed_prompts`."
            )

        created = 0
        for category, dates in needed.items():
            avoid = list(
                Prompt.objects.filter(category=category)
                .order_by("-date")
                .values_list("text", flat=True)[:60]
            )
            drafts = generate(category, len(dates), avoid)
            for day, draft in zip(dates, drafts):
                Prompt.objects.create(
                    date=day,
                    category=category,
                    text=draft["text"],
                    nudge=draft["nudge"],
                    source="openai",
                    is_published=opts["publish"],
                )
                created += 1
            self.stdout.write(f"  {category}: drafted {len(drafts)} for {len(dates)} day(s)")

        state = "published" if opts["publish"] else "awaiting review in /admin/"
        self.stdout.write(self.style.SUCCESS(f"Created {created} prompts — {state}."))
