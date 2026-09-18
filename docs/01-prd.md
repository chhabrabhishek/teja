# Teja — MVP PRD

> **Teja** (तेज) — Sanskrit for *radiance, spark, brilliance*.
> The app is named after the small spark of creativity you light every day.

---

## 1. Positioning

**Teja is Duolingo for creativity.**

One prompt a day. Make something. Publish it. See what everyone else made from the same spark.

| | |
|---|---|
| **Category** | Daily creative habit / light social |
| **Platform** | iOS first (Flutter), Android later |
| **Primary job-to-be-done** | "I want to be a creative person, but I never actually start." |
| **Core loop** | Prompt → Create → Publish → Unlock → Discover → Streak |
| **Session target** | 6–10 minutes, once a day |
| **North-star metric** | **D7 creation retention** — % of users who publish on day 7 |

### Why it works
1. **Constraint kills blank-page anxiety.** One prompt. Not "make art."
2. **Publishing is the unlock.** The feed is *earned*, not scrolled. This is the single most important product decision — it flips Teja from consumption to creation.
3. **Same prompt = instant belonging.** You are never comparing across contexts; everyone answered the same question today.
4. **Streak = identity.** "I'm on day 41" is a story people tell about themselves.

### Anti-positioning
Teja is **not** Instagram, not a portfolio, not a course, not a journaling app with locked entries. There are no followers, no likes-count leaderboard, no algorithmic ranking, no infinite scroll.

---

## 2. Target user

**Primary — "The Dormant Creative" (24–38)**
Had a creative practice once (wrote, drew, shot film). Has a demanding job. Owns the intent, lacks the trigger. Downloads Notion templates and abandons them. Will pay for something that makes them *feel* like a creative person again.

**Secondary — "The Practicing Hobbyist"**
Already sketches/writes weekly. Wants accountability and a low-stakes audience that is not their Instagram followers.

**Explicitly not MVP:** professional artists seeking clients, teens, brands.

---

## 3. MVP activity types

One category per day, rotating. Every user in the world gets the **same prompt on the same day** — this is what makes the feed feel alive.

| Category | Response | Example prompt |
|---|---|---|
| **Creative Writing** | Text (Markdown) | "Write the last text message someone sent before the world changed." |
| **Photography** | Image + optional caption | "Photograph something that has been waiting." |
| **Sketch / Art** | Image + optional caption | "Draw your morning as a single object." |
| **Joke / Funny Bit** | Short text (≤280 chars) | "The worst possible name for a boat." |

Weekly rotation (fixed, predictable — predictability is a feature):

```
Mon  Writing      Fri  Joke
Tue  Photography  Sat  Photography
Wed  Sketch       Sun  Writing
Thu  Writing
```

---

## 4. Feature scope

### 4.1 In scope (v1.0)

**Authentication**
- Sign in with Apple (primary, above the fold)
- Email one-time 6-digit code (no passwords — no reset flow, no password UI, less code, feels premium)
- JWT access (30 min) + refresh (60 day) stored in iOS Keychain

**Onboarding**
- One value screen → auth → "Which crafts pull at you?" (multi-select, purely for copy personalization + notification tone) → notification permission asked *after* first publish, not before

**Today (Home)**
- Today's prompt, hero-sized
- Category, gentle nudge line, time remaining
- Streak pill
- Primary CTA: *Start creating* / *Continue draft* / *See what others made*
- Locked community teaser when not yet published

**Compose**
- Full-screen modal
- Text editor with live-preview Markdown (writing), character counter (joke)
- Image picker + crop (photography, sketch)
- Autosaving draft
- Publish confirmation sheet

**The Spark** (post-publish moment)
- Full-screen celebratory transition: streak increments, haptic, "Day 12". This is the emotional payoff — it is a *feature*, not a toast.

**Feed**
- Today's prompt only. Chronological-ish (newest first), no algorithm
- Locked until you publish today
- Emoji reactions (fixed set of 5)
- Comments (flat, no threads)
- Report + block (App Store requirement for UGC)

**Profile**
- Avatar, display name, bio
- Current streak, longest streak, total creations
- Grid/list of your published creations
- Settings: notification time, appearance, sign out, delete account

**Notifications**
- One daily local notification at the user's chosen hour ("Today's prompt is ready.")
- That's it. One.

**AI**
- Prompts generated in batches by OpenAI, **human-reviewed before going live**. Never generated live at request time.

### 4.2 Explicitly NOT in the MVP

Cut list — each of these is a real temptation and each one is a week of your life:

| Not building | Why |
|---|---|
| Following / followers | Turns Teja into a popularity contest. Same-prompt feed is enough. |
| DMs / chat | Moderation nightmare, zero habit value. |
| Video / audio responses | Storage, transcoding, moderation, player UI. Later. |
| Multiple prompts per day | Destroys the scarcity that makes the streak mean anything. |
| Streak freezes, XP, levels, badges, leagues | Gamification overload. The streak *is* the gamification. |
| Collections / bookmarks / likes count | Consumption features. Not the loop. |
| Android / web / iPad-optimized | iOS phone only. |
| In-app purchases / paywall | Learn retention first. Monetize at v2. |
| Rich text toolbar, fonts, colors in editor | Markdown only. |
| Search, hashtags, discovery tabs | There is one feed and it is today's. |
| Groups / challenges / friends invites | v2 growth lever, not v1 loop. |
| Editing after publish | Delete-and-repost is fine. Avoids edit history + re-moderation. |
| Push via APNs server infra | Local notifications cover the one daily nudge. |
| Comment threads, mentions, notifications inbox | Flat comments only. |

