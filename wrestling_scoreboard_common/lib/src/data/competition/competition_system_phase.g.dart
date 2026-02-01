// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competition_system_phase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CompetitionSystemPhase _$CompetitionSystemPhaseFromJson(Map<String, dynamic> json) => _CompetitionSystemPhase(
  id: (json['id'] as num?)?.toInt(),
  competitionSystemAffiliation: CompetitionSystemAffiliation.fromJson(
    json['competitionSystemAffiliation'] as Map<String, dynamic>,
  ),
  competitionSystem: $enumDecode(_$CompetitionSystemEnumMap, json['competitionSystem']),
  poolGroupCount: (json['poolGroupCount'] as num?)?.toInt() ?? 1,
  isCrossOver: json['isCrossOver'] as bool? ?? false,
  maxRank: (json['maxRank'] as num?)?.toInt(),
  pos: (json['pos'] as num).toInt(),
);

Map<String, dynamic> _$CompetitionSystemPhaseToJson(_CompetitionSystemPhase instance) => <String, dynamic>{
  'id': instance.id,
  'competitionSystemAffiliation': instance.competitionSystemAffiliation.toJson(),
  'competitionSystem': _$CompetitionSystemEnumMap[instance.competitionSystem]!,
  'poolGroupCount': instance.poolGroupCount,
  'isCrossOver': instance.isCrossOver,
  'maxRank': instance.maxRank,
  'pos': instance.pos,
};

const _$CompetitionSystemEnumMap = {
  CompetitionSystem.bestOfThree: 'bestOfThree',
  CompetitionSystem.finals: 'finals',
  CompetitionSystem.singleElimination: 'singleElimination',
  CompetitionSystem.doubleElimination: 'doubleElimination',
  CompetitionSystem.nordic: 'nordic',
  CompetitionSystem.nordicDoubleElimination: 'nordicDoubleElimination',
};
