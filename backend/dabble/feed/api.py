"""The feed.

Two modes, deliberately different:

- `/feed/today` — the campfire. Everyone who answered *your* prompt today.
  Locked until you publish today; this is the creation-first mechanic.
- `/feed/all` — everything ever made in the topics you follow. Requires you to
  have created at least once, so the feed is still earned — just not re-earned
  every single day.
"""

from __future__ import annotations

from ninja import Router

from dabble.accounts.models import Block, Streak
from dabble.accounts.schemas import user_today
from dabble.prompts.api import resolve_prompt
from dabble.prompts.schemas import prompt_payload
from dabble.submissions.api import annotate_reactions, serialize_page
from dabble.submissions.models import Submission
from dabble.submissions.schemas import submission_payload
from dabble.topics.api import subscribed_topic_ids

feed_router = Router()


def _visible(user):
    blocked_ids = Block.objects.filter(blocker=user).values_list("blocked_id", flat=True)
    return (
        Submission.objects.filter(status=Submission.Status.PUBLISHED, is_removed=False)
        .exclude(user_id__in=blocked_ids)
        .select_related("user", "user__streak", "prompt", "prompt__topic")
    )


@feed_router.get("/today")
def today_feed(request, cursor: str | None = None, limit: int = 20):
    user = request.user
    prompt = resolve_prompt(user, user_today(user))

    published = Submission.objects.filter(
        prompt=prompt, status=Submission.Status.PUBLISHED, is_removed=False
    )
    creator_count = published.count()

    if not published.filter(user=user).exists():
        # 200, not 403: the client renders a designed lock screen, not an error.
        return {
            "locked": True,
            "creator_count": creator_count,
            "prompt": prompt_payload(prompt),
            "items": [],
            "next_cursor": None,
        }

    qs = _visible(user).filter(prompt=prompt).exclude(user=user)
    page = serialize_page(qs.order_by("-published_at", "-id"), user, cursor, limit)

    if cursor is None:
        mine = (
            published.filter(user=user)
            .select_related("user", "user__streak", "prompt", "prompt__topic")
            .first()
        )
        if mine is not None:
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


@feed_router.get("/all")
def all_feed(
    request,
    cursor: str | None = None,
    limit: int = 20,
    topic_id: str | None = None,
    prompt_id: str | None = None,
):
    """Everything, newest first, scoped to the caller's topics by default."""
    user = request.user

    streak, _ = Streak.objects.get_or_create(user=user)
    if streak.total == 0:
        return {"locked": True, "reason": "create_once", "items": [], "next_cursor": None}

    qs = _visible(user)

    if prompt_id:
        qs = qs.filter(prompt_id=prompt_id)
    elif topic_id:
        from dabble.topics.models import Topic, expand_topic_ids

        topic = Topic.objects.filter(id=topic_id, is_active=True).first()
        qs = qs.filter(
            prompt__topic_id__in=expand_topic_ids([topic.id]) if topic else []
        )
    else:
        topic_ids = subscribed_topic_ids(user)
        if topic_ids:
            qs = qs.filter(prompt__topic_id__in=topic_ids)

    page = serialize_page(qs.order_by("-published_at", "-id"), user, cursor, limit)
    return {"locked": False, **page}
