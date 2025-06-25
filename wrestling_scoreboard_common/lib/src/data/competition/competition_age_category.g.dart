// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competition_age_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CompetitionAgeCategory _$CompetitionAgeCategoryFromJson(Map<String, dynamic> json) => _CompetitionAgeCategory(
  id: (json['id'] as num?)?.toInt(),
  competition: Competition.fromJson(json['competition'] as Map<String, dynamic>),
  ageCategory: AgeCategory.fromJson(json['ageCategory'] as Map<String, dynamic>),
  pos: (json['pos'] as num?)?.toInt() ?? 0,
  skippedCycles: (json['skippedCycles'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList() ?? const [],
);

Map<String, dynamic> _$CompetitionAgeCategoryToJson(_CompetitionAgeCategory instance) => <String, dynamic>{
  'id': instance.id,
  'competition': instance.competition.toJson(),
  'ageCategory': instance.ageCategory.toJson(),
  'pos': instance.pos,
  'skippedCycles': instance.skippedCycles,
};
