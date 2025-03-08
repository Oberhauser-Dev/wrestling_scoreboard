// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competition_bout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CompetitionBout _$CompetitionBoutFromJson(Map<String, dynamic> json) =>
    _CompetitionBout(
      id: (json['id'] as num?)?.toInt(),
      competition:
          Competition.fromJson(json['competition'] as Map<String, dynamic>),
      bout: Bout.fromJson(json['bout'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CompetitionBoutToJson(_CompetitionBout instance) =>
    <String, dynamic>{
      'id': instance.id,
      'competition': instance.competition.toJson(),
      'bout': instance.bout.toJson(),
    };
