# Teja

**One prompt a day. Make something small.**
Then see what the world made from the same spark.

Teja is Duolingo for creativity: a daily creative prompt, a place to respond to it,
and a feed that unlocks only once you've published. iOS-first.

```
Prompt → Create → Publish → Unlock → Discover → Streak
```

---

## Repository

| Path | What |
|---|---|
| [docs/01-prd.md](docs/01-prd.md) | PRD, user flows, screen list, IA, **and the cut list** |
| [docs/02-design-system.md](docs/02-design-system.md) | Colour, type, space, motion, components, per-screen specs |
| [docs/03-wireframes.md](docs/03-wireframes.md) | Wireframes for every screen |
| [docs/04-architecture.md](docs/04-architecture.md) | Schema, API design, Flutter architecture, folder structure |
| [app/](app/README.md) | Flutter iOS app |
| [backend/](backend/README.md) | Django Ninja API |

## Run it

```bash
# backend — SQLite by default, no containers needed
cd backend
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
python manage.py migrate && python manage.py seed_prompts
python manage.py runserver

# app
cd ../app
flutter create --platforms=ios --org app.teja --project-name teja .
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run --dart-define=TEJA_API_BASE=http://localhost:8000/api/v1
```

Postgres and Redis are production engines, not local prerequisites — see
[backend/README.md](backend/README.md) to switch over via `docker compose up -d`.

## The four decisions everything else follows from

1. **The feed is earned, not scrolled.** You cannot see today's feed until you
   publish. Enforced server-side. This single rule is what makes Teja a creation
   app instead of another consumption app.
2. **One global prompt per day.** Everyone answers the same question, so the feed
   is a campfire rather than a timeline — and it is *finite*. You can reach the end.
3. **The streak is the entire gamification budget.** No XP, no levels, no leagues,
   no badges, no freezes. One number, and a celebration screen worth 2.4 seconds.
4. **It must not look like a Flutter app.** No Material, no ripples, no FAB, no
   elevation-4 grey shadows. Warm paper, one accent, huge type, lots of air.

## What is deliberately *not* in the MVP

Follows · DMs · video/audio · multiple daily prompts · XP and badges · bookmarks ·
search and hashtags · groups · Android and web · paywall · rich-text editor ·
editing after publish · a notifications inbox.

Full reasoning in [docs/01-prd.md](docs/01-prd.md#42-explicitly-not-in-the-mvp).

## Shipping target

6 weeks, team of three (1 Flutter, 1 backend, 1 designer/PM). Week-by-week plan at
the end of the PRD. The hard gates before App Review: report/block, delete account,
Sign in with Apple, a privacy policy URL, and **60 days of curated prompts in the
database** — prompt quality is the product.
