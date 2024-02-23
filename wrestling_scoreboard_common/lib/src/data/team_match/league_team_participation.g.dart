// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'league_team_participation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeagueTeamParticipationImpl _$$LeagueTeamParticipationImplFromJson(Map<String, dynamic> json) =>
    _$LeagueTeamParticipationImpl(
      id: json['id'] as int?,
      league: League.fromJson(json['league'] as Map<String, dynamic>),
      team: Team.fromJson(json['team'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$LeagueTeamParticipationImplToJson(_$LeagueTeamParticipationImpl instance) => <String, dynamic>{
      'id': instance.id,
      'league': instance.league.toJson(),
      'team': instance.team.toJson(),
    };
