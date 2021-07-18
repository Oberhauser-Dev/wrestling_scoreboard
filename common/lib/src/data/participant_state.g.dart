// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParticipantState _$ParticipantStateFromJson(Map<String, dynamic> json) {
  return ParticipantState(
    id: json['id'] as int?,
    participation:
        Participation.fromJson(json['participation'] as Map<String, dynamic>),
    classificationPoints: json['classificationPoints'] as int?,
  );
}

Map<String, dynamic> _$ParticipantStateToJson(ParticipantState instance) =>
    <String, dynamic>{
      'id': instance.id,
      'participation': instance.participation,
      'classificationPoints': instance.classificationPoints,
    };
