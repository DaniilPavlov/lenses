// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generated.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LensesPairDatesModel _$LensesPairDatesModelFromJson(
  Map<String, dynamic> json,
) => LensesPairDatesModel(
  left: json['left'] == null
      ? null
      : LensDateModel.fromJson(json['left'] as Map<String, dynamic>),
  right: json['right'] == null
      ? null
      : LensDateModel.fromJson(json['right'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LensesPairDatesModelToJson(
  LensesPairDatesModel instance,
) => <String, dynamic>{'left': instance.left, 'right': instance.right};

LensDateModel _$LensDateModelFromJson(Map<String, dynamic> json) =>
    LensDateModel(
      dateStart: DateTime.parse(json['dateStart'] as String),
      dateEnd: DateTime.parse(json['dateEnd'] as String),
      daysLeft: (json['daysLeft'] as num).toInt(),
    );

Map<String, dynamic> _$LensDateModelToJson(LensDateModel instance) =>
    <String, dynamic>{
      'dateStart': instance.dateStart.toIso8601String(),
      'dateEnd': instance.dateEnd.toIso8601String(),
      'daysLeft': instance.daysLeft,
    };
