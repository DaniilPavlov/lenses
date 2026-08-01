// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get myLenses => 'Мои линзы';

  @override
  String get putOn => 'Надеть';

  @override
  String get edit => 'Редактировать';

  @override
  String get finish => 'Завершить';

  @override
  String get finishWearing => 'Завершить ношение';

  @override
  String get cancel => 'Отменить';

  @override
  String get choose => 'Выбрать';

  @override
  String get daysUntilReplacement => 'Дней до замены';

  @override
  String get wearPeriodTitle => 'Срок ношения';

  @override
  String wearPeriodDays(int days) {
    return '$days д';
  }

  @override
  String get replacementDay => 'День замены';

  @override
  String get replacementDayOverdue => 'День замены просрочен';

  @override
  String semanticEditWearPeriod(int days) {
    return 'Срок ношения, $days дн. Нажмите, чтобы изменить';
  }

  @override
  String get replaceLens => 'Замените\nлинзу';

  @override
  String get replaceLenses => 'Замените\nлинзы';

  @override
  String get lensesAreOn => 'Линзы надеты';

  @override
  String get whenLensesOn => 'Когда надеты линзы';

  @override
  String get leftLensOn => 'Левая линза надета';

  @override
  String get rightLensOn => 'Правая линза надета';

  @override
  String get leftLensShort => 'L ∙ Левой линзы';

  @override
  String get rightLensShort => 'R ∙ Правой линзы';

  @override
  String get bothLenses => 'Обеих линз';

  @override
  String get dataUpdated => 'Данные обновлены';

  @override
  String get loadError => 'Не удалось загрузить сохранённые данные';

  @override
  String get notificationChannelName => 'Замена линз';

  @override
  String get notificationChannelDescription =>
      'Напоминание о том, что пора заменить контактные линзы';

  @override
  String get notificationTitleBoth => 'Пора заменить линзы';

  @override
  String get notificationBodyBoth =>
      'Срок ношения закончился — наденьте новую пару';

  @override
  String get notificationTitleLeft => 'Пора заменить левую линзу';

  @override
  String get notificationBodyLeft =>
      'Срок ношения левой линзы закончился — наденьте новую';

  @override
  String get notificationTitleRight => 'Пора заменить правую линзу';

  @override
  String get notificationBodyRight =>
      'Срок ношения правой линзы закончился — наденьте новую';

  @override
  String daysOverdue(String days) {
    return '$days д';
  }

  @override
  String get semanticLeftLens => 'Левая линза';

  @override
  String get semanticRightLens => 'Правая линза';

  @override
  String get semanticBothLenses => 'Обе линзы';

  @override
  String semanticDaysUntilReplacement(int days) {
    return '$days дн. до замены';
  }

  @override
  String get semanticReplaceLens => 'Заменить линзу';

  @override
  String get semanticReplaceLenses => 'Заменить линзы';

  @override
  String semanticLensStatus(String lens, String status) {
    return '$lens, $status';
  }

  @override
  String semanticWearPeriod(String lens, String start, String end) {
    return '$lens, надета $start, замена $end';
  }

  @override
  String semanticToggleLocale(String language) {
    return 'Переключить язык на $language';
  }

  @override
  String get semanticLanguageEn => 'английский';

  @override
  String get semanticLanguageRu => 'русский';
}
