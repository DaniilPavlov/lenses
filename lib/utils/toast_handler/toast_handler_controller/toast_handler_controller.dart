import 'package:lenses/models/toast_model.dart';
import 'package:mobx/mobx.dart';


part 'toast_handler_controller.g.dart';

// ignore: library_private_types_in_public_api
class ToastHandlerController = _ToastHandlerControllerBase with _$ToastHandlerController;

/// Контроллер управления состояний тоастов в приложении
abstract class _ToastHandlerControllerBase with Store {
  @observable
  List<ToastModel> _toasts = [];

  int _toastsOnTheScreen = 0;

  List<ToastModel> get toasts => _toasts;

  @action
  void handleToast(ToastModel toast) {
    ++_toastsOnTheScreen;
    final newToasts = [..._toasts];
    newToasts.add(toast);
    _toasts = newToasts;
  }

  @action
  void removeToast() {
    --_toastsOnTheScreen;
    if (_toastsOnTheScreen == 0) {
      _toasts = List.empty(growable: true);
    }
  }
}
