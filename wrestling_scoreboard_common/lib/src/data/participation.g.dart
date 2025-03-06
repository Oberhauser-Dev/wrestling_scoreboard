// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Participation _$ParticipationFromJson(Map<String, dynamic> json) => _Participation(
      id: (json['id'] as num?)?.toInt(),
      membership: Membership.fromJson(json['membership'] as Map<String, dynamic>),
      lineup: Lineup.fromJson(json['lineup'] as Map<String, dynamic>),
      weightClass:
          json['weightClass'] == null ? null : WeightClass.fromJson(json['weightClass'] as Map<String, dynamic>),
      weight: (json['weight'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ParticipationToJson(_Participation instance) => <String, dynamic>{
      'id': instance.id,
      'membership': instance.membership.toJson(),
      'lineup': instance.lineup.toJson(),
      'weightClass': instance.weightClass?.toJson(),
      'weight': instance.weight,
    };
