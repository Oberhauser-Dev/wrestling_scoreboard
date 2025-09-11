// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_match_person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TeamMatchPerson _$TeamMatchPersonFromJson(Map<String, dynamic> json) => _TeamMatchPerson(
  id: (json['id'] as num?)?.toInt(),
  teamMatch: TeamMatch.fromJson(json['teamMatch'] as Map<String, dynamic>),
  person: Person.fromJson(json['person'] as Map<String, dynamic>),
  role: $enumDecode(_$PersonRoleEnumMap, json['role']),
);

Map<String, dynamic> _$TeamMatchPersonToJson(_TeamMatchPerson instance) => <String, dynamic>{
  'id': instance.id,
  'teamMatch': instance.teamMatch.toJson(),
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
