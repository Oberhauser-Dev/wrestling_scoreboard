// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ParticipantStateImpl _$$ParticipantStateImplFromJson(Map<String, dynamic> json) => _$ParticipantStateImpl(
      id: json['id'] as int?,
      participation: Participation.fromJson(json['participation'] as Map<String, dynamic>),
      classificationPoints: json['classificationPoints'] as int?,
    );

Map<String, dynamic> _$$ParticipantStateImplToJson(_$ParticipantStateImpl instance) => <String, dynamic>{
      'id': instance.id,
      'participation': instance.participation.toJson(),
      'classificationPoints': instance.classificationPoints,
    };
