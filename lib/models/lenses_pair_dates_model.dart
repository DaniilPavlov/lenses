part of 'generated/generated.dart';

@immutable
@JsonSerializable()
class LensesPairDatesModel {
  const LensesPairDatesModel({this.left, this.right});

  factory LensesPairDatesModel.fromJson(Map<String, dynamic> json) => _$LensesPairDatesModelFromJson(json);
  final LensDateModel? left;
  final LensDateModel? right;

  Map<String, dynamic> toJson() => _$LensesPairDatesModelToJson(this);
}
