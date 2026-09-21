"""Seed hand-written prompts for every active leaf topic.

    python manage.py seed_prompts --days 28

Gives a working app with no OpenAI key. Each leaf gets its own curated list,
cycled to fill the requested runway — repetition is fine for development, and
for launch you'd replace these with reviewed originals.
"""

from __future__ import annotations

from datetime import timedelta

from django.core.management.base import BaseCommand
from django.utils import timezone

from teja.prompts.models import Prompt
from teja.topics.models import Topic

LIBRARY: dict[str, list[tuple[str, str]]] = {
    "poetry": [
        ("Write four lines that end on the wrong word.", "Line breaks do the work."),
        ("Describe today's weather as a mood, without naming the weather.", "Short is good."),
        ("Write a poem that is entirely one sentence.", "Let it run."),
        ("Name five things in the room. Make the fifth one break your heart.", "Order matters."),
        ("Write the shortest poem that still hurts.", "Two lines is plenty."),
    ],
    "storytelling": [
        ("Write the last text message someone sent before the world changed.", "Five minutes is enough."),
        ("Two strangers share an umbrella. Write only their dialogue.", "Let them interrupt."),
        ("A chair gets moved to a new corner. Write its first thought.", "Start in the middle."),
        ("Write the opening line of a novel you'll never finish.", "One sentence is a creation."),
        ("Write a conversation where nobody says what they mean.", "Subtext does the work."),
    ],
    "street": [
        ("Photograph something that has been waiting.", "It's closer than you think."),
        ("Capture something in the act of being used.", "Hands welcome."),
        ("Find a straight line where there shouldn't be one.", "Look up."),
        ("Photograph the least interesting corner of your street.", "Make it beautiful."),
    ],
    "still-life": [
        ("Photograph a shadow more interesting than the object.", "Wait for the light."),
        ("Arrange three things that don't belong together.", "Then leave them."),
        ("Photograph something that is almost gone.", "Crumbs count."),
        ("Find a colour you've never noticed in a place you see daily.", "Get close."),
    ],
    "from-life": [
        ("Draw the thing nearest your left hand without lifting the pen.", "One line. No cheating."),
        ("Draw your morning as a single object.", "Stick figures are art."),
        ("Draw the same shape five times, worse each time.", "Getting worse is a skill."),
    ],
    "from-imagination": [
        ("Draw a door to somewhere you'd rather be.", "Two minutes, tops."),
        ("Draw a machine that solves a very small problem.", "Label the parts."),
        ("Draw a creature that would be bad at its job.", "Give it a name."),
    ],
    "one-liners": [
        ("The worst possible name for a boat.", "Say it out loud first."),
        ("Write a one-star review of something universally loved.", "Commit to the bit."),
        ("Finish this: 'My toxic trait is…'", "Be unkind to yourself."),
    ],
    "absurd": [
        ("A superhero whose power is deeply inconvenient.", "The more specific, the funnier."),
        ("What does your phone say about you behind your back?", "Let it be petty."),
        ("Explain your job badly enough to worry someone.", "Understate everything."),
    ],
}


class Command(BaseCommand):
    help = "Seed a starter prompt library across every active leaf topic."

    def add_arguments(self, parser):
        parser.add_argument("--days", type=int, default=28)

    def handle(self, *args, **opts):
        today = timezone.now().date()
        leaves = list(Topic.objects.filter(is_active=True, accepts_prompts=True))
        if not leaves:
            self.stdout.write(self.style.ERROR("No active topics. Run `seed_topics` first."))
            return

        created = skipped = 0
        for leaf in leaves:
            pool = LIBRARY.get(leaf.slug)
            if not pool:
                self.stdout.write(self.style.WARNING(f"  no library for '{leaf.slug}' — skipped"))
                continue
            for offset in range(opts["days"]):
                day = today + timedelta(days=offset)
                if Prompt.objects.filter(topic=leaf, date=day).exists():
                    skipped += 1
                    continue
                text, nudge = pool[offset % len(pool)]
                Prompt.objects.create(
                    date=day,
                    topic=leaf,
                    category=leaf.craft,
                    text=text,
                    nudge=nudge,
                    source="human",
                    is_published=True,
                )
                created += 1

        self.stdout.write(
            self.style.SUCCESS(
                f"Seeded {created} prompts across {len(leaves)} topics "
                f"({skipped} days already had one)."
            )
        )
