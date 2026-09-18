"""The feed. Locked until you create — enforced here, on the server."""

from __future__ import annotations

from ninja import Router

from teja.accounts.models import Block
from teja.accounts.schemas import user_today
from teja.prompts.api import resolve_prompt
from teja.prompts.schemas import prompt_payload
from teja.submissions.api import serialize_page
from teja.submissions.models import Submission

feed_router = Router()


@feed_router.get("/today")
def today_feed(request, cursor: str | None = None, limit: int = 20):
    user = request.user
    prompt = resolve_prompt(user_today(user))

    published = Submission.objects.filter(
        prompt=prompt, status=Submission.Status.PUBLISHED, is_removed=False
    )
    creator_count = published.count()
    has_published = published.filter(user=user).exists()

    if not has_published:
        # 200, not 403: the client renders a designed lock screen, not an error.
        return {
            "locked": True,
            "creator_count": creator_count,
            "prompt": prompt_payload(prompt),
            "items": [],
            "next_cursor": None,
        }

    blocked_ids = Block.objects.filter(blocker=user).values_list("blocked_id", flat=True)
    qs = (
        published.exclude(user_id__in=blocked_ids)
        .exclude(user=user)
        .select_related("user", "prompt")
        .order_by("-published_at", "-id")
    )
    page = serialize_page(qs, user, cursor, limit)

    if cursor is None:
        # Your own creation is always the first thing you see.
        mine = (
            published.filter(user=user).select_related("user", "user__streak", "prompt").first()
        )
        if mine is not None:
            from teja.submissions.api import annotate_reactions
            from teja.submissions.schemas import submission_payload

            counts, my_reactions = annotate_reactions([mine], user)
            page["items"].insert(
                0,
                submission_payload(
                    mine,
                    user,
                    my_reactions=my_reactions.get(mine.id, []),
                    reaction_counts=dict(counts.get(mine.id, {})),
                ),
            )

    return {
        "locked": False,
        "creator_count": creator_count,
        "prompt": prompt_payload(prompt),
        **page,
    }
