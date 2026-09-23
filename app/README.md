# Dabble — iOS app

Flutter · Cupertino · Riverpod · GoRouter · Freezed.

## Bootstrap

This repo contains `lib/`, `pubspec.yaml` and the design system. The native iOS
project is generated (it is machine-specific and shouldn't be hand-written):

```bash
cd app                                                     # ← from app/, not backend/
flutter create --platforms=ios --org app.dabble --project-name dabble .
flutter pub get
dart run build_runner build                                # required: Freezed models
xcrun simctl boot "iPhone 17" && open -a Simulator
flutter run --dart-define=DABBLE_API_BASE=http://localhost:8000/api/v1
```

`flutter create` in an existing directory only adds the missing platform folders —
it will not overwrite `lib/` or `pubspec.yaml`. Run it from `app/`; run it from the
repo root or `backend/` and you'll scatter a stray Flutter project there.

> The app will not compile until `build_runner` has generated
> `lib/domain/models.freezed.dart` and `models.g.dart`.

### Known setup failures

| Symptom | Cause / fix |
|---|---|
| `Missing implementation of visitDotShorthandPropertyAccess` | The analyzer pulled in by `freezed` is older than your Dart SDK. `flutter pub upgrade --major-versions freezed freezed_annotation json_serializable json_annotation build_runner flutter_lints`. Freezed 3+ needs `@freezed abstract class X with _$X`. |
| `library load disallowed by system policy` → `Generating AOT kernel dill failed!` | macOS quarantined a browser-downloaded Flutter SDK. `xattr -dr com.apple.quarantine "$(dirname $(dirname $(which flutter)))"` |
| `No supported devices connected` | No simulator booted. `xcrun simctl list devices available`, then `xcrun simctl boot <udid>`. |

### Xcode capabilities to enable
- **Sign in with Apple** (required — we also offer email login). Email sign-in works
  without it, so this can wait for a paid developer account.
- Camera and Photo Library usage strings are already in `ios/Runner/Info.plist`.

## Architecture

```
lib/
  main.dart            ProviderScope → DabbleTheme → CupertinoApp.router
  app/                 theme, router
  core/                env, dio client, keychain token store, auth interceptor
  design/tokens/       colors · typography · spacing · shadows · motion
  design/components/   the whole component library
  domain/              Freezed models + enums (pure Dart)
  data/                repositories (the only things that talk to ApiClient)
  features/            auth · today · compose · feed · profile · shell
```

Rules that keep this from rotting:

1. A screen never imports `ApiClient`. It talks to a controller.
2. A repository never imports Flutter.
3. `domain/` imports nothing from the layers above it.
4. **Never import `package:flutter/material.dart`.** That import is how Material
   Design gets into an app that isn't supposed to look like one. Use
   `package:flutter/cupertino.dart` or `widgets.dart`.

## The design system in one paragraph

Warm paper (`#FBF8F4`) or warm ink (`#0D0C0B`), never pure white or black. One
accent — Ember `#DC5B34` — and exactly one Ember-filled control visible at a time.
San Francisco at six sizes. 4pt spacing, continuous corners, two-layer warm
shadows in light mode and hairline borders in dark. Everything eases out; nothing
overshoots except The Spark. Full spec in [../docs/02-design-system.md](../docs/02-design-system.md).

## Tests worth writing first

- Golden tests of `TodayScreen` in light and dark at default and `accessibilityLarge`
- `WeekStrip` dot states across a week boundary
- `AuthInterceptor`: three concurrent 401s trigger exactly one refresh
- `ComposeController`: autosave debounce, and that an upload failure never clears the body
