// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AthleteBoutState _$AthleteBoutStateFromJson(Map<String, dynamic> json) =>
    _AthleteBoutState(
      id: (json['id'] as num?)?.toInt(),
      participation: TeamMatchParticipation.fromJson(
          json['participation'] as Map<String, dynamic>),
      classificationPoints: (json['classificationPoints'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AthleteBoutStateToJson(_AthleteBoutState instance) =>
    <String, dynamic>{
      'id': instance.id,
      'participation': instance.participation.toJson(),
      'classificationPoints': instance.classificationPoints,
    };
