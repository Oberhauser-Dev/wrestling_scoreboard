// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight_class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeightClass _$WeightClassFromJson(Map<String, dynamic> json) {
  return WeightClass(
    json['weight'] as int,
    _$enumDecode(_$WrestlingStyleEnumMap, json['style']),
    name: json['name'] as String?,
  );
}

Map<String, dynamic> _$WeightClassToJson(WeightClass instance) =>
    <String, dynamic>{
      'name': instance.name,
      'weight': instance.weight,
      'style': _$WrestlingStyleEnumMap[instance.style],
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
