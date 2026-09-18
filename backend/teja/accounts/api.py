from __future__ import annotations

from django.db import transaction
from django.http import HttpRequest
from ninja import Router

from teja.accounts import apple, emailcode
from teja.accounts.models import Block, Streak, User
from teja.accounts.schemas import (
    AppleSignInIn,
    EmailRequestIn,
    EmailVerifyIn,
    MeOut,
    ProfileOut,
    RefreshIn,
    TokenPair,
    UpdateMeIn,
    me_payload,
    streak_payload,
    unique_username,
    user_today,
)
from teja.common.auth import (
    issue_access_token,
    issue_refresh_token,
    revoke_refresh_token,
    rotate_refresh_token,
)
from teja.common.errors import ApiError, Conflict, NotFound
from teja.common.ratelimit import client_ip, hit

auth_router = Router(auth=None)
me_router = Router()
users_router = Router()


def _token_pair(user: User, *, is_new: bool, request: HttpRequest) -> dict:
    access, expires_in = issue_access_token(user)
    refresh = issue_refresh_token(user, request.headers.get("X-Device", ""))
    return {
        "access_token": access,
        "refresh_token": refresh,
        "expires_in": expires_in,
        "is_new_user": is_new,
        "user": me_payload(user),
    }


# --- auth -------------------------------------------------------------------


@auth_router.post("/apple", response=TokenPair)
def sign_in_with_apple(request, data: AppleSignInIn):
    hit(f"apple:{client_ip(request)}", limit=20, window_seconds=3600)
    claims = apple.verify_identity_token(data.identity_token, data.nonce)
    sub = claims["sub"]
    email = (claims.get("email") or f"{sub}@privaterelay.appleid.com").lower()

    with transaction.atomic():
        user = User.objects.filter(apple_sub=sub).first() or User.objects.filter(email=email).first()
        is_new = user is None
        if is_new:
            user = User.objects.create_user(
                email=email,
                apple_sub=sub,
                username=unique_username(data.full_name or email.split("@")[0]),
                display_name=(data.full_name or "").strip()[:40],
                timezone=data.timezone or "UTC",
            )
        elif not user.apple_sub:
            user.apple_sub = sub
            user.save(update_fields=["apple_sub"])
    return _token_pair(user, is_new=is_new, request=request)


@auth_router.post("/email/request")
def request_email_code(request, data: EmailRequestIn):
    email = data.email.lower()
    hit(f"code:{email}", limit=3, window_seconds=3600, message="Too many codes. Try again in an hour.")
    hit(f"code-ip:{client_ip(request)}", limit=10, window_seconds=3600)
    ttl = emailcode.issue_code(email)
    # Always 200 — never reveal whether an account exists.
    return {"sent": True, "expires_in": ttl}


@auth_router.post("/email/verify", response=TokenPair)
def verify_email_code(request, data: EmailVerifyIn):
    email = data.email.lower()
    hit(f"verify:{email}", limit=10, window_seconds=3600)
    emailcode.verify_code(email, data.code)

    with transaction.atomic():
        user = User.objects.filter(email=email).first()
        is_new = user is None
        if is_new:
            user = User.objects.create_user(
                email=email,
                username=unique_username(email.split("@")[0]),
                timezone=data.timezone or "UTC",
            )
    return _token_pair(user, is_new=is_new, request=request)


@auth_router.post("/refresh", response=TokenPair)
def refresh(request, data: RefreshIn):
    user, new_refresh = rotate_refresh_token(data.refresh_token)
    access, expires_in = issue_access_token(user)
    return {
        "access_token": access,
        "refresh_token": new_refresh,
        "expires_in": expires_in,
        "is_new_user": False,
        "user": me_payload(user),
    }


@auth_router.post("/logout", response={204: None})
def logout(request, data: RefreshIn):
    revoke_refresh_token(data.refresh_token)
    return 204, None


# --- me ---------------------------------------------------------------------


@me_router.get("", response=MeOut)
def get_me(request):
    return me_payload(request.user)


@me_router.patch("", response=MeOut)
def update_me(request, data: UpdateMeIn):
    user: User = request.user
    payload = data.dict(exclude_unset=True)

    if "username" in payload and payload["username"] != user.username:
        if User.objects.filter(username=payload["username"]).exists():
            raise Conflict("That handle is taken.", code="username_taken")

    if "reminder_hour" in payload and payload["reminder_hour"] is not None:
        if not 0 <= payload["reminder_hour"] <= 23:
            raise ApiError("Pick an hour between 0 and 23.", code="invalid_hour")

    for field, value in payload.items():
        setattr(user, field, value)
    user.save()
    return me_payload(user)


@me_router.delete("", response={204: None})
def delete_me(request):
    """Hard delete — required by App Review, and the right thing to do."""
    request.user.delete()
    return 204, None


@me_router.get("/streak")
def get_streak(request):
    return streak_payload(request.user)


# --- users ------------------------------------------------------------------


@users_router.get("/{username}", response=ProfileOut)
def get_profile(request, username: str):
    user = User.objects.filter(username=username.lower(), is_active=True).first()
    if user is None:
        raise NotFound("That profile doesn't exist.", code="user_not_found")
    Streak.objects.get_or_create(user=user)
    payload = {
        "id": str(user.id),
        "username": user.username,
        "display_name": user.name,
        "bio": user.bio,
        "avatar_url": None,
        "streak": streak_payload(user),
        "is_blocked": Block.objects.filter(blocker=request.user, blocked=user).exists(),
    }
    from teja.common.storage import public_url

    payload["avatar_url"] = public_url(user.avatar_key) if user.avatar_key else None
    return payload


@users_router.get("/{username}/submissions")
def list_user_submissions(request, username: str, cursor: str | None = None, limit: int = 20):
    from teja.submissions.api import serialize_page

    user = User.objects.filter(username=username.lower(), is_active=True).first()
    if user is None:
        raise NotFound("That profile doesn't exist.", code="user_not_found")
    from teja.submissions.models import Submission

    qs = (
        Submission.objects.filter(user=user, status=Submission.Status.PUBLISHED, is_removed=False)
        .select_related("user", "prompt")
        .order_by("-published_at", "-id")
    )
    return serialize_page(qs, request.user, cursor, limit)


@users_router.post("/{username}/block", response={204: None})
def block_user(request, username: str):
    target = User.objects.filter(username=username.lower()).first()
    if target is None or target.id == request.user.id:
        raise NotFound("That profile doesn't exist.", code="user_not_found")
    Block.objects.get_or_create(blocker=request.user, blocked=target)
    return 204, None


@users_router.delete("/{username}/block", response={204: None})
def unblock_user(request, username: str):
    Block.objects.filter(blocker=request.user, blocked__username=username.lower()).delete()
    return 204, None


__all__ = ["auth_router", "me_router", "users_router", "user_today"]
