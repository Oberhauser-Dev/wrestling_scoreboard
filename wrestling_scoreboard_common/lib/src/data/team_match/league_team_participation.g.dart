// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'league_team_participation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LeagueTeamParticipation _$LeagueTeamParticipationFromJson(Map<String, dynamic> json) => _LeagueTeamParticipation(
      id: (json['id'] as num?)?.toInt(),
      league: League.fromJson(json['league'] as Map<String, dynamic>),
      team: Team.fromJson(json['team'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LeagueTeamParticipationToJson(_LeagueTeamParticipation instance) => <String, dynamic>{
      'id': instance.id,
      'league': instance.league.toJson(),
      'team': instance.team.toJson(),
    };
