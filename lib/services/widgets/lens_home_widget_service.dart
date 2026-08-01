import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:lenses/core/lenses/models/generated/generated.dart';
import 'package:lenses/l10n/app_localizations.dart';
import 'package:lenses/services/widgets/lens_home_widget_payload.dart';

/// Синхронизация дат линз с Android/iOS home-screen виджетами через [HomeWidget].
class LensHomeWidgetService {
  /// Задаёт App Group для обмена данными с iOS WidgetKit.
  Future<void> init() async {
    await HomeWidget.setAppGroupId(LensHomeWidgetPayload.appGroupId);
  }

  /// Пишет payload и просит ОС перерисовать виджет.
  Future<void> sync(LensesPairDatesModel? pairDates, {required Locale locale}) async {
    try {
      final l10n = await AppLocalizations.delegate.load(locale);
      final payload = LensHomeWidgetPayload.fromPairDates(pairDates, l10n: l10n, locale: locale);
      for (final entry in payload.toStorageMap().entries) {
        await HomeWidget.saveWidgetData<String>(entry.key, entry.value);
      }
      await HomeWidget.updateWidget(
        name: LensHomeWidgetPayload.androidReceiverName,
        iOSName: LensHomeWidgetPayload.iosWidgetName,
        qualifiedAndroidName: 'com.example.lenses.${LensHomeWidgetPayload.androidReceiverName}',
      );
    } on Object catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('LensHomeWidgetService.sync failed: $error\n$stackTrace');
      }
    }
  }
}
