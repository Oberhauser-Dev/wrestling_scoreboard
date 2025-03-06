// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competition_person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CompetitionPerson _$CompetitionPersonFromJson(Map<String, dynamic> json) => _CompetitionPerson(
      id: (json['id'] as num?)?.toInt(),
      competition: Competition.fromJson(json['competition'] as Map<String, dynamic>),
      person: Person.fromJson(json['person'] as Map<String, dynamic>),
      role: $enumDecode(_$PersonRoleEnumMap, json['role']),
    );

Map<String, dynamic> _$CompetitionPersonToJson(_CompetitionPerson instance) => <String, dynamic>{
      'id': instance.id,
      'competition': instance.competition.toJson(),
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
