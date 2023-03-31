// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bout_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoutConfig _$BoutConfigFromJson(Map<String, dynamic> json) => BoutConfig(
      id: json['id'] as int?,
      periodDuration: json['periodDuration'] == null
          ? defaultPeriodDuration
          : Duration(microseconds: json['periodDuration'] as int),
      breakDuration: json['breakDuration'] == null
          ? defaultBreakDuration
          : Duration(microseconds: json['breakDuration'] as int),
      activityDuration: json['activityDuration'] == null
          ? defaultActivityDuration
          : Duration(microseconds: json['activityDuration'] as int),
      injuryDuration: json['injuryDuration'] == null
          ? defaultInjuryDuration
          : Duration(microseconds: json['injuryDuration'] as int),
      periodCount: json['periodCount'] as int? ?? defaultPeriodCount,
    );

Map<String, dynamic> _$BoutConfigToJson(BoutConfig instance) =>
    <String, dynamic>{
      'id': instance.id,
      'periodDuration': instance.periodDuration.inMicroseconds,
      'breakDuration': instance.breakDuration.inMicroseconds,
      'activityDuration': instance.activityDuration.inMicroseconds,
      'injuryDuration': instance.injuryDuration.inMicroseconds,
      'periodCount': instance.periodCount,
    };
