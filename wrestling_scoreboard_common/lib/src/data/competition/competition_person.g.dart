// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competition_person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CompetitionPersonImpl _$$CompetitionPersonImplFromJson(Map<String, dynamic> json) => _$CompetitionPersonImpl(
      id: (json['id'] as num?)?.toInt(),
      competition: Competition.fromJson(json['competition'] as Map<String, dynamic>),
      person: Person.fromJson(json['person'] as Map<String, dynamic>),
      role: $enumDecode(_$PersonRoleEnumMap, json['role']),
    );

Map<String, dynamic> _$$CompetitionPersonImplToJson(_$CompetitionPersonImpl instance) => <String, dynamic>{
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
