// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TeamMatchParticipation _$TeamMatchParticipationFromJson(Map<String, dynamic> json) => _TeamMatchParticipation(
      id: (json['id'] as num?)?.toInt(),
      membership: Membership.fromJson(json['membership'] as Map<String, dynamic>),
      lineup: TeamLineup.fromJson(json['lineup'] as Map<String, dynamic>),
      weightClass:
          json['weightClass'] == null ? null : WeightClass.fromJson(json['weightClass'] as Map<String, dynamic>),
      weight: (json['weight'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$TeamMatchParticipationToJson(_TeamMatchParticipation instance) => <String, dynamic>{
      'id': instance.id,
      'membership': instance.membership.toJson(),
      'lineup': instance.lineup.toJson(),
      'weightClass': instance.weightClass?.toJson(),
      'weight': instance.weight,
    };
