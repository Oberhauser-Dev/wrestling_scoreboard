// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competition_team_participation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CompetitionTeamParticipationImpl _$$CompetitionTeamParticipationImplFromJson(Map<String, dynamic> json) =>
    _$CompetitionTeamParticipationImpl(
      id: json['id'] as int?,
      competition: Competition.fromJson(json['competition'] as Map<String, dynamic>),
      team: Team.fromJson(json['team'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CompetitionTeamParticipationImplToJson(_$CompetitionTeamParticipationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'competition': instance.competition.toJson(),
      'team': instance.team.toJson(),
    };
