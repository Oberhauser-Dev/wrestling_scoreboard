// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'division_weight_class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DivisionWeightClassImpl _$$DivisionWeightClassImplFromJson(Map<String, dynamic> json) => _$DivisionWeightClassImpl(
      id: (json['id'] as num?)?.toInt(),
      orgSyncId: json['orgSyncId'] as String?,
      organization:
          json['organization'] == null ? null : Organization.fromJson(json['organization'] as Map<String, dynamic>),
      pos: (json['pos'] as num).toInt(),
      division: Division.fromJson(json['division'] as Map<String, dynamic>),
      weightClass: WeightClass.fromJson(json['weightClass'] as Map<String, dynamic>),
      seasonPartition: (json['seasonPartition'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$DivisionWeightClassImplToJson(_$DivisionWeightClassImpl instance) => <String, dynamic>{
      'id': instance.id,
      'orgSyncId': instance.orgSyncId,
      'organization': instance.organization?.toJson(),
      'pos': instance.pos,
      'division': instance.division.toJson(),
      'weightClass': instance.weightClass.toJson(),
      'seasonPartition': instance.seasonPartition,
    };
