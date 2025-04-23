// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competition_bout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CompetitionBout _$CompetitionBoutFromJson(Map<String, dynamic> json) =>
    _CompetitionBout(
      id: (json['id'] as num?)?.toInt(),
      competition:
          Competition.fromJson(json['competition'] as Map<String, dynamic>),
      bout: Bout.fromJson(json['bout'] as Map<String, dynamic>),
      pos: (json['pos'] as num).toInt(),
      mat: (json['mat'] as num?)?.toInt(),
      round: (json['round'] as num?)?.toInt(),
      roundType: $enumDecodeNullable(_$RoundTypeEnumMap, json['roundType']) ??
          RoundType.qualification,
      weightCategory: json['weightCategory'] == null
          ? null
          : CompetitionWeightCategory.fromJson(
              json['weightCategory'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CompetitionBoutToJson(_CompetitionBout instance) =>
    <String, dynamic>{
      'id': instance.id,
      'competition': instance.competition.toJson(),
      'bout': instance.bout.toJson(),
      'pos': instance.pos,
      'mat': instance.mat,
      'round': instance.round,
      'roundType': _$RoundTypeEnumMap[instance.roundType]!,
      'weightCategory': instance.weightCategory?.toJson(),
    };

const _$RoundTypeEnumMap = {
  RoundType.qualification: 'qualification',
  RoundType.elimination: 'elimination',
  RoundType.repechage: 'repechage',
  RoundType.semiFinals: 'semiFinals',
  RoundType.finals: 'finals',
};
