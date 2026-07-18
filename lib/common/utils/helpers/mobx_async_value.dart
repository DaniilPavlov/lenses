import 'package:flutter/material.dart';

/// Обёртка статуса асинхронного значения для MobX-полей.
@immutable
class AsyncValue<T> {
  const AsyncValue({required this.status, this.value, this.error});

  const AsyncValue.loading({this.value, this.error}) : status = AsyncStatus.loading;

  const AsyncValue.value({this.value, this.error}) : status = AsyncStatus.value;

  const AsyncValue.error({this.value, this.error}) : status = AsyncStatus.error;

  final AsyncStatus status;
  final T? value;
  final AsyncError? error;

  bool get isLoading => status == AsyncStatus.loading;

  bool get isValue => status == AsyncStatus.value;

  bool get isError => status == AsyncStatus.error;

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

/// Статусы [AsyncValue].
enum AsyncStatus { loading, error, value }

/// Ошибка для [AsyncValue.error].
@immutable
class AsyncError {
  const AsyncError({required this.errorMessage});

  /// Пользовательское или техническое сообщение об ошибке.
  final String errorMessage;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AsyncError && runtimeType == other.runtimeType && errorMessage == other.errorMessage;

  @override
  int get hashCode => errorMessage.hashCode;

  @override
  String toString() {
    return 'AsyncError{errorMessage: $errorMessage}';
  }
}
