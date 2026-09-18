# Teja — Design System

> Everything here is implemented in `app/lib/design/`. This doc is the source of truth;
> the Dart tokens mirror it 1:1.

---

## 0. Design philosophy

Five rules that resolve every argument:

1. **The prompt is the hero.** On the Today screen, the prompt is physically the largest thing on the display. Nothing competes with it.
2. **One action per screen.** There is exactly one Ember-coloured element in the viewport at a time. If you see two, one is wrong.
3. **Warm paper, not cold glass.** Backgrounds are warm off-white / warm near-black. Pure `#FFFFFF` and pure `#000000` are banned as canvas colours.
4. **Motion is breath, not bounce.** Everything eases out. Nothing overshoots except The Spark, which is allowed exactly one moment of joy.
5. **Earn the ink.** Empty space is not wasted space — it is the feeling of calm we are selling. When in doubt, delete an element.

### Material Design tells to hunt and kill
| Banned | Use instead |
|---|---|
| `FloatingActionButton` | Full-width pill CTA in the content flow |
| `AppBar` with elevation + 20sp title | Large iOS title that collapses on scroll; hairline divider only |
| Ripple / `InkWell` splash | Opacity + 0.97 scale press-down, 120ms |
| `SnackBar` | Top-sliding toast pill, or nothing |
| `Drawer`, `BottomNavigationBar` (Material) | `CupertinoTabScaffold` |
| Elevation 4/8/16 grey drop shadows | Two-layer warm, very-low-alpha shadow |
| Purple/teal accents, saturated fills | Single Ember accent, desaturated category hues |
| `CircularProgressIndicator` | `CupertinoActivityIndicator` or skeleton shimmer |
| Material switches, sliders, dialogs | Cupertino equivalents throughout |

---

## 1. Colour palette

### Philosophy
One warm accent. A warm neutral ramp. Four desaturated category hues that appear only as small chips and glyphs. Nothing else. The palette should look like a well-printed book, not a dashboard.

### Light mode — "Paper"

| Token | Hex | Use |
|---|---|---|
| `canvas` | `#FBF8F4` | App background (warm paper) |
| `surface` | `#FFFFFF` | Cards |
| `surfaceAlt` | `#F3EFE8` | Inset fields, skeletons, chips |
| `hairline` | `#E7E0D6` | 0.5pt dividers, card borders |
| `ink` | `#17130F` | Primary text |
| `inkSecondary` | `#6A6157` | Body secondary, metadata |
| `inkTertiary` | `#A29889` | Placeholders, disabled, timestamps |
| `ember` | `#DC5B34` | **The** accent. CTAs, streak, active tab |
| `emberSoft` | `#FBEAE2` | Ember tint fills, selected chip bg |
| `glow` | `#F0A63C` | Spark gradient partner only |
| `success` | `#3E7D5A` | Published confirmations |
| `danger` | `#C0392B` | Destructive only |
| `scrim` | `rgba(23,19,15,0.32)` | Modal backdrop |

### Dark mode — "Ink"

Not an inversion. Dark mode is a *different* material: warm charcoal, no shadows, light comes from hairlines and the accent.

| Token | Hex | Use |
|---|---|---|
| `canvas` | `#0D0C0B` | App background (warm black) |
| `surface` | `#161413` | Cards |
| `surfaceAlt` | `#201D1B` | Inset fields, skeletons |
| `hairline` | `#2B2725` | Dividers, card borders (borders replace shadows here) |
| `ink` | `#F6F2ED` | Primary text |
| `inkSecondary` | `#A79F96` | Secondary |
| `inkTertiary` | `#6C645B` | Tertiary |
| `ember` | `#FF7A4F` | Lifted for AA contrast on dark |
| `emberSoft` | `#2E1A12` | Tint fills |
| `glow` | `#FFB85C` | |
| `success` | `#5AA37B` | |
| `danger` | `#E05C4B` | |
| `scrim` | `rgba(0,0,0,0.56)` | |

### Category hues (identical in both modes, alpha-tinted per mode)

| Category | Hex | Feeling |
|---|---|---|
| Creative Writing | `#5A6A9E` | Slate blue — ink, evening |
| Photography | `#5E7D68` | Moss — light, outdoors |
| Sketch / Art | `#B2684A` | Clay — graphite and paper |
| Joke | `#84557A` | Plum — wit, warmth |

