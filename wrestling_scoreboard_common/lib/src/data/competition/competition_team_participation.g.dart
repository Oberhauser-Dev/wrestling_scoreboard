// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competition_team_participation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CompetitionTeamParticipation _$CompetitionTeamParticipationFromJson(Map<String, dynamic> json) =>
    _CompetitionTeamParticipation(
      id: (json['id'] as num?)?.toInt(),
      competition: Competition.fromJson(json['competition'] as Map<String, dynamic>),
      team: Team.fromJson(json['team'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CompetitionTeamParticipationToJson(_CompetitionTeamParticipation instance) => <String, dynamic>{
      'id': instance.id,
      'competition': instance.competition.toJson(),
      'team': instance.team.toJson(),
    };
