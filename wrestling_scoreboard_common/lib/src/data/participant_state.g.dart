// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ParticipantState _$ParticipantStateFromJson(Map<String, dynamic> json) => _ParticipantState(
      id: (json['id'] as num?)?.toInt(),
      participation: Participation.fromJson(json['participation'] as Map<String, dynamic>),
      classificationPoints: (json['classificationPoints'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ParticipantStateToJson(_ParticipantState instance) => <String, dynamic>{
      'id': instance.id,
      'participation': instance.participation.toJson(),
      'classificationPoints': instance.classificationPoints,
    };