Category hue appears **only** in: the category chip, the small glyph, and a 4% background wash behind the prompt hero. Never a full-bleed fill.

### Contrast
All text/background pairs meet WCAG AA (4.5:1 body, 3:1 for ≥22pt). `inkTertiary` on `canvas` = 3.1:1 and is therefore **only** used for ≥13pt semibold metadata, never body copy.

---

## 2. Typography

**Family: San Francisco (system).** On iOS, Flutter resolves the system face when `fontFamily` is null — SF Pro Display for ≥20pt, SF Pro Text below. We use *no custom font in v1*: SF with correct optical tracking already looks more premium than a mis-licensed webfont.

> Optional v1.1 upgrade: bundle **Fraunces** (variable serif, OFL) for `displayXL` only, to give the prompt a literary, Apple-Journal feel. The token `TejaText.display*` is the single place to swap it.

### Scale

| Token | Size / Line | Weight | Tracking | Use |
|---|---|---|---|---|
| `displayXL` | 40 / 46 | 700 | −1.1 | Today's prompt (short) |
| `display` | 32 / 40 | 700 | −0.8 | Today's prompt (long), Spark day count |
| `title1` | 28 / 34 | 700 | −0.6 | Screen large titles |
| `title2` | 22 / 28 | 650 | −0.4 | Section headers, sheet titles |
| `headline` | 17 / 22 | 600 | −0.2 | Card titles, names, buttons |
| `body` | 17 / 27 | 400 | 0 | Reading text, submissions, comments |
| `bodyEmphasis` | 17 / 27 | 600 | 0 | Inline emphasis |
| `callout` | 16 / 24 | 400 | 0 | Secondary paragraphs |
| `subhead` | 15 / 20 | 500 | 0 | Metadata rows |
| `footnote` | 13 / 18 | 500 | 0 | Timestamps, counts |
| `eyebrow` | 12 / 16 | 700 | +1.2 | UPPERCASE labels: date, category, section |

### Rules
- **Never more than 3 type sizes per screen.**
- Long-form reading text (`body`) is capped at **68 characters** per line via horizontal padding.
- `eyebrow` is the only uppercase style in the app.
- Numerals in streaks and counters use `FontFeature.tabularFigures()` so digits don't jitter when animating.
- Dynamic Type supported up to `accessibilityLarge`; `displayXL` caps its scale factor at 1.3 so the prompt never pushes the CTA off-screen.

---

## 3. Space, radius, elevation

### Spacing scale (4pt base)
`4 · 8 · 12 · 16 · 20 · 24 · 32 · 40 · 56 · 72`

- Screen horizontal gutter: **20**
- Card internal padding: **20** (24 for the prompt hero)
- Gap between stacked cards: **16**
- Gap between sections: **32**
- Safe bottom padding above tab bar: **24**

### Radius
| Token | Value | Use |
|---|---|---|
| `rControl` | 14 | Buttons, fields, chips (small) |
| `rCard` | 20 | Standard cards, feed cards |
| `rHero` | 28 | Prompt hero, Spark card, sheets |
| `rImage` | 18 | Media thumbnails |
| `rPill` | 999 | Streak pill, category chip, CTA |

Corners are **continuous** (squircle), not circular. Use `BorderRadius` with `SmoothRectangleBorder`-style clipping via `ClipRSuperellipse` where available; visually this is the single biggest "feels like iOS" cue.

### Elevation
Light mode — two-layer, warm-tinted, low alpha:
```
ambient: 0px  1px  2px  rgba(23,19,15,0.04)
key:     0px 12px 28px  rgba(23,19,15,0.06)
hero:    0px 20px 48px  rgba(23,19,15,0.09)
```
Dark mode — **no shadows at all.** Depth comes from `surface` vs `canvas` lightness plus a 1px `hairline` border. This is how Apple Journal, Linear and Notion handle dark.

---

## 4. Motion

