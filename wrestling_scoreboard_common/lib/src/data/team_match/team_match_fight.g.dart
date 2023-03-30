// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_match_fight.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamMatchFight _$TeamMatchFightFromJson(Map<String, dynamic> json) {
  return TeamMatchFight(
    id: json['id'] as int?,
    teamMatch: TeamMatch.fromJson(json['teamMatch'] as Map<String, dynamic>),
    fight: Fight.fromJson(json['fight'] as Map<String, dynamic>),
    pos: json['pos'] as int,
  );
}

Map<String, dynamic> _$TeamMatchFightToJson(TeamMatchFight instance) => <String, dynamic>{
      'id': instance.id,
      'pos': instance.pos,
      'teamMatch': instance.teamMatch.toJson(),
      'fight': instance.fight.toJson(),
    };
