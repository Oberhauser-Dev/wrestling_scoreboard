// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competition_system_affiliation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CompetitionSystemAffiliation _$CompetitionSystemAffiliationFromJson(
        Map<String, dynamic> json) =>
    _CompetitionSystemAffiliation(
      id: (json['id'] as num?)?.toInt(),
      competition:
          Competition.fromJson(json['competition'] as Map<String, dynamic>),
      competitionSystem:
          $enumDecode(_$CompetitionSystemEnumMap, json['competitionSystem']),
      maxContestants: (json['maxContestants'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CompetitionSystemAffiliationToJson(
        _CompetitionSystemAffiliation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'competition': instance.competition.toJson(),
      'competitionSystem':
          _$CompetitionSystemEnumMap[instance.competitionSystem]!,
      'maxContestants': instance.maxContestants,
    };

const _$CompetitionSystemEnumMap = {
  CompetitionSystem.nordic: 'nordic',
  CompetitionSystem.twoPools: 'twoPools',
};
