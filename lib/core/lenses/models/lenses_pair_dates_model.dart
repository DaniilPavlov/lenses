part of 'generated/generated.dart';

@immutable
@JsonSerializable()
class LensesPairDatesModel {
  const LensesPairDatesModel({this.left, this.right});

  factory LensesPairDatesModel.fromJson(Map<String, dynamic> json) => _$LensesPairDatesModelFromJson(json);
  final LensDateModel? left;
  final LensDateModel? right;

  bool get isEmpty => left == null && right == null;

  bool get hasBoth => left != null && right != null;

  Map<String, dynamic> toJson() => _$LensesPairDatesModelToJson(this);
}
