// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get myLenses => 'My lenses';

  @override
  String get putOn => 'Put on';

  @override
  String get edit => 'Edit';

  @override
  String get finish => 'Finish';

  @override
  String get finishWearing => 'Finish wearing';

  @override
  String get cancel => 'Cancel';

  @override
  String get choose => 'Select';

  @override
  String get daysUntilReplacement => 'Days until replacement';

  @override
  String get wearPeriodTitle => 'Wearing period';

  @override
  String wearPeriodDays(int days) {
    return '$days d';
  }

  @override
  String get replacementDay => 'Replacement day';

  @override
  String get replacementDayOverdue => 'Replacement day overdue';

  @override
  String semanticEditWearPeriod(int days) {
    return 'Wearing period, $days days. Tap to change';
  }

  @override
  String get replaceLens => 'Replace\nlens';

  @override
  String get replaceLenses => 'Replace\nlenses';

  @override
  String get lensesAreOn => 'Lenses are on';

  @override
  String get whenLensesOn => 'When were lenses put on';

  @override
  String get leftLensOn => 'Left lens is on';

  @override
  String get rightLensOn => 'Right lens is on';

  @override
  String get leftLensShort => 'L ∙ Left lens';

  @override
  String get rightLensShort => 'R ∙ Right lens';

  @override
  String get bothLenses => 'Both lenses';

  @override
  String get dataUpdated => 'Data updated';

  @override
  String get loadError => 'Failed to load saved data';

  @override
  String get notificationChannelName => 'Lens replacement';

  @override
  String get notificationChannelDescription =>
      'Reminder that it\'s time to replace your contact lenses';

  @override
  String get notificationTitleBoth => 'Time to replace lenses';

  @override
  String get notificationBodyBoth =>
      'Wearing period is over — put on a new pair';

  @override
  String get notificationTitleLeft => 'Time to replace the left lens';

  @override
  String get notificationBodyLeft =>
      'The left lens wearing period is over — put on a new one';

  @override
  String get notificationTitleRight => 'Time to replace the right lens';

  @override
  String get notificationBodyRight =>
      'The right lens wearing period is over — put on a new one';

  @override
  String daysOverdue(String days) {
    return '$days d';
  }

  @override
  String get semanticLeftLens => 'Left lens';

  @override
  String get semanticRightLens => 'Right lens';

  @override
  String get semanticBothLenses => 'Both lenses';

  @override
  String semanticDaysUntilReplacement(int days) {
    return '$days days until replacement';
  }

  @override
  String get semanticReplaceLens => 'Replace lens';

  @override
  String get semanticReplaceLenses => 'Replace lenses';

  @override
  String semanticLensStatus(String lens, String status) {
    return '$lens, $status';
  }

  @override
  String semanticWearPeriod(String lens, String start, String end) {
    return '$lens, put on $start, replace $end';
  }

  @override
  String semanticToggleLocale(String language) {
    return 'Switch language to $language';
  }

  @override
  String get semanticLanguageEn => 'English';

  @override
  String get semanticLanguageRu => 'Russian';
}
