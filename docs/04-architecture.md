# Teja — Architecture

## 1. System overview

```
┌──────────────┐    HTTPS/JSON     ┌─────────────────────┐
│ Flutter iOS  │ ────────────────► │  Django + Ninja     │
│  Riverpod    │ ◄──────────────── │  (ASGI / uvicorn)   │
│  GoRouter    │    JWT bearer     └─────────┬───────────┘
│  Freezed     │                             │
└──────┬───────┘                   ┌─────────┴─────────┐
       │  presigned PUT            │                   │
       └──────────────────────► ┌──▼───────┐    ┌──────▼─────┐
                                │ S3 / R2  │    │ PostgreSQL │
                                │  media   │    └────────────┘
                                └──────────┘    ┌────────────┐
                                                │ Redis (opt)│
                                                └────────────┘
       OpenAI ──► management command (batch, offline) ──► prompts table
```

**Key decisions**
- Media never transits the API server. Client asks for a presigned PUT, uploads directly, sends back the object key.
- Prompts are generated **offline in batches** and human-reviewed. Zero OpenAI latency or spend in the request path, zero risk of a bad prompt shipping to every user at once.
- The schema is deliberately portable: **SQLite locally, Postgres in production.** No array/citext/JSONB-specific columns, and row locks go through `common/db.for_update()` which no-ops on backends without them. A new laptop needs nothing installed to run the API. CI runs against Postgres so parity is still tested.
- Redis is optional everywhere: used only for rate limiting and the feed count cache, falling back to Django's cache. Postgres handles everything else at MVP scale.
- The "feed lock" is enforced **server-side**. A client can't peek by patching the app.

---

## 2. Database schema

```
users
  id                uuid   pk
  email             citext unique
  apple_sub         text   unique null
  username          citext unique          -- @handle, 3–20 [a-z0-9_]
  display_name      text
  bio               text   default ''      -- ≤160
  avatar_key        text   null            -- object key in bucket
  timezone          text   default 'UTC'   -- IANA, drives "today"
  reminder_hour     smallint null          -- 0–23 local, null = off
  preferred_categories json default '[]'   -- json, not array: keeps SQLite working
  is_active         bool   default true
  created_at        timestamptz
  last_seen_at      timestamptz

email_codes
  id            uuid pk
  email         citext  idx
  code_hash     text                        -- sha256(code + pepper)
  attempts      smallint default 0          -- lock at 5
  expires_at    timestamptz                 -- now + 10 min
  consumed_at   timestamptz null
  created_at    timestamptz

refresh_tokens
  id            uuid pk
  user_id       fk users cascade
  token_hash    text unique
  expires_at    timestamptz
  revoked_at    timestamptz null
  device_label  text
  created_at    timestamptz

prompts
  id            uuid pk
  date          date unique idx             -- one global prompt per UTC-ish day
  category      text                        -- writing|photo|sketch|joke
  text          text                        -- the prompt itself
  nudge         text                        -- "Five minutes is enough."
  source        text default 'openai'       -- openai|human
  is_published  bool default false          -- human review gate
  created_at    timestamptz

submissions
  id               uuid pk
  user_id          fk users cascade
  prompt_id        fk prompts restrict
  kind             text                     -- text|image
  body             text default ''          -- markdown (text) or caption (image)
  image_key        text null
  image_width      int null
  image_height     int null
  status           text default 'draft'     -- draft|published
  published_at     timestamptz null
  reaction_count   int default 0            -- denormalised
  comment_count    int default 0            -- denormalised
  is_removed       bool default false       -- moderation soft-delete
  created_at       timestamptz
  updated_at       timestamptz

  unique (user_id, prompt_id)                -- one submission per user per day
  index (prompt_id, status, published_at desc)

reactions
  id            uuid pk
  submission_id fk submissions cascade
  user_id       fk users cascade
  emoji         text                        -- one of 5 allowed
  created_at    timestamptz
  unique (submission_id, user_id, emoji)

comments
  id            uuid pk
  submission_id fk submissions cascade
  user_id       fk users cascade
  body          text                        -- ≤500, plain text
  is_removed    bool default false
  created_at    timestamptz
  index (submission_id, created_at)

streaks                                      -- 1:1 with user
  user_id       pk fk users cascade
  current       int  default 0
  longest       int  default 0
  last_date     date null                    -- last local date published
  total         int  default 0
  updated_at    timestamptz

blocks
  blocker_id    fk users   ┐ composite pk
  blocked_id    fk users   ┘
  created_at    timestamptz

reports
  id            uuid pk
  reporter_id   fk users
  submission_id fk submissions null
  comment_id    fk comments null
  reason        text                          -- spam|harassment|nsfw|other
  note          text default ''
  resolved_at   timestamptz null
  created_at    timestamptz
```

**8 tables + 2 safety tables. That's the whole model.**

### Streak rule (the one piece of real business logic)
On publish, compute `today = now in user.timezone`:
- `last_date == today` → no change (idempotent).
- `last_date == today - 1` → `current += 1`.
- otherwise → `current = 1`.
- `longest = max(longest, current)`, `total += 1`, `last_date = today`.