---

## 5. Core user flows

### 5.1 First run (cold → first publish) — target ≤ 4 minutes

```
Launch
  └─ Welcome  ("One prompt a day. Make something small.")
       ├─ Sign in with Apple ──┐
       └─ Continue with email ─┤
             ├─ Enter email    │
             └─ 6-digit code ──┤
                               ▼
                        Pick your crafts (skippable)
                               ▼
                        Today  ← prompt revealed with a soft fade-up
                               ▼
                        [Start creating]
                               ▼
                        Compose (modal, autosaves)
                               ▼
                        [Publish] → confirm sheet
                               ▼
                        THE SPARK  (Day 1 · haptic · streak ignites)
                               ▼
                        Feed unlocked (auto-navigates, your post at top)
                               ▼
                        Ask for notification permission ("Same time tomorrow?")
```

### 5.2 Returning daily user — target ≤ 90 seconds to publish

```
Notification 9:00am → Today → prompt → Start creating → Publish → Spark → Feed
```

### 5.3 Streak-at-risk
After 8pm local, if not published: Today screen swaps the nudge line to a calm
*"3 hours left to keep day 12 alive."* — no red, no alarm, no shake animation.

### 5.4 Missed a day
Streak resets to 0. Today screen shows a warm, non-punishing card:
*"Streaks break. Practices don't. Your longest was 12 — start the next one."*

### 5.5 Reaction / comment
Feed card → tap emoji (inline, optimistic, selection haptic) or tap card → detail → comment.

---

## 6. Screen list

| # | Screen | Type | Notes |
|---|---|---|---|
| 1 | Welcome | Full | Brand moment + auth CTAs |
| 2 | Email entry | Push | |
| 3 | Code verify | Push | 6 boxes, auto-advance, auto-submit |
| 4 | Craft picker | Push | Multi-select, skippable |
| 5 | **Today** | Tab 1 | The hero screen |
| 6 | Compose | Modal (full) | Text / image variants |
| 7 | Publish confirm | Sheet | |
| 8 | **The Spark** | Full overlay | Celebration |
| 9 | **Feed** | Tab 2 | Locked state + list state |
| 10 | Submission detail | Push | Reactions + comments |
| 11 | Comments composer | Inline sheet | |
| 12 | **You** (profile) | Tab 3 | Own profile |
| 13 | Public profile | Push | Another user |
| 14 | Edit profile | Modal | Name, bio, avatar |
| 15 | Settings | Push | Notification hour, appearance, legal, sign out, delete |
| 16 | Report / block | Action sheet | |

**16 screens. That is the whole app.**

---

## 7. Information architecture

```
Teja
├── (unauthenticated)
│   └── Welcome ─ Email ─ Code ─ Crafts
│
└── (authenticated)  — CupertinoTabBar, 3 tabs
    │
    ├── ● Today                      "the spark"
    │     ├── Compose            [modal]
    │     │     └── Publish confirm  [sheet]
    │     │           └── The Spark  [full overlay]
    │     └── Feed (deep link after publish)
    │
    ├── ● Feed                       "the campfire"
    │     └── Submission detail
    │           ├── Comments
    │           └── Public profile
    │
    └── ● You                        "the proof"
          ├── Submission detail
          ├── Edit profile   [modal]
          └── Settings
```

**Navigation rules**
- Three tabs. Never four. Never a center FAB (that is a Material tell).
- Creation is always a **modal** — it is a mode, not a destination. It gets a real dismiss gesture and a "keep draft?" confirmation.
- Max depth: 3. Everything is reachable in ≤ 2 taps from a tab root.
- No hamburger, no overflow menus, no bottom sheets stacked on bottom sheets.

---

## 8. Success criteria for the MVP launch

| Metric | Target at 4 weeks post-launch |
|---|---|
| Signup → first publish | ≥ 55% |
| D1 creation retention | ≥ 35% |
| **D7 creation retention** | ≥ 18% |
| Median streak at D14 (of retained) | ≥ 5 |
| Publish → feed engagement (reaction or comment) | ≥ 40% |
| Crash-free sessions | ≥ 99.5% |

If D7 creation retention is under 10%, the prompt quality is the problem — not the UI. Fix prompts before building anything new.

---

## 9. 6-week plan (team of 3: 1 Flutter, 1 backend, 1 designer/PM)

| Week | Flutter | Backend | Design |
|---|---|---|---|
| 1 | Design system, tokens, components, router | Django+Ninja skeleton, models, JWT, Apple auth | High-fi Today, Compose, Spark |
| 2 | Auth flow, Today screen | Prompts, submissions, S3/R2 presign | Feed, Detail, Profile |
| 3 | Compose (text + image), drafts | Feed, reactions, comments, lock rule | Motion spec, empty/loading states |
| 4 | Feed, detail, reactions, comments | Streak engine, OpenAI prompt batch cmd, moderation/report | Icon, App Store screenshots, onboarding copy |
| 5 | Profile, settings, Spark polish, notifications | Rate limits, observability, seed 60 days of prompts | Prompt library curation (60 days) |
| 6 | Bug bash, a11y, Dynamic Type, dark mode QA | Load test, backups, TestFlight | App Review assets, privacy nutrition labels |

**Hard gates before submitting to App Review:** report/block flows, delete account, privacy policy URL, Sign in with Apple (required because you offer another social/3rd-party login path), and 60 days of curated prompts in the DB.
