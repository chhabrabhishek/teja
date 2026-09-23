# Dabble backend

Django 5 + Django Ninja + PostgreSQL. JWT auth, presigned media uploads, offline
AI prompt generation.

## Run it

Nothing to install, no containers: local dev defaults to SQLite with Redis off.

```bash
cd backend
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
python manage.py migrate
python manage.py seed_prompts        # 28 hand-written prompts, live immediately
python manage.py createsuperuser
python manage.py runserver
```

- API docs: http://localhost:8000/api/v1/docs
- Admin (prompt review + moderation queue): http://localhost:8000/admin/

In `DEBUG`, sign-in codes are printed to the console instead of emailed — no SMTP
needed for local development.

### Postgres + Redis (optional)

The schema is portable, but production runs Postgres. To develop against it:

```bash
docker compose up -d
# in .env:
DATABASE_URL=postgres://dabble:dabble@localhost:5432/dabble
REDIS_URL=redis://localhost:6379/0
```

Redis is only used for rate-limit counters; without it they fall back to Django's
local-memory cache, which is per-process and resets on restart. Fine locally,
not fine behind more than one worker.

**Run CI against Postgres**, not SQLite — dev/prod parity on the database is the
one place this convenience can bite you.

## Prompt pipeline

Prompts are **never** generated inside a request. No user waits on OpenAI, no bad
prompt can ship to everyone at once, and an OpenAI outage can't take the app down.

```bash
export OPENAI_API_KEY=sk-...
python manage.py generate_prompts --ensure-runway 60   # drafts, is_published=False
# review at /admin/prompts/prompt/ and tick `is_published`
python manage.py check_prompts --min-runway 14         # exits 1 when short
```

`--ensure-runway N` tops up every dateless day between today and N days out. It is
idempotent, so it is safe to run daily from cron.

### Schedule it

```cron
# top up drafts weekly
0 6 * * 1  cd /srv/dabble && /srv/dabble/.venv/bin/python manage.py generate_prompts --ensure-runway 60

# alert daily if the published runway gets short
0 7 * * *  cd /srv/dabble && /srv/dabble/.venv/bin/python manage.py check_prompts --min-runway 14
```

Pipe `check_prompts` into whatever pages you — its non-zero exit is the signal.
On Heroku/Render/Fly use their scheduler; on Kubernetes a `CronJob`; in GitHub
Actions a scheduled workflow hitting a one-off dyno. Celery is not needed for this.

> **Why review stays manual.** The prompt *is* the product — a weak one costs you a
> day of retention across every user. Generation is cheap; judgement isn't. Budget
> ten minutes a month in `/admin/`.
>
> If the runway ever hits zero, `resolve_prompt` falls back to the most recent
> published prompt. The app keeps working, but everyone silently re-gets an old
> challenge. That is why `check_prompts` alerts at 14 days, not at 1.

## Going to production

What is genuinely missing beyond local dev:

| Area | What to do | Why it blocks launch |
|---|---|---|
| **Email** | Real SMTP (Postmark / SES / Resend) + verified sending domain, SPF/DKIM | Sign-in codes are the *only* way email users get in. Settings now refuse to boot with the console backend when `DEBUG=False`. |
| **Database** | Managed Postgres, `DATABASE_URL=postgres://…`, daily backups + PITR | SQLite is single-writer; concurrent publishes will throw *database is locked*. |
| **Redis** | `REDIS_URL` set | Without it rate limits fall back to per-process local memory — useless behind 2+ workers, so the code-request limiter becomes bypassable. |
| **Media** | R2/S3 bucket, `MEDIA_*` vars, bucket CORS for PUT, lifecycle rule for orphans | Image prompts are 3 of 7 days. |
| **Secrets** | Real `DJANGO_SECRET_KEY` / `JWT_SECRET` / `EMAIL_CODE_PEPPER` | Settings now refuse to boot on `dev-` prefixed values when `DEBUG=False`. |
| **Serving** | `gunicorn -k uvicorn.workers.UvicornWorker dabble.asgi:application` behind TLS | |
| **Deploy** | Run `migrate` + `collectstatic` on release | |
| **Monitoring** | Sentry DSN, uptime check on `/api/v1/docs`, `check_prompts` alerting | |
| **Apple** | Paid developer account, `APPLE_BUNDLE_ID`, Sign in with Apple capability | Required by App Review once you offer any third-party login. |
| **Legal** | Privacy policy + terms URLs, App Privacy labels | Account deletion already ships (`DELETE /me`). |
| **Moderation** | Someone actually watching `/admin/social/report/` | UGC app — App Review checks report + block exist. |

Run `python manage.py check --deploy` before your first release; the hardening
block in `settings.py` covers HSTS, SSL redirect, secure cookies and nosniff.

## Layout

```
dabble/
  api.py          NinjaAPI assembly — the whole surface area on one page
  common/         auth (JWT), errors, pagination, ratelimit, storage (presign)
  accounts/       User, Streak, Block, Apple + email-code sign-in
  prompts/        Prompt, the daily rotation, OpenAI generator + seed command
  submissions/    Submission, drafts, publish, streak engine
  social/         Reaction, Comment, Report
  feed/           today's feed + the server-side lock rule
```

## The two rules worth knowing

1. **The feed lock is server-side.** `GET /feed/today` returns
   `{"locked": true, items: []}` with **200**, not 403 — the client renders a
   designed lock screen, not an error.
2. **Streaks are written only on publish.** There is no nightly cron; a stale
   streak is resolved on read by `Streak.current_for(today)`.

## Tests worth writing first

- `record_publish` across a day boundary, a gap, and a double-publish (idempotency)
- feed lock: unpublished user sees `locked: true`, publishing unlocks in the same request cycle
- email code: expiry, attempt lockout, single-use
- keyset pagination returns no duplicates when rows are inserted mid-scroll
