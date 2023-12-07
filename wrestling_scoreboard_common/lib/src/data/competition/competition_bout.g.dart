// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competition_bout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CompetitionBoutImpl _$$CompetitionBoutImplFromJson(
        Map<String, dynamic> json) =>
    _$CompetitionBoutImpl(
      id: json['id'] as int?,
      competition:
          Competition.fromJson(json['competition'] as Map<String, dynamic>),
      bout: Bout.fromJson(json['bout'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CompetitionBoutImplToJson(
        _$CompetitionBoutImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'competition': instance.competition.toJson(),
      'bout': instance.bout.toJson(),
    };
