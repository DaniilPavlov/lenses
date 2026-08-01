# Lenses

Flutter app for tracking contact lens wear periods  
(put on, days until replacement, take off, and reminders).

Data is stored locally via SharedPreferences.

## Stack

| Layer | Tech |
|------|------------|
| UI | Flutter, Material |
| State | MobX + Provider |
| DI | GetIt |
| Storage | SharedPreferences |
| Codegen | json_serializable, mobx_codegen, flutter_gen |
| Localization | flutter_localizations, intl (ARB) |
| Tests | unit + widget (`test/units/`, `test/widget/`, shared `test/helpers/`) |

## Architecture

- **DI** — GetIt in `lib/services/di_register.dart` (`SharedPreferences`, navigator key, reminder service).
- **State** — `LensesController` (MobX) owns wear dates; UI observes via `Observer`.
- **Persistence** — `LensesDatesLoader` reads/writes JSON in SharedPreferences.
- **Locale** — `LocaleController` (MobX) + ARB (`lib/l10n/`); RU/EN switch without restart.
- **Reminders** — `LensReplacementReminderService` schedules one local notification at 09:00 on the nearest replacement day.
- **Home widget** — `LensHomeWidgetService` syncs days-until-replacement to Android/iOS home-screen widgets via `home_widget`.
- **Codegen** — after MobX / json / assets changes: `dart run build_runner build --delete-conflicting-outputs`. Do not hand-edit `*.g.dart` / flutter_gen output.
- **Scope** — minimal diffs; match `lib/core/`, `lib/common/`, `lib/services/`. No new layers unless asked.

## Structure

```
lenses/
├── lib/
│   ├── common/      # widgets, theme, utils, localization, toast
│   ├── core/        # lenses feature: controllers, models, screens, sheets
│   ├── services/    # DI, local notifications, home widget sync
│   ├── l10n/        # ARB + generated localizations
│   ├── assets_gen/  # FlutterGen (icons, fonts)
│   ├── app.dart
│   └── main.dart
├── test/
│   ├── helpers/
│   ├── mobx/
│   └── units/       # mirrors lib/
├── assets/
├── android/         # includes AppWidget (LensesDaysWidgetReceiver)
├── ios/             # Runner + LensesDaysWidget (WidgetKit)
└── .github/workflows/
```

## Requirements

- Flutter **≥3.38** (CI: **3.44.8**), Dart **≥3.10**, Java **21**

## Run

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter run
```

## CI / CD

[![CI](https://github.com/DaniilPavlov/lenses/actions/workflows/ci.yml/badge.svg)](https://github.com/DaniilPavlov/lenses/actions/workflows/ci.yml)

| Workflow | When | What |
|----------|------|------|
| `ci.yml` | push / PR → `master` | codegen check, analyze, test, coverage gate (≥75%) |
| `release.yml` | tag `v*` or manual | Android APK (+ GitHub Release) |

```bash
flutter test --coverage
dart run tool/ci/check_coverage.dart   # same gate as CI; raise --min as coverage grows
```

```bash
flutter analyze && flutter test
```

```bash
# bump pubspec `version: name+code` (code must increase), then:
git tag v1.2.0 && git push origin v1.2.0
```

Release secrets (required): `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`.

```bash
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
base64 -i upload-keystore.jks | pbcopy   # → ANDROID_KEYSTORE_BASE64
```

## Features

- **Home** — days-until-replacement indicator for one or both lenses (L / R)
- **Put on** — set wear start date for one or both lenses
- **Different dates** — separate schedule for left and right
- **Edit / finish** — change date or take off one/both lenses
- **Wear period** — configurable (default 14 days), shared by both lenses; change from the app bar
- **Localization** — Russian and English; RU/EN toggle in AppBar without restart
- **Reminder** — one local notification at 09:00 on the nearest replacement day; copy differs for left, right, or both
- **Home screen widget** — days until replacement (one number if dates match, otherwise L / R), Android + iOS

## Home screen widget

Shows the same countdown as the main screen. Data is written by Flutter (`LensHomeWidgetService`) whenever wear dates or locale change; native widgets recalculate days from stored `dateEnd` (including overnight).

**Android:** long-press home screen → Widgets → Lenses → Days until replacement.

**iOS:** long-press home screen → Edit → Add Widget → Lenses. Requires a paid Apple Developer account and App Group `group.com.example.lenses` enabled for both the Runner app and the `LensesDaysWidget` extension (Signing & Capabilities in Xcode). Entitlement files are already in the repo.
