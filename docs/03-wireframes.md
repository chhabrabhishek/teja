# Dabble — Wireframes

ASCII wireframes at iPhone 15 Pro scale (393 × 852 pt). `░` = skeleton/blur, `▓` = Ember fill.

---

## Welcome

```
┌───────────────────────────────┐
│                               │
│         ╭─ soft aurora ─╮     │
│                               │
│                               │
│  Dabble                         │  title1
│                               │
│  One prompt a day.            │  displayXL
│  Make something small.        │
│                               │
│  Then see what the world      │  callout, inkSecondary
│  made from the same spark.    │
│                               │
│                               │
│                               │
│  ┌─────────────────────────┐  │
│  │   Sign in with Apple    │  │  native, 54h
│  └─────────────────────────┘  │
│  ┌─────────────────────────┐  │
│  │   Continue with email   │  │  secondary, 54h
│  └─────────────────────────┘  │
│                               │
│   Terms · Privacy             │  footnote
└───────────────────────────────┘
```

## Code verify

```
┌───────────────────────────────┐
│ ‹ Back                        │
│                               │
│  Check your email             │  title1
│  Code sent to hi@dabble.app     │  callout  [Change]
│                               │
│  ┌──┐┌──┐┌──┐┌──┐┌──┐┌──┐     │  6 boxes, 48×56, rControl
│  │ 4││ 8││ 1││  ││  ││  │     │  focused box: Ember border
│  └──┘└──┘└──┘└──┘└──┘└──┘     │
│                               │
│  Resend in 0:42               │  footnote inkTertiary
│                               │
│ ╌╌╌╌╌╌╌ keyboard ╌╌╌╌╌╌╌╌╌╌╌ │
└───────────────────────────────┘
```

## Today — not yet created  ★ hero screen

```
┌───────────────────────────────┐
│  ╭─ aurora blobs, 7% ─────╮   │
│  Today            ╭──────╮    │  large title  + streak pill
│                   │ ● 12 │    │
│                   ╰──────╯    │
│  TUESDAY · 16 SEPTEMBER       │  eyebrow inkTertiary
│                               │
│ ┌───────────────────────────┐ │
│ │ ╭─────────────────╮       │ │  PromptHeroCard, rHero
│ │ │ CREATIVE WRITING│       │ │  CategoryChip (slate 12%)
│ │ ╰─────────────────╯       │ │
│ │                           │ │
│ │ Write the last text       │ │  displayXL, ink
│ │ message someone sent      │ │
│ │ before the world          │ │
│ │ changed.                  │ │
│ │                           │ │
│ │ Five minutes is enough.   │ │  callout inkSecondary
│ │ · 6h 12m left today       │ │  footnote inkTertiary
│ └───────────────────────────┘ │
│                               │
│ ┌───────────────────────────┐ │
│ │▓▓▓▓  Start creating  ▓▓▓▓▓│ │  ← only Ember fill on screen
│ └───────────────────────────┘ │
│                               │
│     ● ● ● ● ○ ◌ ◌             │  WeekStrip
│                               │
│  ╭───────────────────────╮    │
│  │ ░░  ░░  ░░            │    │  blurred thumbs
│  │ 1,204 people created  │    │
│  │ Publish to unlock     │    │
│  ╰───────────────────────╯    │
├───────────────────────────────┤
│   Today     Feed        You   │  CupertinoTabBar
└───────────────────────────────┘
```

## Today — published

```
│ ┌───────────────────────────┐ │
│ │ ✓ You created today       │ │  success ink
│ │ ┌────┐  "Write the last…" │ │  thumbnail 44 + excerpt
│ │ └────┘  💛 4   💬 1       │ │
│ └───────────────────────────┘ │
│ ┌───────────────────────────┐ │
│ │   See what others made    │ │  secondary (not Ember)
│ └───────────────────────────┘ │
```

## Compose — text

```
┌───────────────────────────────┐
│          ▁▁▁▁▁▁               │  drag handle
│ Cancel   Draft · saved  Publish│
├───────────────────────────────┤
│ Write the last text message    │  subhead inkSecondary, 2-line clamp
│ someone sent before the…       │
│───────────────────────────────│
│                               │
│ The sky went the colour of    │  body, 17/27
│ an old photograph and she     │
│ wrote: "did you eat"          │
│ ▏                             │  Ember caret
│                               │
│                               │
│                               │
├───────────────────────────────┤
│  **  _  #  •  ”   Preview  47w│  keyboard toolbar
│ ╌╌╌╌╌╌╌ keyboard ╌╌╌╌╌╌╌╌╌╌╌ │
└───────────────────────────────┘
```