| Token | Duration | Curve | Use |
|---|---|---|---|
| `instant` | 120ms | easeOut | Press states, toggles |
| `quick` | 200ms | easeOutCubic | Chips, reactions, inline swaps |
| `standard` | 320ms | `Cubic(0.22, 1, 0.36, 1)` | Screen content fade-up, cards |
| `deliberate` | 520ms | `Cubic(0.16, 1, 0.3, 1)` | Modal present, prompt reveal |
| `spark` | 900ms | spring (damping 12) | The Spark celebration only |

### Signature motions
1. **Prompt reveal** — on Today mount, the hero card fades in (0→1) and translates y +16→0 over `deliberate`, with the eyebrow/category/CTA staggered at +60ms each. Runs once per day, not on every tab switch.
2. **Press** — every tappable: `scale 1 → 0.97`, `opacity 1 → 0.85`, `instant`, reversed on release. No ripple, ever.
3. **Streak ignite** — in The Spark, the number counts up with tabular figures while a radial glow scales 0.6→1 and fades 0.9→0. One heavy haptic on the number change.
4. **Reaction** — emoji scales 1 → 1.25 → 1 over `quick`, count cross-fades, selection haptic. Optimistic; silently reverts on failure.
5. **Feed unlock** — the locked overlay does not disappear; it *dissolves* (blur 20→0, opacity 1→0) over `deliberate` as the list fades up beneath it.
6. **Tab switch** — cross-fade only, 160ms. No slide. Tab roots keep their scroll position.

### Haptics
| Event | Haptic |
|---|---|
| Publish success | `heavyImpact` |
| Streak increment | `heavyImpact` (once) |
| Reaction toggle | `selectionClick` |
| Tab change | `selectionClick` |
| Destructive confirm | `mediumImpact` |
| Error | `vibrate` (single) |

**Respect `MediaQuery.disableAnimations`** — when reduce-motion is on, all transforms collapse to cross-fades and The Spark becomes a static card.

---

## 5. Core components

All in `app/lib/design/components/`.

### `TejaScaffold`
Cupertino page scaffold. Warm canvas, large collapsing title, optional `AuroraBackground`, safe-area aware, keyboard-avoiding.

### `TejaButton`
Variants: `primary` (Ember fill, white ink), `secondary` (surfaceAlt fill, ink), `quiet` (text only, Ember ink), `destructive`.
Sizes: `large` (54h, full width, `rPill`), `medium` (44h), `small` (32h).
States: default · pressed (scale 0.97 + 85% opacity) · loading (`CupertinoActivityIndicator`, label hidden, width locked) · disabled (40% opacity, no press).

### `TejaCard`
`surface` fill, `rCard`, elevation `key` in light / `hairline` border in dark. Optional `onTap` wraps in press-scale.

### `PromptHeroCard`
The signature component. Category chip → prompt in `displayXL`/`display` (auto-downshifts at >90 chars) → nudge line in `callout` `inkSecondary` → time-remaining footnote. 4% category-hue wash behind. `rHero`, elevation `hero`.

### `StreakRing`
Circular progress ring (2.5pt, Ember, rounded caps) showing progress through *today* (hours elapsed → ring fill), with the day count in tabular figures at centre. Pill variant for the Today header: 🔥-free — we use a small filled dot + number, because flames are the gamified cliché we're avoiding.

### `CategoryChip`
Pill, category-hue at 12% fill, category-hue ink, 12pt `eyebrow`, optional 14pt glyph.

### `WeekStrip`
7 dots, Mon–Sun. Filled = created, ring = today (pulsing 2% scale), empty = missed. Ambient proof of practice, no numbers.

### `SubmissionCard` (feed)
Avatar 32 → name `headline` + time `footnote` → content (text: 6-line clamp with fade mask; image: aspect-preserved, `rImage`, max 4:5) → `ReactionBar` + comment count. Whole card tappable to detail.

### `ReactionBar`
Fixed set, chosen for warmth rather than judgement: **💛 🔥 😂 🤯 🫶**. Selected = `emberSoft` fill + Ember ink. Counts hidden when 0 (no zero-shaming).

### `EmptyState`
Centred: soft line-art glyph (28pt, `inkTertiary`) → title `title2` → one line `callout` → optional `quiet` button. Never an illustration of a person. Never a sad face.