No freezes, no grace periods. Streak *display* is computed lazily on read: if `last_date < today - 1`, show 0 (the stored value is only rewritten on the next publish). This avoids a nightly cron entirely.

---

## 3. API design — Django Ninja

Base: `/api/v1`. Auth: `Authorization: Bearer <access>`. All errors:
`{"detail": "...", "code": "snake_case_code"}`.

### Auth
| Method | Path | Body → Response |
|---|---|---|
| POST | `/auth/apple` | `{identity_token, nonce?, full_name?}` → `TokenPair` |
| POST | `/auth/email/request` | `{email}` → `{sent: true, expires_in: 600}` (always 200, never leaks existence) |
| POST | `/auth/email/verify` | `{email, code}` → `TokenPair` |
| POST | `/auth/refresh` | `{refresh_token}` → `TokenPair` (rotating) |
| POST | `/auth/logout` | `{refresh_token}` → `204` |

`TokenPair = {access_token, refresh_token, expires_in, is_new_user, user}`

### Me
| Method | Path | |
|---|---|---|
| GET | `/me` | full profile + streak |
| PATCH | `/me` | `{display_name?, username?, bio?, avatar_key?, timezone?, reminder_hour?, preferred_categories?}` |
| DELETE | `/me` | hard delete, cascades — App Store requirement |

### Prompts
| Method | Path | |
|---|---|---|
| GET | `/prompts/today` | resolves by the caller's timezone. Returns prompt + `my_submission` (draft or published) + `creator_count` + `seconds_remaining` |
| GET | `/prompts/{date}` | past prompt (read-only) |

`GET /prompts/today` is the single call that powers the whole Today screen. One round trip, no waterfall.

### Media
| Method | Path | |
|---|---|---|
| POST | `/media/upload-url` | `{content_type, purpose: submission\|avatar}` → `{key, upload_url, headers, public_url, expires_in}` |

Presigned PUT, 5-minute expiry, 10 MB cap enforced by the policy, content-type allow-list `image/jpeg|image/png|image/heic`.

### Submissions
| Method | Path | |
|---|---|---|
| POST | `/submissions` | upsert today's draft `{prompt_id, kind, body, image_key?, w?, h?}` → `Submission` |
| POST | `/submissions/{id}/publish` | → `{submission, streak}` — **this is the unlock event** |
| DELETE | `/submissions/{id}` | own only |
| GET | `/submissions/{id}` | 404 if removed or author blocked |

### Feed
| Method | Path | |
|---|---|---|
| GET | `/feed/today?cursor=&limit=20` | `{locked: bool, creator_count, prompt, items[], next_cursor}` |

If the caller hasn't published today, returns `{locked: true, creator_count, items: []}` with **200, not 403** — the client renders a designed locked state, not an error. Keyset pagination on `(published_at, id)`.

### Reactions & comments
| Method | Path | |
|---|---|---|
| PUT | `/submissions/{id}/reactions/{emoji}` | idempotent add → `{counts}` |
| DELETE | `/submissions/{id}/reactions/{emoji}` | idempotent remove |
| GET | `/submissions/{id}/comments?cursor=` | |
| POST | `/submissions/{id}/comments` | `{body}` |
| DELETE | `/comments/{id}` | own, or own submission |

### Users & safety
| Method | Path | |
|---|---|---|
| GET | `/users/{username}` | public profile + streak stats |
| GET | `/users/{username}/submissions?cursor=` | published only |
| POST | `/users/{username}/block` / `DELETE` | |
| POST | `/reports` | `{submission_id? , comment_id?, reason, note?}` |

### Rate limits (Redis if present, DB fallback)
`/auth/email/request` 3/hour/email + 10/hour/IP · `/auth/email/verify` 5/code ·
`/comments` 30/hour/user · `/reports` 20/day/user · everything else 120/min/user.

---

## 4. Flutter architecture

### Layering
```
presentation   screens + widgets            (Consumer widgets, zero business logic)
      ▲
controllers    AsyncNotifier / Notifier     (state machines, optimistic updates)
      ▲
repositories   ApiSubmissionRepository…     (maps DTO → domain, caches)
      ▲
data           ApiClient (dio) + DTOs       (transport only)
      ▲
domain         Freezed models + enums       (pure dart, no imports from above)
```

Rules:
- A screen never touches `ApiClient`.
- A repository never imports Flutter.
- Domain models are Freezed unions where a state has genuinely distinct shapes (`TodayState.loading | ready | error`), plain Freezed data classes otherwise.
- Riverpod providers are declared **manually** (`NotifierProvider`, `FutureProvider`) — Freezed is the only code generator in the project, which keeps `build_runner` fast and the tree readable.

