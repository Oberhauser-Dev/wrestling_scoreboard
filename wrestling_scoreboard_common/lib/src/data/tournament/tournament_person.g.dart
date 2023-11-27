// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tournament_person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TournamentPersonImpl _$$TournamentPersonImplFromJson(
        Map<String, dynamic> json) =>
    _$TournamentPersonImpl(
      id: json['id'] as int?,
      tournament:
          Tournament.fromJson(json['tournament'] as Map<String, dynamic>),
      person: Person.fromJson(json['person'] as Map<String, dynamic>),
      role: $enumDecode(_$PersonRoleEnumMap, json['role']),
    );

Map<String, dynamic> _$$TournamentPersonImplToJson(
        _$TournamentPersonImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tournament': instance.tournament.toJson(),
      'person': instance.person.toJson(),
      'role': _$PersonRoleEnumMap[instance.role]!,
    };

const _$PersonRoleEnumMap = {
  PersonRole.referee: 'referee',
  PersonRole.matChairman: 'matChairman',
  PersonRole.judge: 'judge',
  PersonRole.transcriptWriter: 'transcriptWriter',
  PersonRole.timeKeeper: 'timeKeeper',
  PersonRole.steward: 'steward',
};