### `SkeletonBox` / `Shimmer`
`surfaceAlt` blocks with a 1.4s warm sweep at 6% opacity. Skeletons match the real layout exactly so content doesn't jump.

### `AuroraBackground`
Two very soft radial blobs (Ember 7%, Glow 5%) drifting on a 40s loop behind the Today and Spark screens. **This is the one decorative element in the app.** Disabled under reduce-motion and in Low Power Mode.

---

## 6. Screen specifications

> Format for each: **Layout rationale → Hierarchy → Interactions → Empty → Loading → Dark**

---

### 6.1 Welcome

**Rationale.** A single held breath. The brand promise in one sentence, auth below it, nothing else. No carousel — carousels are where trust goes to die.

**Hierarchy**
```
AuroraBackground (static, 60% intensity)
  Spacer (35% of height)
  Wordmark "Teja"                      title1, ink
  "One prompt a day.\nMake something small."   displayXL, ink, 2 lines
  "Then see what the world made from the same spark."  callout, inkSecondary
  Spacer
  [ Sign in with Apple ]               native black/white button, 54h, rPill
  [ Continue with email ]              secondary, 54h
  "By continuing you agree to Terms & Privacy"  footnote, inkTertiary, tappable spans
  SafeArea 24
```

**Interactions.** Apple button uses `sign_in_with_apple` native sheet. Email pushes with a Cupertino slide. On auth failure: inline text under the buttons, never a dialog.
**Loading.** Button enters loading state; nothing else moves.
**Dark.** Aurora drops to 4%; Apple button flips to white-on-black variant.

---

### 6.2 Email + Code

**Rationale.** Two screens, one field each, zero decisions. Keyboard is up on arrival every time.

**Email** — large title "What's your email?" · single underlined field (no box — boxes feel like forms) · continue enabled only on valid regex · footnote "We'll send a 6-digit code. No password to remember."

**Code** — large title "Check your email" · subtitle with the address + a `quiet` "Change" · 6 character boxes (`rControl`, `surfaceAlt`, auto-advance, paste-aware, auto-submit on 6th) · "Resend in 0:42" countdown then tappable.

**Interactions.** Wrong code: boxes shake **once** (±6px, 240ms), clear, refocus box 1, haptic error. Never a modal.
**Loading.** Boxes lock at 60% opacity, spinner replaces the countdown.
**Dark.** Boxes `surfaceAlt`, focused box gets a 1.5px Ember border.

---

### 6.3 Craft picker

**Rationale.** A tiny investment ritual — it makes the app feel like it's about *you* before you've made anything. Skippable, because forcing it would betray the "no friction" promise.

Title "Which pull at you?" · subtitle "You'll still get every prompt — this just shapes how we talk to you." · 4 large selectable cards (2×2 grid, `rCard`, category-hue glyph, name). Selected = category-hue 12% fill + 1.5px hue border + checkmark. `[Continue]` pinned; `Skip` as a `quiet` nav-bar trailing action.

---

### 6.4 **Today** — the hero screen

**Rationale.** Someone should be able to glance at this screen in a notification-shade preview and know exactly what to make today. The prompt occupies the optical centre. The streak is present but small — proof, not pressure. The community is visible but *locked*, which converts curiosity into creation.

**Hierarchy**
```
AuroraBackground
NavBar: large title "Today"            trailing: StreakRing pill → You tab
Scroll:
  eyebrow  "TUESDAY · 16 SEPTEMBER"    inkTertiary
  PromptHeroCard
     CategoryChip  "CREATIVE WRITING"
     "Write the last text message someone sent before the world changed."
     "Five minutes is enough."         callout inkSecondary
     "· 6h 12m left today"             footnote inkTertiary
  [ Start creating ]                   primary large        ← the only Ember fill
  WeekStrip                            7 dots, centred
  ── 32 ──
  CommunityTeaser (locked)
     3 overlapped blurred thumbnails
     "1,204 people created today"      headline
     "Publish yours to unlock the feed" footnote inkTertiary
```

**State machine** — the CTA and teaser are the same components in three states:

