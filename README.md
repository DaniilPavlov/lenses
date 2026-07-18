# Lenses

Flutter-приложение для учёта срока ношения контактных линз  
(надевание, отслеживание дней до замены, снятие и напоминания).

Данные хранятся локально через SharedPreferences.

## Стек

| Слой | Технологии |
|------|------------|
| UI | Flutter, Material |
| State | MobX + Provider |
| DI | GetIt |
| Хранение | SharedPreferences |
| Codegen | json_serializable, mobx_codegen, flutter_gen |
| Локализация | flutter_localizations, intl (ARB) |
| Уведомления | flutter_local_notifications, timezone |

## Структура

```
lenses/
├── lib/
│   ├── common/      # виджеты, тема, utils, localization, toast
│   ├── core/        # фича lenses: controllers, models, screens, sheets
│   ├── services/    # DI, локальные уведомления
│   ├── l10n/        # ARB и сгенерированные локализации
│   ├── assets_gen/  # FlutterGen (иконки, шрифты)
│   ├── app.dart
│   └── main.dart
├── test/
├── android/
├── ios/
└── .github/workflows/
```

## Требования

- Flutter **3.35.3+**
- Dart **3.8+**

## Запуск

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter run
```

## Тесты и анализ

```bash
flutter analyze
flutter test
```

## CI / CD

[![CI](https://github.com/DaniilPavlov/lenses/actions/workflows/ci.yml/badge.svg)](https://github.com/DaniilPavlov/lenses/actions/workflows/ci.yml)

| Workflow | Когда | Что делает |
|----------|-------|------------|
| `ci.yml` | push / PR в `main` | codegen check, analyze, test |
| `release.yml` | тег `v*` или вручную | Android APK (+ GitHub Release) |

Релиз:

```bash
# версия в pubspec.yaml должна совпадать с тегом
git tag v1.1.0
git push origin v1.1.0
```

Для release-подписи APK (опционально) — secrets `ANDROID_KEYSTORE_*` в GitHub Actions.

## Возможности

- **Главный экран** — индикатор дней до замены для одной или обеих линз (L / R)  
- **Надеть** — выбор даты надевания для одной или обеих линз  
- **Разные даты** — отдельный срок для левой и правой линзы  
- **Редактировать / завершить** — смена даты или снятие одной/обеих линз  
- **Срок ношения** — 14 дней с даты надевания, отображение просрочки  
- **Локализация** — русский и английский, переключатель RU/EN в AppBar без перезапуска  
- **Напоминание** — одно локальное уведомление в 09:00 в день ближайшей замены; текст различает левую, правую или обе линзы
