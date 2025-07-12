import 'package:flutter/foundation.dart';

/// Класс обертка для взаимодействия с API через mobx
@immutable
class AsyncValue<T> {
  const AsyncValue({
    required this.status,
    this.value,
    this.error,
  });

  const AsyncValue.loading({
    this.value,
    this.error,
  }) : status = AsyncStatus.loading;

  const AsyncValue.value({
    this.value,
    this.error,
  }) : status = AsyncStatus.value;

  const AsyncValue.error({
    this.value,
    this.error,
  }) : status = AsyncStatus.error;

  final AsyncStatus status;
  final T? value;
  final AsyncError? error;

  bool get isLoading => status == AsyncStatus.loading;

  bool get isValue => status == AsyncStatus.value;

  bool get isError => status == AsyncStatus.error;

  /// Метод для получения данных в зависимости от текущего статуса [status] асинхронной переменной.
  /// Самое оптимальное применение - генерация виджета.
  ///
  /// ```dart
  /// asyncValue.map(
  ///   value: (value) => Text('Loaded Value - ${value.value}'),
  ///   error: (error) => Text('Error - ${error.error?.errorMessage}'),
  ///   loading: (_) => const Center(child: AppCircularLoader()),
  /// );
  /// ```
  R map<R>({
    required R Function(AsyncValue<T> value) value,
    required R Function(AsyncValue<T> error) error,
    required R Function(AsyncValue<T> loading) loading,
  }) {
    switch (status) {
      case AsyncStatus.value:
        return value(this);
      case AsyncStatus.loading:
        return loading(this);
      case AsyncStatus.error:
        return error(this);
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AsyncValue &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          value == other.value &&
          error == other.error;

  @override
  int get hashCode => Object.hashAll([status, value, error]);

  @override
  String toString() {
    return 'AsyncValue{status: $status, value: $value, error: $error}';
  }
}

/// Перечень статусов для класса [AsyncValue]
enum AsyncStatus {
  loading,
  error,
  value,
}

/// Класс с ошибкой для [AsyncValue]
@immutable
class AsyncError {
  const AsyncError({
    required this.errorMessage,
    this.errorObject,
  });

  /// Текст ошибки
  final String errorMessage;

  /// Дополнительный объект, может быть чем угодно, в том числе исключением
  final Object? errorObject;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AsyncError &&
          runtimeType == other.runtimeType &&
          errorMessage == other.errorMessage &&
          errorObject == other.errorObject;

  @override
  int get hashCode => Object.hashAll([errorMessage, errorObject]);

  @override
  String toString() {
    return 'AsyncError{errorMessage: $errorMessage, errorObject: $errorObject}';
  }
}
