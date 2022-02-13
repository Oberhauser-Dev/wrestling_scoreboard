// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bout_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoutConfig _$BoutConfigFromJson(Map<String, dynamic> json) {
  return BoutConfig(
    id: json['id'] as int?,
    periodDuration: Duration(microseconds: json['periodDuration'] as int),
    breakDuration: Duration(microseconds: json['breakDuration'] as int),
    activityDuration: Duration(microseconds: json['activityDuration'] as int),
    injuryDuration: Duration(microseconds: json['injuryDuration'] as int),
    periodCount: json['periodCount'] as int,
  );
}

Map<String, dynamic> _$BoutConfigToJson(BoutConfig instance) =>
    <String, dynamic>{
      'id': instance.id,
      'periodDuration': instance.periodDuration.inMicroseconds,
      'breakDuration': instance.breakDuration.inMicroseconds,
      'activityDuration': instance.activityDuration.inMicroseconds,
      'injuryDuration': instance.injuryDuration.inMicroseconds,
      'periodCount': instance.periodCount,
    };
