// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'league_team_participation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeagueTeamParticipation _$LeagueTeamParticipationFromJson(
        Map<String, dynamic> json) =>
    LeagueTeamParticipation(
      id: json['id'] as int?,
      league: League.fromJson(json['league'] as Map<String, dynamic>),
      team: Team.fromJson(json['team'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LeagueTeamParticipationToJson(
        LeagueTeamParticipation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'team': instance.team.toJson(),
      'league': instance.league.toJson(),
    };
