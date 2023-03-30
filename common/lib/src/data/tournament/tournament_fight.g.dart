// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tournament_fight.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TournamentFight _$TournamentFightFromJson(Map<String, dynamic> json) {
  return TournamentFight(
    id: json['id'] as int?,
    tournament: Tournament.fromJson(json['tournament'] as Map<String, dynamic>),
    fight: Fight.fromJson(json['fight'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$TournamentFightToJson(TournamentFight instance) => <String, dynamic>{
      'id': instance.id,
      'tournament': instance.tournament.toJson(),
      'fight': instance.fight.toJson(),
    };
