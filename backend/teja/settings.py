"""Django settings for Teja."""

from __future__ import annotations

import os
from pathlib import Path
from urllib.parse import urlparse

from django.core.exceptions import ImproperlyConfigured
from dotenv import load_dotenv

BASE_DIR = Path(__file__).resolve().parent.parent
load_dotenv(BASE_DIR / ".env")


def env(key: str, default: str = "") -> str:
    return os.getenv(key, default)


def env_bool(key: str, default: bool = False) -> bool:
    return env(key, str(default)).lower() in {"1", "true", "yes", "on"}


def env_int(key: str, default: int) -> int:
    try:
        return int(env(key, str(default)))
    except ValueError:
        return default


SECRET_KEY = env("DJANGO_SECRET_KEY", "dev-insecure-change-me")
DEBUG = env_bool("DJANGO_DEBUG", True)
ALLOWED_HOSTS = [h for h in env("DJANGO_ALLOWED_HOSTS", "*").split(",") if h]

INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    "corsheaders",
    "teja.accounts",
    "teja.prompts",
    "teja.submissions",
    "teja.social",
]

MIDDLEWARE = [
    "corsheaders.middleware.CorsMiddleware",
    "django.middleware.security.SecurityMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
]

ROOT_URLCONF = "teja.urls"
WSGI_APPLICATION = "teja.wsgi.application"
ASGI_APPLICATION = "teja.asgi.application"

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [],
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
            ]
        },
    }
]

# SQLite by default so a new machine needs nothing installed; Postgres in
# staging and production. The schema is deliberately portable between the two.
DATABASE_URL = env("DATABASE_URL", "sqlite:///teja.sqlite3")

if DATABASE_URL.startswith("sqlite"):
    _path = DATABASE_URL.split("://", 1)[1].lstrip("/") or "teja.sqlite3"
    DATABASES = {
        "default": {
            "ENGINE": "django.db.backends.sqlite3",
            "NAME": _path if _path.startswith("/") else str(BASE_DIR / _path),
            "OPTIONS": {
                "timeout": 20,
                "init_command": "PRAGMA journal_mode=WAL; PRAGMA synchronous=NORMAL;",
            },
        }
    }
else:
    _db = urlparse(DATABASE_URL)
    DATABASES = {
        "default": {
            "ENGINE": "django.db.backends.postgresql",
            "NAME": _db.path.lstrip("/"),
            "USER": _db.username or "",
            "PASSWORD": _db.password or "",
            "HOST": _db.hostname or "",
            "PORT": str(_db.port or ""),
            "CONN_MAX_AGE": 60,
        }
    }

AUTH_USER_MODEL = "accounts.User"
DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"

LANGUAGE_CODE = "en-us"
TIME_ZONE = "UTC"
USE_I18N = True
USE_TZ = True

STATIC_URL = "static/"
STATIC_ROOT = BASE_DIR / "staticfiles"

CORS_ALLOW_ALL_ORIGINS = DEBUG
CORS_ALLOWED_ORIGINS = [o for o in env("CORS_ALLOWED_ORIGINS", "").split(",") if o]

# --- Teja -------------------------------------------------------------------

JWT_SECRET = env("JWT_SECRET", SECRET_KEY)
JWT_ALGORITHM = "HS256"
JWT_ACCESS_MINUTES = env_int("JWT_ACCESS_MINUTES", 30)
JWT_REFRESH_DAYS = env_int("JWT_REFRESH_DAYS", 60)

EMAIL_CODE_PEPPER = env("EMAIL_CODE_PEPPER", SECRET_KEY)
EMAIL_CODE_TTL_SECONDS = env_int("EMAIL_CODE_TTL_SECONDS", 600)
EMAIL_CODE_MAX_ATTEMPTS = 5
DEFAULT_FROM_EMAIL = env("DEFAULT_FROM_EMAIL", "hello@teja.app")
EMAIL_BACKEND = (
    "django.core.mail.backends.console.EmailBackend"
    if DEBUG
    else "django.core.mail.backends.smtp.EmailBackend"
)

APPLE_BUNDLE_ID = env("APPLE_BUNDLE_ID", "app.teja.ios")
APPLE_KEYS_URL = "https://appleid.apple.com/auth/keys"
APPLE_ISSUER = "https://appleid.apple.com"

MEDIA_BUCKET = env("MEDIA_BUCKET", "teja-media")
MEDIA_REGION = env("MEDIA_REGION", "auto")
MEDIA_ENDPOINT_URL = env("MEDIA_ENDPOINT_URL") or None
MEDIA_PUBLIC_BASE_URL = env("MEDIA_PUBLIC_BASE_URL", "").rstrip("/")
MEDIA_MAX_BYTES = 10 * 1024 * 1024
MEDIA_ALLOWED_TYPES = ["image/jpeg", "image/png", "image/heic", "image/webp"]

REDIS_URL = env("REDIS_URL") or None

# --- OpenAI -----------------------------------------------------------------
# Used only by the offline prompt generator, never in a request path.
OPENAI_API_KEY = env("OPENAI_API_KEY")
OPENAI_MODEL = env("OPENAI_MODEL", "gpt-4o-mini")
# None omits the field; reasoning models reject anything but the default.
AI_TEMPERATURE = float(env("AI_TEMPERATURE")) if env("AI_TEMPERATURE") else 1.0

REACTION_EMOJIS = ["💛", "🔥", "😂", "🤯", "🫶"]

# --- production hardening ---------------------------------------------------
# Applied whenever DEBUG is off, so staging behaves like production.
if not DEBUG:
    SECURE_SSL_REDIRECT = env_bool("SECURE_SSL_REDIRECT", True)
    SECURE_PROXY_SSL_HEADER = ("HTTP_X_FORWARDED_PROTO", "https")
    SECURE_HSTS_SECONDS = env_int("SECURE_HSTS_SECONDS", 31536000)
    SECURE_HSTS_INCLUDE_SUBDOMAINS = True
    SECURE_HSTS_PRELOAD = True
    SESSION_COOKIE_SECURE = True
    CSRF_COOKIE_SECURE = True
    SECURE_CONTENT_TYPE_NOSNIFF = True
    SECURE_REFERRER_POLICY = "strict-origin-when-cross-origin"
    X_FRAME_OPTIONS = "DENY"

    if SECRET_KEY.startswith("dev-") or JWT_SECRET.startswith("dev-"):
        raise ImproperlyConfigured(
            "DJANGO_SECRET_KEY and JWT_SECRET must be set to real values in production."
        )
    if not ALLOWED_HOSTS or ALLOWED_HOSTS == ["*"]:
        raise ImproperlyConfigured("DJANGO_ALLOWED_HOSTS must list real hostnames.")
    if EMAIL_BACKEND.endswith("console.EmailBackend"):
        raise ImproperlyConfigured(
            "A real email backend is required: sign-in codes are the only way "
            "email users can get in."
        )

LOGGING = {
    "version": 1,
    "disable_existing_loggers": False,
    "handlers": {"console": {"class": "logging.StreamHandler"}},
    "root": {"handlers": ["console"], "level": "INFO"},
}
