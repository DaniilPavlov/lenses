import 'package:get_it/get_it.dart';
import 'package:lenses/utils/logger.dart';

extension GetItExtension on GetIt {
  /// Если объект типа [T] зарегистрирован в GetIt, то возвращает его,
  /// если нет, то отдает null.
  /// Метод полезен для более развязанного кода в ситуациях, когда DI может быть нам и не нужен
  T? getOrNull<T extends Object>({
    String? instanceName,
    dynamic param1,
    dynamic param2,
  }) {
    if (!isRegistered<T>()) {
      logger.w('$T - object not registered');
      return null;
    }
    return call<T>(instanceName: instanceName, param1: param1, param2: param2);
  }

  /// Регистрация объекта если он еще не зарегистрирован, в противном случае ничего не происходит
  void tryRegisterSingleton<T extends Object>(
    T instance, {
    String? instanceName,
    bool? signalsReady,
    DisposingFunc<T>? dispose,
  }) {
    if (isRegistered<T>()) {
      logger.i('$T - object already registered');
      return;
    }
    registerSingleton(
      instance,
      instanceName: instanceName,
      signalsReady: signalsReady,
      dispose: dispose,
    );
  }
}
