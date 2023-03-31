// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight_class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeightClass _$WeightClassFromJson(Map<String, dynamic> json) => WeightClass(
      id: json['id'] as int?,
      weight: json['weight'] as int,
      style: $enumDecode(_$WrestlingStyleEnumMap, json['style']),
      suffix: json['suffix'] as String?,
      unit: $enumDecodeNullable(_$WeightUnitEnumMap, json['unit']) ??
          WeightUnit.kilogram,
    );

Map<String, dynamic> _$WeightClassToJson(WeightClass instance) =>
    <String, dynamic>{
      'id': instance.id,
      'suffix': instance.suffix,
      'weight': instance.weight,
      'style': _$WrestlingStyleEnumMap[instance.style]!,
      'unit': _$WeightUnitEnumMap[instance.unit]!,
    };

const _$WrestlingStyleEnumMap = {
  WrestlingStyle.free: 'free',
  WrestlingStyle.greco: 'greco',
};

const _$WeightUnitEnumMap = {
  WeightUnit.kilogram: 'kilogram',
  WeightUnit.pound: 'pound',
};
