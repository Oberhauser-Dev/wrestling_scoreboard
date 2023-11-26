// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tournament_team_participation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TournamentTeamParticipation _$TournamentTeamParticipationFromJson(
        Map<String, dynamic> json) =>
    TournamentTeamParticipation(
      id: json['id'] as int?,
      tournament:
          Tournament.fromJson(json['tournament'] as Map<String, dynamic>),
      team: Team.fromJson(json['team'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TournamentTeamParticipationToJson(
        TournamentTeamParticipation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'team': instance.team.toJson(),
      'tournament': instance.tournament.toJson(),
    };
