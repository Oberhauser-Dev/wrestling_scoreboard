// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bout_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BoutConfig _$BoutConfigFromJson(Map<String, dynamic> json) => _BoutConfig(
      id: (json['id'] as num?)?.toInt(),
      periodDuration: json['periodDuration'] == null
          ? BoutConfig.defaultPeriodDuration
          : Duration(microseconds: (json['periodDuration'] as num).toInt()),
      breakDuration: json['breakDuration'] == null
          ? BoutConfig.defaultBreakDuration
          : Duration(microseconds: (json['breakDuration'] as num).toInt()),
      activityDuration:
          json['activityDuration'] == null ? null : Duration(microseconds: (json['activityDuration'] as num).toInt()),
      injuryDuration:
          json['injuryDuration'] == null ? null : Duration(microseconds: (json['injuryDuration'] as num).toInt()),
      bleedingInjuryDuration: json['bleedingInjuryDuration'] == null
          ? null
          : Duration(microseconds: (json['bleedingInjuryDuration'] as num).toInt()),
      periodCount: (json['periodCount'] as num?)?.toInt() ?? BoutConfig.defaultPeriodCount,
    );

Map<String, dynamic> _$BoutConfigToJson(_BoutConfig instance) => <String, dynamic>{
      'id': instance.id,
      'periodDuration': instance.periodDuration.inMicroseconds,
      'breakDuration': instance.breakDuration.inMicroseconds,
      'activityDuration': instance.activityDuration?.inMicroseconds,
      'injuryDuration': instance.injuryDuration?.inMicroseconds,
      'bleedingInjuryDuration': instance.bleedingInjuryDuration?.inMicroseconds,
      'periodCount': instance.periodCount,
    };
