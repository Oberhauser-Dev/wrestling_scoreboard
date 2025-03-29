// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competition_mode_affiliation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CompetitionModeAffiliation _$CompetitionModeAffiliationFromJson(
        Map<String, dynamic> json) =>
    _CompetitionModeAffiliation(
      id: (json['id'] as num?)?.toInt(),
      competition:
          Competition.fromJson(json['competition'] as Map<String, dynamic>),
      competitionMode:
          $enumDecode(_$CompetitionModeEnumMap, json['competitionMode']),
      maxContestants: (json['maxContestants'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CompetitionModeAffiliationToJson(
        _CompetitionModeAffiliation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'competition': instance.competition.toJson(),
      'competitionMode': _$CompetitionModeEnumMap[instance.competitionMode]!,
      'maxContestants': instance.maxContestants,
    };

const _$CompetitionModeEnumMap = {
  CompetitionMode.nordic: 'nordic',
  CompetitionMode.twoPools: 'twoPools',
};
