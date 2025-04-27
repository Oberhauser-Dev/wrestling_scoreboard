// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'athlete_bout_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AthleteBoutState _$AthleteBoutStateFromJson(Map<String, dynamic> json) =>
    _AthleteBoutState(
      id: (json['id'] as num?)?.toInt(),
      membership:
          Membership.fromJson(json['membership'] as Map<String, dynamic>),
      classificationPoints: (json['classificationPoints'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AthleteBoutStateToJson(_AthleteBoutState instance) =>
    <String, dynamic>{
      'id': instance.id,
      'membership': instance.membership.toJson(),
      'classificationPoints': instance.classificationPoints,
    };
