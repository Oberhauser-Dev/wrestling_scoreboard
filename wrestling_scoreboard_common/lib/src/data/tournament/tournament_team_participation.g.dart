// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tournament_team_participation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TournamentTeamParticipationImpl _$$TournamentTeamParticipationImplFromJson(
        Map<String, dynamic> json) =>
    _$TournamentTeamParticipationImpl(
      id: json['id'] as int?,
      tournament:
          Tournament.fromJson(json['tournament'] as Map<String, dynamic>),
      team: Team.fromJson(json['team'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$TournamentTeamParticipationImplToJson(
        _$TournamentTeamParticipationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tournament': instance.tournament.toJson(),
      'team': instance.team.toJson(),
    };