## Compose — image

```
│ Cancel   Draft · saved  Publish│
│ Photograph something that…     │
│───────────────────────────────│
│  ┌─────────────────────────┐  │
│  │                         │  │  4:5 tile, rImage
│  │      ＋ Add a photo      │  │  dashed hairline when empty
│  │   Camera or Library     │  │
│  └─────────────────────────┘  │
│                               │
│  Add a caption (optional)     │  body placeholder
└───────────────────────────────┘
```

## The Spark

```
┌───────────────────────────────┐
│ ╭── ember→glow radial 18% ──╮ │
│                               │
│           ( glow )            │  radial burst, scales out
│                               │
│            DAY                │  eyebrow
│                               │
│            12                 │  72pt, tabular, counts 11→12
│                               │
│   You made something today.   │  title2
│                               │
│      ● ● ● ● ● ◌ ◌            │  new dot fills last
│                               │
│ ┌───────────────────────────┐ │
│ │▓▓▓ See what others made ▓▓│ │
│ └───────────────────────────┘ │
│        Back to Today          │  quiet
└───────────────────────────────┘
```

## Feed — locked

```
┌───────────────────────────────┐
│  Today's Feed                 │
│ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │  real cards, blur 20 @55%
│ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │
│   ╭───────────────────────╮   │
│   │          🔒           │   │
│   │    Create to unlock   │   │  title2
│   │  See what 1,204 people│   │  callout
│   │  made from today's    │   │
│   │  prompt.              │   │
│   │ ┌───────────────────┐ │   │
│   │ │▓ Start creating  ▓│ │   │
│   │ └───────────────────┘ │   │
│   ╰───────────────────────╯   │
│ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │
└───────────────────────────────┘
```

## Feed — unlocked

```
┌───────────────────────────────┐
│  Today's Feed              ⓘ  │
│ CREATIVE WRITING · Write the… │  sticky recap strip, 44h
│───────────────────────────────│
│ ┌───────────────────────────┐ │
│ │ ◯ Maya  · 12m       [You] │ │
│ │                           │ │
│ │ The sky went the colour   │ │  6-line clamp + fade mask
│ │ of an old photograph…     │ │
│ │                           │ │
│ │ 💛 4  🔥 2  😂  🤯  🫶   💬 1│ │
│ └───────────────────────────┘ │
│ ┌───────────────────────────┐ │
│ │ ◯ Dev   · 34m             │ │
│ │ ┌───────────────────────┐ │ │
│ │ │       image 4:5       │ │ │
│ │ └───────────────────────┘ │ │
│ │ 💛 11  🔥 3   🫶 2    💬 4│ │
│ └───────────────────────────┘ │
│                               │
│   That's everyone so far.     │  footnote, centred
└───────────────────────────────┘
```

## Submission detail

```
┌───────────────────────────────┐
│ ‹      Maya Iyer           ⋯  │
│                               │
│ ◯  Maya Iyer   · 2h    Day 12 │
│                               │
│ The sky went the colour of an │  body, 68ch measure
│ old photograph and she wrote  │
│ "did you eat" because that is │
│ what love sounds like when    │
│ there is no time left.        │
│                               │
│  💛 4   🔥 2   😂   🤯   🫶   │  44h taps
│───────────────────────────────│
│ COMMENTS · 4                  │  eyebrow
│ ◦ Dev    this wrecked me   2h │
│ ◦ Aarti  the last line     1h │
├───────────────────────────────┤
│ ◯ │ Say something kind…   │ → │  pinned composer
└───────────────────────────────┘
```

## You

```
┌───────────────────────────────┐
│  You                       ⚙︎ │
│                               │
│            ◯ 80pt             │
│         Maya Iyer             │  title1
│           @maya               │  subhead inkTertiary
│   Writing badly, daily.       │  callout, centred
│                               │
│   12     │    31    │    47   │  display, tabular
│ CURRENT  │ LONGEST  │ MADE    │  eyebrow inkTertiary
│                               │
│  ● ● ● ● ● ● ●                │  month dot grid
│  ● ● ○ ● ● ● ●                │
│  ● ● ● ● ◌ ◌ ◌                │
│                               │
│  YOUR CREATIONS               │  eyebrow
│ ┌──────────┐ ┌──────────┐     │  2-col masonry
│ │  image   │ │ The sky  │     │
│ │          │ │ went the │     │
│ └──────────┘ │ colour…  │     │
│ ┌──────────┐ └──────────┘     │
└───────────────────────────────┘
```
