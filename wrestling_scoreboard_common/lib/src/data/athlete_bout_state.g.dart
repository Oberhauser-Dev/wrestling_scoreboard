// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'athlete_bout_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AthleteBoutState _$AthleteBoutStateFromJson(Map<String, dynamic> json) => _AthleteBoutState(
  id: (json['id'] as num?)?.toInt(),
  membership: Membership.fromJson(json['membership'] as Map<String, dynamic>),
  classificationPoints: (json['classificationPoints'] as num?)?.toInt(),
  activityTime: json['activityTime'] == null ? null : Duration(microseconds: (json['activityTime'] as num).toInt()),
  injuryTime: json['injuryTime'] == null ? null : Duration(microseconds: (json['injuryTime'] as num).toInt()),
  isInjuryTimeRunning: json['isInjuryTimeRunning'] as bool? ?? false,
  bleedingInjuryTime:
      json['bleedingInjuryTime'] == null ? null : Duration(microseconds: (json['bleedingInjuryTime'] as num).toInt()),
  isBleedingInjuryTimeRunning: json['isBleedingInjuryTimeRunning'] as bool? ?? false,
);

Map<String, dynamic> _$AthleteBoutStateToJson(_AthleteBoutState instance) => <String, dynamic>{
  'id': instance.id,
  'membership': instance.membership.toJson(),
  'classificationPoints': instance.classificationPoints,
  'activityTime': instance.activityTime?.inMicroseconds,
  'injuryTime': instance.injuryTime?.inMicroseconds,
  'isInjuryTimeRunning': instance.isInjuryTimeRunning,
  'bleedingInjuryTime': instance.bleedingInjuryTime?.inMicroseconds,
  'isBleedingInjuryTimeRunning': instance.isBleedingInjuryTimeRunning,
};
