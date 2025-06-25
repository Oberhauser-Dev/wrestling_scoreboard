// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competition_weight_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CompetitionWeightCategory _$CompetitionWeightCategoryFromJson(Map<String, dynamic> json) => _CompetitionWeightCategory(
  id: (json['id'] as num?)?.toInt(),
  weightClass: WeightClass.fromJson(json['weightClass'] as Map<String, dynamic>),
  competitionAgeCategory: CompetitionAgeCategory.fromJson(json['competitionAgeCategory'] as Map<String, dynamic>),
  competition: Competition.fromJson(json['competition'] as Map<String, dynamic>),
  competitionSystem: $enumDecodeNullable(_$CompetitionSystemEnumMap, json['competitionSystem']),
  poolGroupCount: (json['poolGroupCount'] as num?)?.toInt() ?? 1,
  pairedRound: (json['pairedRound'] as num?)?.toInt(),
  pos: (json['pos'] as num?)?.toInt() ?? 0,
  skippedCycles: (json['skippedCycles'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList() ?? const [],
);

Map<String, dynamic> _$CompetitionWeightCategoryToJson(_CompetitionWeightCategory instance) => <String, dynamic>{
  'id': instance.id,
  'weightClass': instance.weightClass.toJson(),
  'competitionAgeCategory': instance.competitionAgeCategory.toJson(),
  'competition': instance.competition.toJson(),
  'competitionSystem': _$CompetitionSystemEnumMap[instance.competitionSystem],
  'poolGroupCount': instance.poolGroupCount,
  'pairedRound': instance.pairedRound,
  'pos': instance.pos,
  'skippedCycles': instance.skippedCycles,
};

const _$CompetitionSystemEnumMap = {
  CompetitionSystem.singleElimination: 'singleElimination',
  CompetitionSystem.doubleElimination: 'doubleElimination',
  CompetitionSystem.nordic: 'nordic',
  CompetitionSystem.nordicDoubleElimination: 'nordicDoubleElimination',
};
