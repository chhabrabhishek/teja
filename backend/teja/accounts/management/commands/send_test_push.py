"""Verify APNs credentials and delivery without touching the app.

    python manage.py send_test_push --user maya
    python manage.py send_test_push --token <64-hex-device-token>
"""

from __future__ import annotations

from django.core.management.base import BaseCommand, CommandError

from teja.accounts.models import Device, User
from teja.common import push


class Command(BaseCommand):
    help = "Send a test push to a user's devices or a raw token."

    def add_arguments(self, parser):
        parser.add_argument("--user", type=str, help="username")
        parser.add_argument("--token", type=str, help="raw APNs device token")
        parser.add_argument("--title", type=str, default="Today's prompt is ready")
        parser.add_argument("--body", type=str, default="Five minutes is enough.")

    def handle(self, *args, **opts):
        if not push.is_configured():
            raise CommandError(
                "APNs is not configured. Set APNS_KEY_ID, APNS_TEAM_ID and "
                "APNS_KEY_PATH (or APNS_KEY_CONTENT)."
            )

        from django.conf import settings

        self.stdout.write(f"bundle : {settings.APNS_BUNDLE_ID}")
        self.stdout.write(
            f"host   : {'sandbox' if settings.APNS_USE_SANDBOX else 'production'}"
        )

        if opts["token"]:
            tokens = [opts["token"]]
        elif opts["user"]:
            user = User.objects.filter(username=opts["user"].lower()).first()
            if user is None:
                raise CommandError(f"No user @{opts['user']}")
            tokens = list(
                Device.objects.filter(user=user, is_active=True).values_list(
                    "token", flat=True
                )
            )
            if not tokens:
                raise CommandError(
                    f"@{user.username} has no active devices. Open the app on a "
                    f"physical device and grant notification permission first."
                )
        else:
            raise CommandError("Pass --user or --token.")

        self.stdout.write(f"tokens : {len(tokens)}")
        result = push.send(tokens, title=opts["title"], body=opts["body"])
        self.stdout.write(
            self.style.SUCCESS(
                f"sent={result.sent} failed={result.failed} "
                f"deactivated={result.deactivated}"
            )
        )
        if result.failed:
            raise SystemExit(1)