### Key providers
| Provider | Type | Purpose |
|---|---|---|
| `apiClientProvider` | `Provider<ApiClient>` | dio + auth interceptor + refresh queue |
| `authControllerProvider` | `NotifierProvider<AuthController, AuthState>` | session, drives router redirect |
| `todayControllerProvider` | `AsyncNotifierProvider<TodayController, TodayState>` | prompt + my submission + counts |
| `composeControllerProvider` | `AutoDisposeNotifierProvider.family` | draft text, autosave debounce, upload |
| `feedControllerProvider` | `AsyncNotifierProvider<FeedController, FeedState>` | lock state, pagination, optimistic reactions |
| `profileControllerProvider` | `.family<String?>` | own or public profile |
| `themeModeProvider` | `NotifierProvider` | system/light/dark, persisted |

**Cross-feature invalidation:** publishing calls `ref.invalidate(feedControllerProvider)` and updates `todayControllerProvider` in place — the Feed is already unlocked by the time The Spark auto-advances.

### Routing (GoRouter)
```
/welcome
/auth/email
/auth/code?email=
/auth/crafts
StatefulShellRoute (CupertinoTabScaffold)
  /today            → /today/compose        (fullscreenDialog)
                    → /today/spark          (opaque, no back)
  /feed             → /feed/s/:id
  /you              → /you/edit  /you/settings  /you/s/:id
/u/:username
```
`redirect` reads `authControllerProvider`: unauthenticated → `/welcome`; authenticated on an auth route → `/today`. All pages use `CupertinoPage` so back-swipe works natively.

### Folder structure

```
app/
├── pubspec.yaml
└── lib/
    ├── main.dart
    ├── app/
    │   ├── teja_app.dart
    │   ├── router.dart
    │   └── theme.dart
    ├── core/
    │   ├── env.dart
    │   ├── api/
    │   │   ├── api_client.dart
    │   │   ├── api_exception.dart
    │   │   ├── auth_interceptor.dart
    │   │   └── token_store.dart
    │   └── utils/
    │       ├── date_x.dart
    │       └── haptics.dart
    ├── design/
    │   ├── tokens/
    │   │   ├── colors.dart
    │   │   ├── typography.dart
    │   │   ├── spacing.dart
    │   │   ├── shadows.dart
    │   │   └── motion.dart
    │   └── components/
    │       ├── teja_scaffold.dart
    │       ├── teja_button.dart
    │       ├── teja_card.dart
    │       ├── teja_press.dart
    │       ├── aurora_background.dart
    │       ├── category_chip.dart
    │       ├── prompt_hero_card.dart
    │       ├── streak_pill.dart
    │       ├── week_strip.dart
    │       ├── reaction_bar.dart
    │       ├── submission_card.dart
    │       ├── avatar.dart
    │       ├── empty_state.dart
    │       ├── skeleton.dart
    │       └── stat_row.dart
    ├── domain/
    │   ├── enums.dart
    │   └── models.dart            (Freezed: User, Prompt, Submission, Comment, Streak…)
    ├── data/
    │   ├── auth_repository.dart
    │   ├── prompt_repository.dart
    │   ├── submission_repository.dart
    │   ├── feed_repository.dart
    │   ├── media_repository.dart
    │   └── profile_repository.dart
    └── features/
        ├── auth/     (welcome, email, code, crafts screens + controller)
        ├── today/    (today screen + controller)
        ├── compose/  (compose screen, publish sheet, spark screen + controller)
        ├── feed/     (feed screen, detail screen + controllers)
        ├── profile/  (profile screen, edit, settings + controller)
        └── shell/    (tab scaffold)
```

### Backend folder structure
```
backend/
├── manage.py
├── pyproject.toml
├── .env.example
├── docker-compose.yml
└── teja/
    ├── settings.py  urls.py  asgi.py  wsgi.py
    ├── api.py                      # NinjaAPI + router registration
    ├── common/      auth.py  errors.py  pagination.py  ratelimit.py  storage.py
    ├── accounts/    models.py  schemas.py  api.py  apple.py  emailcode.py
    ├── prompts/     models.py  schemas.py  api.py  generator.py
    │                management/commands/generate_prompts.py
    ├── submissions/ models.py  schemas.py  api.py  streaks.py
    ├── social/      models.py  schemas.py  api.py    # reactions, comments, reports, blocks
    └── feed/        api.py
```

---

## 5. Non-functional

| Concern | MVP approach |
|---|---|
| Observability | Sentry (Flutter + Django), structured JSON logs, one dashboard: signups, publishes, D1/D7 |
| Secrets | env vars, never in repo; `.env.example` documents every key |
| Backups | managed Postgres daily snapshot, 7-day PITR |
| Media | private bucket + CDN with signed-ish public read prefix; EXIF stripped on upload via presign policy + a nightly cleanup of orphaned keys |
| Moderation | report + block + soft-delete + a Django admin queue. No ML in v1 |
| Privacy | Sign in with Apple private relay supported; delete account is a real cascade delete |
| Testing | Backend: pytest on streak logic, feed lock, auth. Flutter: widget tests on the design system + golden tests on Today in both themes |
| CI | GitHub Actions: `ruff` + `pytest` for backend, `flutter analyze` + `flutter test` for app |
