// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParticipantStatus _$ParticipantStatusFromJson(Map<String, dynamic> json) {
  return ParticipantStatus(
    id: json['id'] as int?,
    membership: Membership.fromJson(json['membership'] as Map<String, dynamic>),
    weightClass:
        WeightClass.fromJson(json['weightClass'] as Map<String, dynamic>),
    weight: (json['weight'] as num?)?.toDouble(),
  )..classificationPoints = json['classificationPoints'] as int?;
}

Map<String, dynamic> _$ParticipantStatusToJson(ParticipantStatus instance) =>
    <String, dynamic>{
      'id': instance.id,
      'membership': instance.membership,
      'weightClass': instance.weightClass,
      'weight': instance.weight,
      'classificationPoints': instance.classificationPoints,
    };