| State | CTA | Teaser | Streak |
|---|---|---|---|
| Not started | `Start creating` | Locked, blurred | current |
| Draft exists | `Continue draft` + footnote "Saved 4m ago" | Locked | current |
| Published | `See what others made` (secondary) + a small "You created today" card with your thumbnail | Unlocked, live count | current +1, ring full |

**Interactions.** Pull-to-refresh re-fetches the prompt (Cupertino refresh control). Tapping the prompt text itself also starts creating — the whole hero is a tap target. Long-press prompt → share sheet (prompt text + app link) — a free growth loop.
**Empty.** There is no empty state: if the API has no prompt for today (should never happen — prompts are seeded 60 days out), show a curated evergreen fallback prompt shipped in the bundle. **Never show an error on the home screen.**
**Loading.** Skeleton hero card + skeleton CTA. Aurora renders immediately so the screen never flashes flat.
**Dark.** Hero card `surface` on `canvas` with `hairline` border, no shadow; the category wash drops to 8% for visibility; Ember CTA becomes `#FF7A4F`.

---

### 6.5 Compose

**Rationale.** A writing room, not a form. The prompt stays pinned at the top in small type so you never lose the thread, but it recedes. Chrome is minimal: Cancel, the saved indicator, and Publish. The keyboard is the interface.

**Hierarchy**
```
Modal, rHero top corners, drag handle
NavBar: [Cancel]   "Draft · saved"   [Publish]
  prompt recap                        subhead inkSecondary, 2-line clamp, tappable to expand
  ── hairline ──
  TEXT variant:
     TextField, body, no border, autofocus, placeholder "Start anywhere…"
     KeyboardToolbar: [ ** ] [ _ ] [ # ] [ • ] [ ” ]   |  [Preview]  |  word count
  IMAGE variant:
     Tap-to-add tile (rImage, dashed hairline, 4:5) → picker sheet (Camera / Library)
     After pick: image with a [Replace] quiet button; caption field below (optional, 1–2 lines)
  JOKE variant:
     Same as TEXT but 280-char counter that turns Ember at 260 and blocks at 280
```

**Interactions.**
- Autosave draft: debounced 1.5s + on background + on dismiss. The "saved" label cross-fades `Saving… → Draft · saved`.
- `Publish` is disabled until content is non-empty; tapping it opens a confirm sheet: "Publish to today's feed? Everyone who created today will see it." `[Publish]` / `[Keep editing]` — because publishing is irreversible-ish and the small pause raises perceived value.
- Swipe-down to dismiss triggers a Cupertino action sheet: `Keep draft` / `Discard` / `Cancel`.
- Markdown preview is a *toggle on the same surface* (cross-fade), not a second screen.

**Empty.** Placeholder copy is prompt-aware ("Start anywhere…" / "Add your photo" / "Punchline first?").
**Loading.** Publish → button spinner, editor locks at 60% opacity, image upload shows a determinate 2px Ember bar under the nav bar.
**Error.** Upload failure → inline pill above the keyboard: "Couldn't upload. Retry" — draft is never lost.
**Dark.** Canvas `#0D0C0B`, caret Ember, toolbar `surfaceAlt` with hairline top border.

---

### 6.6 The Spark

**Rationale.** This is the dopamine. It lasts ~2.4 seconds and then gets out of the way. It is the reason people come back tomorrow.

```
Full-screen Ember→Glow radial aurora over canvas (18% peak)
   center:  radial glow burst (scale 0.6→1, fade out)
            "DAY"        eyebrow, inkSecondary
            "12"         display 72pt, tabular, counts up from 11
            "You made something today."   title2
            WeekStrip (the new dot fills last, +120ms)
   bottom:  [ See what others made ]   primary large
            "Back to Today"            quiet
```
Auto-advances to Feed after 2.4s if untouched. Heavy haptic on the number change. Under reduce-motion: static, no count-up, no auto-advance.

---

### 6.7 Feed

**Rationale.** A campfire, not a timeline. It is finite — only today's prompt — and that finiteness is the whole point. You can reach the end. There is no infinite scroll, and when you hit the bottom you get a gentle "That's everyone so far. Come back tonight." That respects the user and reinforces daily rhythm.

