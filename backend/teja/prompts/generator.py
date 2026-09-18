"""Offline prompt generation.

Prompts are generated in batches, written as `is_published=False`, and go live only
after a human approves them in Django admin. No OpenAI call ever happens inside a
user request: zero added latency, zero spend per user, and no chance of a bad prompt
shipping to everyone at once.
"""

from __future__ import annotations

import json

from django.conf import settings

from teja.prompts.models import Category

SYSTEM = """You write daily creative prompts for Teja, an app that helps people build a
daily creative habit. Your prompts are the whole product — they must be extraordinary.

Rules:
- One sentence. Under 140 characters. Concrete, not abstract.
- Give a constraint, not a theme. "Write about love" is bad. "Write the text message
  they never sent" is good.
- Must be answerable in under ten minutes by a complete beginner.
- Specific enough to spark, open enough that 1,000 answers all differ.
- Warm, curious, a little strange. Never corporate, never cringe, never a writing-class
  exercise.
- No politics, religion, tragedy, sexual content, or anything requiring special equipment.
- Never start with "Imagine" or "Think about".
Also write a `nudge`: a short, calm, encouraging line under 60 characters."""

EXEMPLARS = {
    Category.WRITING: [
        "Write the last text message someone sent before the world changed.",
        "Describe a room using only what it smells like.",
        "Two strangers share an umbrella. Write only their dialogue.",
    ],
    Category.PHOTO: [
        "Photograph something that has been waiting.",
        "Find a straight line where there shouldn't be one.",
        "Photograph the least interesting corner of your home. Make it beautiful.",
    ],
    Category.SKETCH: [
        "Draw your morning as a single object.",
        "Draw the thing nearest your left hand, without lifting the pen.",
        "Draw a door to somewhere you'd rather be.",
    ],
    Category.JOKE: [
        "The worst possible name for a boat.",
        "Write a one-star review of something universally loved.",
        "A superhero whose power is deeply inconvenient.",
    ],
}


def _parse_prompts(raw: str) -> list[dict]:
    """Pull the JSON object out of a completion.

    Deployments vary on whether they honour `response_format`, and reasoning
    models like to wrap output in prose or code fences. Slicing to the outermost
    braces is more robust than trusting either.
    """
    text = raw.strip()
    if text.startswith("```"):
        text = text.split("```")[1]
        if text.lstrip().startswith("json"):
            text = text.lstrip()[4:]

    start, end = text.find("{"), text.rfind("}")
    if start == -1 or end == -1:
        raise ValueError(f"No JSON object in completion: {raw[:200]}")

    data = json.loads(text[start : end + 1])
    items = data.get("prompts", [])
    parsed = []
    for item in items:
        text_value = str(item.get("text", "")).strip()
        if not text_value:
            continue
        parsed.append({
            "text": text_value[:240],
            "nudge": str(item.get("nudge", "")).strip()[:120] or "Five minutes is enough.",
        })
    if not parsed:
        raise ValueError("Completion contained no usable prompts.")
    return parsed


def generate(category: str, count: int, avoid: list[str]) -> list[dict]:
    """Return [{text, nudge}]. Requires OPENAI_API_KEY."""
    from openai import OpenAI

    client = OpenAI(api_key=settings.OPENAI_API_KEY, max_retries=4, timeout=120.0)

    user_msg = (
        f"Category: {Category(category).label}\n"
        f"Examples of the right voice:\n- " + "\n- ".join(EXEMPLARS[Category(category)]) + "\n\n"
        f"Do NOT repeat or paraphrase any of these existing prompts:\n- "
        + "\n- ".join(avoid[:60])
        + f"\n\nReturn ONLY a JSON object, no prose and no code fence:\n"
        f'{{"prompts": [{{"text": "...", "nudge": "..."}}]}}\n'
        f"with exactly {count} items."
    )

    kwargs: dict = {
        "model": settings.OPENAI_MODEL,
        "response_format": {"type": "json_object"},
        "messages": [
            {"role": "system", "content": SYSTEM},
            {"role": "user", "content": user_msg},
        ],
    }
    if settings.AI_TEMPERATURE is not None:
        kwargs["temperature"] = settings.AI_TEMPERATURE

    response = client.chat.completions.create(**kwargs)
    return _parse_prompts(response.choices[0].message.content or "")
