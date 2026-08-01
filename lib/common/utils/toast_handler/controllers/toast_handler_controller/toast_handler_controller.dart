import 'package:lenses/core/lenses/models/toast_model.dart';
import 'package:mobx/mobx.dart';

part 'toast_handler_controller.g.dart';

class ToastHandlerController = ToastHandlerControllerBase with _$ToastHandlerController;

/// Контроллер очереди toast-уведомлений на экране.
abstract class ToastHandlerControllerBase with Store {
  @observable
  List<ToastModel> _toasts = [];

  int _toastsOnTheScreen = 0;

  /// Текущий список toast'ов для отображения.
  @computed
  List<ToastModel> get toasts => _toasts;

  /// Добавляет toast в очередь.
  @action
  void handleToast(ToastModel toast) {
    ++_toastsOnTheScreen;
    final newToasts = [..._toasts, toast];
    _toasts = newToasts;
  }

  /// Убирает toast после анимации; очищает список, когда все скрыты.
  @action
  void removeToast() {
    --_toastsOnTheScreen;
    if (_toastsOnTheScreen == 0) {
      _toasts = List.empty(growable: true);
    }
  }
}
