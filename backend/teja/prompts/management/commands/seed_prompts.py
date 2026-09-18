"""Seed 28 hand-written prompts so the app works on day one without an OpenAI key.

    python manage.py seed_prompts
"""

from __future__ import annotations

from datetime import timedelta

from django.core.management.base import BaseCommand
from django.utils import timezone

from teja.prompts.models import Category, Prompt

LIBRARY = {
    Category.WRITING: [
        ("Write the last text message someone sent before the world changed.", "Five minutes is enough."),
        ("Describe a room using only what it smells like.", "No visuals allowed."),
        ("Two strangers share an umbrella. Write only their dialogue.", "Let them interrupt each other."),
        ("Write a letter from your hands to your phone.", "Be honest. They've been through things."),
        ("Something in your kitchen is keeping a secret. What is it?", "Start in the middle."),
        ("Write the opening line of a novel you'll never finish.", "One sentence is a whole creation."),
        ("Describe today's weather as a mood, without naming the weather.", "Short is good."),
        ("Write a eulogy for an object you outgrew.", "It deserves a few kind words."),
        ("Your childhood home has one new door. Where does it go?", "Don't explain it."),
        ("Write a conversation where nobody says what they mean.", "Subtext does the work."),
    ],
    Category.PHOTO: [
        ("Photograph something that has been waiting.", "It's closer than you think."),
        ("Find a straight line where there shouldn't be one.", "Look up."),
        ("Photograph the least interesting corner of your home. Make it beautiful.", "Light is everything."),
        ("Capture something in the act of being used.", "Hands welcome."),
        ("Photograph a shadow that is more interesting than the object.", "Wait for the light."),
        ("Find a colour you've never noticed in a place you see daily.", "Get close."),
        ("Photograph something that is almost gone.", "Crumbs count."),
        ("Take one photo without looking through the screen.", "Trust your hands."),
    ],
    Category.SKETCH: [
        ("Draw your morning as a single object.", "Stick figures are art."),
        ("Draw the thing nearest your left hand without lifting the pen.", "One line. No cheating."),
        ("Draw a door to somewhere you'd rather be.", "Two minutes, tops."),
        ("Draw your mood as a weather map.", "Scribbles welcome."),
        ("Draw a machine that solves a very small problem.", "Label the parts."),
        ("Draw the same shape five times, worse each time.", "Getting worse is a skill."),
    ],
    Category.JOKE: [
        ("The worst possible name for a boat.", "Say it out loud first."),
        ("Write a one-star review of something universally loved.", "Commit to the bit."),
        ("A superhero whose power is deeply inconvenient.", "The more specific, the funnier."),
        ("What does your phone say about you behind your back?", "Be unkind to yourself."),
    ],
}


class Command(BaseCommand):
    help = "Seed a starter prompt library and schedule it from today."

    def add_arguments(self, parser):
        parser.add_argument("--days", type=int, default=28)

    def handle(self, *args, **opts):
        from teja.prompts.models import WEEKLY_ROTATION

        pools = {cat: list(items) for cat, items in LIBRARY.items()}
        cursors = dict.fromkeys(pools, 0)
        today = timezone.now().date()
        created = 0

        for offset in range(opts["days"]):
            day = today + timedelta(days=offset)
            if Prompt.objects.filter(date=day).exists():
                continue
            category = WEEKLY_ROTATION[day.weekday()]
            pool = pools[category]
            text, nudge = pool[cursors[category] % len(pool)]
            cursors[category] += 1
            Prompt.objects.create(
                date=day,
                category=category,
                text=text,
                nudge=nudge,
                source="human",
                is_published=True,
            )
            created += 1

        self.stdout.write(self.style.SUCCESS(f"Seeded {created} live prompts from {today}."))
