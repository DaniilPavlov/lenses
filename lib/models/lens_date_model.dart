part of 'generated/generated.dart';

@JsonSerializable()
class LensDateModel {
  LensDateModel({required this.dateStart, required this.dateEnd, required this.daysLeft});

  factory LensDateModel.fromJson(Map<String, dynamic> json) => _$LensDateModelFromJson(json);
  final DateTime dateStart;
  final DateTime dateEnd;
  final int daysLeft;

  Map<String, dynamic> toJson() => _$LensDateModelToJson(this);
  LensDateModel copyWith({DateTime? dateStart, DateTime? dateEnd, int? daysLeft}) {
    return LensDateModel(
      dateStart: dateStart ?? this.dateStart,
      dateEnd: dateEnd ?? this.dateEnd,
      daysLeft: daysLeft ?? this.daysLeft,
    );
  }
}
