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
  competitionSystemAffiliation: json['competitionSystemAffiliation'] == null
      ? null
      : CompetitionSystemAffiliation.fromJson(json['competitionSystemAffiliation'] as Map<String, dynamic>),
  pairedRoundByPhase:
      (json['pairedRoundByPhase'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList() ?? const [],
  pos: (json['pos'] as num?)?.toInt() ?? 0,
  skippedCycles: (json['skippedCycles'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList() ?? const [],
);

Map<String, dynamic> _$CompetitionWeightCategoryToJson(_CompetitionWeightCategory instance) => <String, dynamic>{
  'id': instance.id,
  'weightClass': instance.weightClass.toJson(),
  'competitionAgeCategory': instance.competitionAgeCategory.toJson(),
  'competition': instance.competition.toJson(),
  'competitionSystemAffiliation': instance.competitionSystemAffiliation?.toJson(),
  'pairedRoundByPhase': instance.pairedRoundByPhase,
  'pos': instance.pos,
  'skippedCycles': instance.skippedCycles,
};
