// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fight.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Fight _$FightFromJson(Map<String, dynamic> json) {
  return Fight(
    id: json['id'] as int?,
    r: json['r'] == null
        ? null
        : ParticipantState.fromJson(json['r'] as Map<String, dynamic>),
    b: json['b'] == null
        ? null
        : ParticipantState.fromJson(json['b'] as Map<String, dynamic>),
    weightClass:
        WeightClass.fromJson(json['weightClass'] as Map<String, dynamic>),
    pool: json['pool'] as int?,
  )
    ..result = _$enumDecodeNullable(_$FightResultEnumMap, json['result'])
    ..winner = _$enumDecodeNullable(_$FightRoleEnumMap, json['winner'])
    ..duration = Duration(microseconds: json['duration'] as int);
}

Map<String, dynamic> _$FightToJson(Fight instance) => <String, dynamic>{
      'id': instance.id,
      'r': instance.r,
      'b': instance.b,
      'weightClass': instance.weightClass,
      'pool': instance.pool,
      'result': _$FightResultEnumMap[instance.result],
      'winner': _$FightRoleEnumMap[instance.winner],
      'duration': instance.duration.inMicroseconds,
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

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$FightResultEnumMap = {
  FightResult.VFA: 'VFA',
  FightResult.VIN: 'VIN',
  FightResult.VCA: 'VCA',
  FightResult.VSU: 'VSU',
  FightResult.VSU1: 'VSU1',
  FightResult.VPO: 'VPO',
  FightResult.VPO1: 'VPO1',
  FightResult.VFO: 'VFO',
  FightResult.DSQ: 'DSQ',
  FightResult.DSQ2: 'DSQ2',
};

const _$FightRoleEnumMap = {
  FightRole.red: 'red',
  FightRole.blue: 'blue',
};
