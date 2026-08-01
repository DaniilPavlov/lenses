import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @myLenses.
  ///
  /// In ru, this message translates to:
  /// **'Мои линзы'**
  String get myLenses;

  /// No description provided for @putOn.
  ///
  /// In ru, this message translates to:
  /// **'Надеть'**
  String get putOn;

  /// No description provided for @edit.
  ///
  /// In ru, this message translates to:
  /// **'Редактировать'**
  String get edit;

  /// No description provided for @finish.
  ///
  /// In ru, this message translates to:
  /// **'Завершить'**
  String get finish;

  /// No description provided for @finishWearing.
  ///
  /// In ru, this message translates to:
  /// **'Завершить ношение'**
  String get finishWearing;

  /// No description provided for @cancel.
  ///
  /// In ru, this message translates to:
  /// **'Отменить'**
  String get cancel;

  /// No description provided for @choose.
  ///
  /// In ru, this message translates to:
  /// **'Выбрать'**
  String get choose;

  /// No description provided for @daysUntilReplacement.
  ///
  /// In ru, this message translates to:
  /// **'Дней до замены'**
  String get daysUntilReplacement;

  /// No description provided for @replacementDay.
  ///
  /// In ru, this message translates to:
  /// **'День замены'**
  String get replacementDay;

  /// No description provided for @replacementDayOverdue.
  ///
  /// In ru, this message translates to:
  /// **'День замены просрочен'**
  String get replacementDayOverdue;

  /// No description provided for @replaceLens.
  ///
  /// In ru, this message translates to:
  /// **'Замените\nлинзу'**
  String get replaceLens;

  /// No description provided for @replaceLenses.
  ///
  /// In ru, this message translates to:
  /// **'Замените\nлинзы'**
  String get replaceLenses;

  /// No description provided for @lensesAreOn.
  ///
  /// In ru, this message translates to:
  /// **'Линзы надеты'**
  String get lensesAreOn;

  /// No description provided for @whenLensesOn.
  ///
  /// In ru, this message translates to:
  /// **'Когда надеты линзы'**
  String get whenLensesOn;

  /// No description provided for @leftLensOn.
  ///
  /// In ru, this message translates to:
  /// **'Левая линза надета'**
  String get leftLensOn;

  /// No description provided for @rightLensOn.
  ///
  /// In ru, this message translates to:
  /// **'Правая линза надета'**
  String get rightLensOn;

  /// No description provided for @leftLensShort.
  ///
  /// In ru, this message translates to:
  /// **'L ∙ Левой линзы'**
  String get leftLensShort;

  /// No description provided for @rightLensShort.
  ///
  /// In ru, this message translates to:
  /// **'R ∙ Правой линзы'**
  String get rightLensShort;

  /// No description provided for @bothLenses.
  ///
  /// In ru, this message translates to:
  /// **'Обеих линз'**
  String get bothLenses;

  /// No description provided for @dataUpdated.
  ///
  /// In ru, this message translates to:
  /// **'Данные обновлены'**
  String get dataUpdated;

  /// No description provided for @loadError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить сохранённые данные'**
  String get loadError;

  /// No description provided for @notificationChannelName.
  ///
  /// In ru, this message translates to:
  /// **'Замена линз'**
  String get notificationChannelName;

  /// No description provided for @notificationChannelDescription.
  ///
  /// In ru, this message translates to:
  /// **'Напоминание о том, что пора заменить контактные линзы'**
  String get notificationChannelDescription;

  /// No description provided for @notificationTitleBoth.
  ///
  /// In ru, this message translates to:
  /// **'Пора заменить линзы'**
  String get notificationTitleBoth;

  /// No description provided for @notificationBodyBoth.
  ///
  /// In ru, this message translates to:
  /// **'Срок ношения закончился — наденьте новую пару'**
  String get notificationBodyBoth;

  /// No description provided for @notificationTitleLeft.
  ///
  /// In ru, this message translates to:
  /// **'Пора заменить левую линзу'**
  String get notificationTitleLeft;

  /// No description provided for @notificationBodyLeft.
  ///
  /// In ru, this message translates to:
  /// **'Срок ношения левой линзы закончился — наденьте новую'**
  String get notificationBodyLeft;

  /// No description provided for @notificationTitleRight.
  ///
  /// In ru, this message translates to:
  /// **'Пора заменить правую линзу'**
  String get notificationTitleRight;

  /// No description provided for @notificationBodyRight.
  ///
  /// In ru, this message translates to:
  /// **'Срок ношения правой линзы закончился — наденьте новую'**
  String get notificationBodyRight;

  /// No description provided for @daysOverdue.
  ///
  /// In ru, this message translates to:
  /// **'{days} д'**
  String daysOverdue(String days);

  /// No description provided for @semanticLeftLens.
  ///
  /// In ru, this message translates to:
  /// **'Левая линза'**
  String get semanticLeftLens;

  /// No description provided for @semanticRightLens.
  ///
  /// In ru, this message translates to:
  /// **'Правая линза'**
  String get semanticRightLens;

  /// No description provided for @semanticBothLenses.
  ///
  /// In ru, this message translates to:
  /// **'Обе линзы'**
  String get semanticBothLenses;

  /// No description provided for @semanticDaysUntilReplacement.
  ///
  /// In ru, this message translates to:
  /// **'{days} дн. до замены'**
  String semanticDaysUntilReplacement(int days);

  /// No description provided for @semanticReplaceLens.
  ///
  /// In ru, this message translates to:
  /// **'Заменить линзу'**
  String get semanticReplaceLens;

  /// No description provided for @semanticReplaceLenses.
  ///
  /// In ru, this message translates to:
  /// **'Заменить линзы'**
  String get semanticReplaceLenses;

  /// No description provided for @semanticLensStatus.
  ///
  /// In ru, this message translates to:
  /// **'{lens}, {status}'**
  String semanticLensStatus(String lens, String status);

  /// No description provided for @semanticWearPeriod.
  ///
  /// In ru, this message translates to:
  /// **'{lens}, надета {start}, замена {end}'**
  String semanticWearPeriod(String lens, String start, String end);

  /// No description provided for @semanticToggleLocale.
  ///
  /// In ru, this message translates to:
  /// **'Переключить язык на {language}'**
  String semanticToggleLocale(String language);

  /// No description provided for @semanticLanguageEn.
  ///
  /// In ru, this message translates to:
  /// **'английский'**
  String get semanticLanguageEn;

  /// No description provided for @semanticLanguageRu.
  ///
  /// In ru, this message translates to:
  /// **'русский'**
  String get semanticLanguageRu;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
