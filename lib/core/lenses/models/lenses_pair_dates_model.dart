part of 'generated/generated.dart';

/// Пара дат ношения левой и правой линзы.
@immutable
@JsonSerializable(explicitToJson: true)
class LensesPairDatesModel {
  const LensesPairDatesModel({this.left, this.right});

  factory LensesPairDatesModel.fromJson(Map<String, dynamic> json) => _$LensesPairDatesModelFromJson(json);

  /// Левая линза или `null`, если не надета.
  final LensDateModel? left;

  /// Правая линза или `null`, если не надета.
  final LensDateModel? right;

  /// Нет ни одной надетой линзы.
  bool get isEmpty => left == null && right == null;

  /// Надеты обе линзы.
  bool get hasBoth => left != null && right != null;

  Map<String, dynamic> toJson() => _$LensesPairDatesModelToJson(this);
}
