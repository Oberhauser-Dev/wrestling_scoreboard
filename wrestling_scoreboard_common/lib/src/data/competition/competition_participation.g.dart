// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competition_participation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CompetitionParticipation _$CompetitionParticipationFromJson(
        Map<String, dynamic> json) =>
    _CompetitionParticipation(
      id: (json['id'] as num?)?.toInt(),
      membership:
          Membership.fromJson(json['membership'] as Map<String, dynamic>),
      lineup:
          CompetitionLineup.fromJson(json['lineup'] as Map<String, dynamic>),
      weightCategory: json['weightCategory'] == null
          ? null
          : CompetitionWeightCategory.fromJson(
              json['weightCategory'] as Map<String, dynamic>),
      weight: (json['weight'] as num?)?.toDouble(),
      poolGroup: (json['poolGroup'] as num?)?.toInt(),
      poolDrawNumber: (json['poolDrawNumber'] as num?)?.toInt(),
      eliminated: json['eliminated'] as bool? ?? false,
      disqualified: json['disqualified'] as bool? ?? false,
    );

Map<String, dynamic> _$CompetitionParticipationToJson(
        _CompetitionParticipation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'membership': instance.membership.toJson(),
      'lineup': instance.lineup.toJson(),
      'weightCategory': instance.weightCategory?.toJson(),
      'weight': instance.weight,
      'poolGroup': instance.poolGroup,
      'poolDrawNumber': instance.poolDrawNumber,
      'eliminated': instance.eliminated,
      'disqualified': instance.disqualified,
    };
