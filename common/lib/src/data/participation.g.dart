// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Participation _$ParticipationFromJson(Map<String, dynamic> json) {
  return Participation(
    id: json['id'] as int?,
    membership: Membership.fromJson(json['membership'] as Map<String, dynamic>),
    lineup: Lineup.fromJson(json['lineup'] as Map<String, dynamic>),
    weightClass: WeightClass.fromJson(json['weightClass'] as Map<String, dynamic>),
    weight: (json['weight'] as num?)?.toDouble(),
  );
}

Map<String, dynamic> _$ParticipationToJson(Participation instance) => <String, dynamic>{
      'id': instance.id,
      'membership': instance.membership.toJson(),
      'lineup': instance.lineup.toJson(),
      'weightClass': instance.weightClass.toJson(),
      'weight': instance.weight,
    };
