// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competition_weight_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CompetitionWeightCategory _$CompetitionWeightCategoryFromJson(Map<String, dynamic> json) => _CompetitionWeightCategory(
  id: (json['id'] as num?)?.toInt(),
  weightClass: WeightClass.fromJson(json['weightClass'] as Map<String, dynamic>),
  ageCategory: AgeCategory.fromJson(json['ageCategory'] as Map<String, dynamic>),
  competition: Competition.fromJson(json['competition'] as Map<String, dynamic>),
  competitionSystem: $enumDecodeNullable(_$CompetitionSystemEnumMap, json['competitionSystem']),
  poolGroupCount: (json['poolGroupCount'] as num?)?.toInt() ?? 1,
  pairedRound: (json['pairedRound'] as num?)?.toInt(),
);

Map<String, dynamic> _$CompetitionWeightCategoryToJson(_CompetitionWeightCategory instance) => <String, dynamic>{
  'id': instance.id,
  'weightClass': instance.weightClass.toJson(),
  'ageCategory': instance.ageCategory.toJson(),
  'competition': instance.competition.toJson(),
  'competitionSystem': _$CompetitionSystemEnumMap[instance.competitionSystem],
  'poolGroupCount': instance.poolGroupCount,
  'pairedRound': instance.pairedRound,
};

const _$CompetitionSystemEnumMap = {
  CompetitionSystem.singleElimination: 'singleElimination',
  CompetitionSystem.doubleElimination: 'doubleElimination',
  CompetitionSystem.nordic: 'nordic',
  CompetitionSystem.nordicDoubleElimination: 'nordicDoubleElimination',
};
