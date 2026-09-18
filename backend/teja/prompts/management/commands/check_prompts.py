"""Monitoring hook for the prompt pipeline.

    python manage.py check_prompts --min-runway 14

Exits non-zero when the published runway is short, so cron/CI/uptime tooling can
alert. Running out of published prompts is the one failure that silently breaks
the whole product: `resolve_prompt` falls back to the most recent live prompt, so
every user would quietly get yesterday's challenge again instead of an error.
"""

from __future__ import annotations

from datetime import timedelta

from django.core.management.base import BaseCommand
from django.utils import timezone

from teja.prompts.models import Prompt


class Command(BaseCommand):
    help = "Report how many days of published prompts remain."

    def add_arguments(self, parser):
        parser.add_argument("--min-runway", type=int, default=14)

    def handle(self, *args, **opts):
        today = timezone.now().date()
        minimum = opts["min_runway"]

        published = set(
            Prompt.objects.filter(is_published=True, date__gte=today).values_list(
                "date", flat=True
            )
        )
        # Runway is consecutive days from today, not a raw count: a gap tomorrow
        # matters far more than 40 prompts sitting behind it.
        runway = 0
        while today + timedelta(days=runway) in published:
            runway += 1

        awaiting = Prompt.objects.filter(is_published=False, date__gte=today).count()
        gaps = [
            today + timedelta(days=i)
            for i in range(minimum)
            if today + timedelta(days=i) not in published
        ]

        self.stdout.write(f"consecutive published runway : {runway} day(s)")
        self.stdout.write(f"drafts awaiting review       : {awaiting}")
        if gaps:
            self.stdout.write(f"missing days in next {minimum}   : {len(gaps)} "
                              f"(first {gaps[0]})")

        if runway < minimum:
            self.stderr.write(
                self.style.ERROR(
                    f"PROMPT RUNWAY LOW: {runway} day(s) left, want {minimum}. "
                    f"Run `generate_prompts --ensure-runway 60` and review in /admin/."
                )
            )
            raise SystemExit(1)

        self.stdout.write(self.style.SUCCESS("Prompt runway healthy."))
