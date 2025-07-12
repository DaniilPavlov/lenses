

part of 'generated/generated.dart';

@immutable
@JsonSerializable()
class LensesPairDatesModel {
  final LensDateModel? left;
  final LensDateModel? right;

  const LensesPairDatesModel({this.left, this.right});

  Map<String, dynamic> toJson() => _$LensesPairDatesModelToJson(this);

  factory LensesPairDatesModel.fromJson(Map<String, dynamic> json) => _$LensesPairDatesModelFromJson(json);
 
}