**Locked state** (has not published today)
```
Blurred, non-scrollable stack of 3 real cards (blur 20, 55% opacity)
Centred glass card:
   lock glyph (small, inkTertiary)
   "Create to unlock"                  title2
   "See what 1,204 people made from today's prompt."  callout inkSecondary
   [ Start creating ]                  primary
```
**Unlocked list**
```
NavBar: large title "Today's Feed"     trailing: prompt recap ⓘ → sheet
  prompt recap strip (sticky, 44h, hairline bottom, subhead, category chip)
  SubmissionCard ×N   (yours pinned first with a subtle "You" tag for 24h)
  footer: "That's everyone so far."    footnote inkTertiary, centred
```
**Interactions.** Cursor pagination at 80% scroll. Pull-to-refresh. Reactions inline + optimistic. Tap → detail. Long-press → report/block action sheet.
**Empty (unlocked, you're first).** "You're first today. 🌱 → Others will appear through the day. Check back tonight." Genuinely delightful — being first should feel good.
**Loading.** 3 skeleton cards matching real geometry.
**Dark.** Cards `surface` + hairline; images get a 1px inner hairline so white photos don't bleed into the canvas.

---

### 6.8 Submission detail

**Rationale.** Reading room. Full content, no clamp, generous measure, then reactions, then comments. Author is a tap away but never the focus.

```
NavBar: back · author name (collapses in) · trailing ⋯ (report/block/delete-if-mine)
  Author row: avatar 44, name headline, "· 2h" footnote, streak badge "Day 12" (quiet)
  Content: body, 68ch measure / image full-width rImage
  ReactionBar (large, 44h taps)
  ── hairline ──
  "COMMENTS · 4"                       eyebrow
  Comment rows: avatar 28 · name subhead · body callout · time footnote
  Pinned composer above keyboard: avatar + field "Say something kind…" + Ember send arrow
```
Placeholder copy sets the norm — "Say something kind…" measurably reduces hostile comments.
**Empty.** "No comments yet. Be the first kind word."
**Dark.** Composer bar `surfaceAlt`, hairline top, blurred backdrop.

---

### 6.9 You / Profile

**Rationale.** The proof screen. Two numbers and a wall of evidence that you are, in fact, a person who makes things.

```
NavBar: large title "You"              trailing: ⚙︎ settings
  Avatar 80 (rPill) · Display name title1 · @handle subhead inkTertiary
  Bio callout, ≤3 lines, centred
  StatRow — three columns, hairline dividers between
     "12"  CURRENT   |  "31"  LONGEST  |  "47"  CREATIONS
     (tabular figures, display size numbers, eyebrow labels)
  WeekStrip (full month variant: 5 rows of dots)
  ── 32 ──
  "YOUR CREATIONS"                     eyebrow
  2-column masonry: images as thumbs, text as small cards showing first 3 lines
```
**Empty.** "Nothing here yet. Today's prompt is waiting." + `[Go to today]`.
**Loading.** Skeleton avatar + stat row + 4 grid tiles.
**Public profile variant.** Same minus settings/edit, plus ⋯ report/block.
**Dark.** Stat numbers in `ink`, labels `inkTertiary`, dividers `hairline`.

---

### 6.10 Settings

Grouped Cupertino list, `surface` sections on `canvas`, `rCard` corners.
```
PRACTICE     Daily reminder [9:00 AM ›]   Reminder on [switch]
APPEARANCE   Theme [System ›]
ACCOUNT      Edit profile ›   Email (read-only)
ABOUT        Privacy ›  Terms ›  Version 1.0.0 (12)
             Sign out            (Ember text, centred)
             Delete account      (danger text, centred)  → typed confirmation
```

---

## 7. Accessibility

- All touch targets ≥ 44×44pt.
- Dynamic Type to `accessibilityLarge`; hero text capped at 1.3×; every layout scroll-safe at 2× (no `Expanded` inside unbounded text rows).
- VoiceOver labels on every icon-only control; the streak pill reads "Current streak, 12 days".
- Reduce-motion collapses all transforms to cross-fades; Aurora becomes static.
- Colour is never the only signal: selected reactions get a fill *and* a weight change; the streak ring has a number.
- Emoji reactions are announced by name, not glyph.
- Minimum contrast verified on both themes; `inkTertiary` restricted to ≥13pt semibold.
