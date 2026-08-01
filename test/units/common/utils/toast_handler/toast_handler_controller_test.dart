import 'package:flutter_test/flutter_test.dart';
import 'package:lenses/common/utils/toast_handler/controllers/toast_handler_controller/toast_handler_controller.dart';
import 'package:lenses/core/lenses/models/toast_model.dart';

void main() {
  test('handleToast appends and removeToast clears when empty', () {
    final controller = ToastHandlerController();
    final toast = ToastModel(isError: false, message: 'ok');

    controller.handleToast(toast);
    expect(controller.toasts, hasLength(1));

    controller.handleToast(ToastModel(isError: true, message: 'err'));
    expect(controller.toasts, hasLength(2));

    controller.removeToast();
    expect(controller.toasts, hasLength(2));

    controller.removeToast();
    expect(controller.toasts, isEmpty);
  });
}
