// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight_class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WeightClass _$WeightClassFromJson(Map<String, dynamic> json) => _WeightClass(
  id: (json['id'] as num?)?.toInt(),
  weight: (json['weight'] as num).toInt(),
  style: $enumDecode(_$WrestlingStyleEnumMap, json['style']),
  suffix: json['suffix'] as String?,
  unit: $enumDecodeNullable(_$WeightUnitEnumMap, json['unit']) ?? WeightUnit.kilogram,
);

Map<String, dynamic> _$WeightClassToJson(_WeightClass instance) => <String, dynamic>{
  'id': instance.id,
  'weight': instance.weight,
  'style': _$WrestlingStyleEnumMap[instance.style]!,
  'suffix': instance.suffix,
  'unit': _$WeightUnitEnumMap[instance.unit]!,
};

const _$WrestlingStyleEnumMap = {WrestlingStyle.free: 'free', WrestlingStyle.greco: 'greco'};

const _$WeightUnitEnumMap = {WeightUnit.kilogram: 'kilogram', WeightUnit.pound: 'pound'};
