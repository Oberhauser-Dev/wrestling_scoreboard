// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'division_weight_class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DivisionWeightClassImpl _$$DivisionWeightClassImplFromJson(Map<String, dynamic> json) => _$DivisionWeightClassImpl(
      id: json['id'] as int?,
      pos: json['pos'] as int,
      division: Division.fromJson(json['division'] as Map<String, dynamic>),
      weightClass: WeightClass.fromJson(json['weightClass'] as Map<String, dynamic>),
      seasonPartition: json['seasonPartition'] as int?,
    );

Map<String, dynamic> _$$DivisionWeightClassImplToJson(_$DivisionWeightClassImpl instance) => <String, dynamic>{
      'id': instance.id,
      'pos': instance.pos,
      'division': instance.division.toJson(),
      'weightClass': instance.weightClass.toJson(),
      'seasonPartition': instance.seasonPartition,
    };
