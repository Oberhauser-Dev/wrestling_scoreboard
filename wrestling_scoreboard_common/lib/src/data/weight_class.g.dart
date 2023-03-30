// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight_class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeightClass _$WeightClassFromJson(Map<String, dynamic> json) {
  return WeightClass(
    id: json['id'] as int?,
    weight: json['weight'] as int,
    style: _$enumDecode(_$WrestlingStyleEnumMap, json['style']),
    suffix: json['suffix'] as String?,
    unit: _$enumDecode(_$WeightUnitEnumMap, json['unit']),
  );
}

Map<String, dynamic> _$WeightClassToJson(WeightClass instance) => <String, dynamic>{
      'id': instance.id,
      'suffix': instance.suffix,
      'weight': instance.weight,
      'style': _$WrestlingStyleEnumMap[instance.style],
      'unit': _$WeightUnitEnumMap[instance.unit],
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$WrestlingStyleEnumMap = {
  WrestlingStyle.free: 'free',
  WrestlingStyle.greco: 'greco',
};

const _$WeightUnitEnumMap = {
  WeightUnit.kilogram: 'kilogram',
  WeightUnit.pound: 'pound',
};
