// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competition_system_affiliation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CompetitionSystemAffiliation _$CompetitionSystemAffiliationFromJson(Map<String, dynamic> json) =>
    _CompetitionSystemAffiliation(
      id: (json['id'] as num?)?.toInt(),
      competition: Competition.fromJson(json['competition'] as Map<String, dynamic>),
      maxContestants: (json['maxContestants'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CompetitionSystemAffiliationToJson(_CompetitionSystemAffiliation instance) => <String, dynamic>{
  'id': instance.id,
  'competition': instance.competition.toJson(),
  'maxContestants': instance.maxContestants,
};
