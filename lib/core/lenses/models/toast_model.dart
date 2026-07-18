/// Данные toast-сообщения для [ToastHandlerWidget].
class ToastModel {
  ToastModel({
    required this.isError,
    required this.message,
  });

  /// `true` — ошибка (красный), иначе успех (зелёный).
  final bool isError;

  /// Текст уведомления.
  final String message;
}
