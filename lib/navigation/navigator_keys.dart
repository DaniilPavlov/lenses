import 'package:flutter/material.dart';
import 'package:lenses/utils/logger.dart';

/// Фасад поверх глобального ключа [GlobalKey], необходим для доступа к состояниям навигации
/// и упрощенного контроля над ней
@immutable
class NavigatorKeyFacade {
  const NavigatorKeyFacade(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  void pop() => navigatorKey.currentState!.pop();

  Future<T?> push<T extends Object?>(Route<T> route) => navigatorKey.currentState!.push(route);

  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) =>
      navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);

  void popUntil(RoutePredicate predicate) {
    if (navigatorKey.currentState == null) logger.w('$navigatorKey state - null');
    navigatorKey.currentState?.popUntil(predicate);
  }

  BuildContext? get currentContext => navigatorKey.currentContext;

  NavigatorState? get currentState => navigatorKey.currentState;

  Widget? get currentWidget => navigatorKey.currentWidget;
}

/// Декоратор над корневым состоянием навигации
class RootNavigatorKey extends NavigatorKeyFacade {
  const RootNavigatorKey(super.navigatorKey);
}
