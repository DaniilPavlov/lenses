import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:lenses/common/utils/constants/navigator_keys.dart';
import 'package:lenses/services/di_register.dart';
import 'package:lenses/services/notifications/lens_replacement_reminder_service.dart';
import 'package:lenses/services/widgets/lens_home_widget_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    await GetIt.I.reset();
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() async {
    await GetIt.I.reset();
  });

  test('diRegisters registers core singletons', () async {
    await diRegisters();
    expect(GetIt.I.isRegistered<SharedPreferences>(), isTrue);
    expect(GetIt.I.isRegistered<RootNavigatorKey>(), isTrue);
    expect(GetIt.I.isRegistered<LensReplacementReminderService>(), isTrue);
    expect(GetIt.I.isRegistered<LensHomeWidgetService>(), isTrue);

    await diRegisters();
    expect(GetIt.I.isRegistered<RootNavigatorKey>(), isTrue);
  });
}
