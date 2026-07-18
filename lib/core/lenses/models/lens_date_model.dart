part of 'generated/generated.dart';

/// Дата начала/окончания ношения одной линзы и оставшиеся дни.
@JsonSerializable()
class LensDateModel {
  LensDateModel({required this.dateStart, required this.dateEnd, required this.daysLeft});

  factory LensDateModel.fromJson(Map<String, dynamic> json) => _$LensDateModelFromJson(json);

  /// День, когда линза была надета.
  final DateTime dateStart;

  /// День плановой замены.
  final DateTime dateEnd;

  /// Сколько дней осталось до замены (может быть отрицательным при просрочке).
  final int daysLeft;

  Map<String, dynamic> toJson() => _$LensDateModelToJson(this);
}
