// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_lineup_participation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TeamLineupParticipation _$TeamLineupParticipationFromJson(Map<String, dynamic> json) => _TeamLineupParticipation(
  id: (json['id'] as num?)?.toInt(),
  membership: Membership.fromJson(json['membership'] as Map<String, dynamic>),
  lineup: TeamLineup.fromJson(json['lineup'] as Map<String, dynamic>),
  weightClass: json['weightClass'] == null ? null : WeightClass.fromJson(json['weightClass'] as Map<String, dynamic>),
  weight: (json['weight'] as num?)?.toDouble(),
);

Map<String, dynamic> _$TeamLineupParticipationToJson(_TeamLineupParticipation instance) => <String, dynamic>{
  'id': instance.id,
  'membership': instance.membership.toJson(),
  'lineup': instance.lineup.toJson(),
  'weightClass': instance.weightClass?.toJson(),
  'weight': instance.weight,
};
