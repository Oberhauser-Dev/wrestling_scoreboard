// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tournament_person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TournamentPerson _$TournamentPersonFromJson(Map<String, dynamic> json) =>
    TournamentPerson(
      id: json['id'] as int?,
      tournament:
          Tournament.fromJson(json['tournament'] as Map<String, dynamic>),
      person: Person.fromJson(json['person'] as Map<String, dynamic>),
      role: $enumDecode(_$PersonRoleEnumMap, json['role']),
    );

Map<String, dynamic> _$TournamentPersonToJson(TournamentPerson instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': _$PersonRoleEnumMap[instance.role]!,
      'tournament': instance.tournament.toJson(),
      'person': instance.person.toJson(),
    };

const _$PersonRoleEnumMap = {
  PersonRole.referee: 'referee',
  PersonRole.matChairman: 'matChairman',
  PersonRole.judge: 'judge',
  PersonRole.transcriptWriter: 'transcriptWriter',
  PersonRole.timeKeeper: 'timeKeeper',
  PersonRole.steward: 'steward',
};
