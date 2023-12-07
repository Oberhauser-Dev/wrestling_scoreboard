// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BoutImpl _$$BoutImplFromJson(Map<String, dynamic> json) => _$BoutImpl(
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
      winnerRole: $enumDecodeNullable(_$BoutRoleEnumMap, json['winnerRole']),
      result: $enumDecodeNullable(_$BoutResultEnumMap, json['result']),
      duration: json['duration'] == null
          ? Duration.zero
          : Duration(microseconds: json['duration'] as int),
    );

Map<String, dynamic> _$$BoutImplToJson(_$BoutImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'r': instance.r?.toJson(),
      'b': instance.b?.toJson(),
      'weightClass': instance.weightClass.toJson(),
      'pool': instance.pool,
      'winnerRole': _$BoutRoleEnumMap[instance.winnerRole],
      'result': _$BoutResultEnumMap[instance.result],
      'duration': instance.duration.inMicroseconds,
    };

const _$BoutRoleEnumMap = {
  BoutRole.red: 'red',
  BoutRole.blue: 'blue',
};

const _$BoutResultEnumMap = {
  BoutResult.vfa: 'vfa',
  BoutResult.vin: 'vin',
  BoutResult.vca: 'vca',
  BoutResult.vsu: 'vsu',
  BoutResult.vsu1: 'vsu1',
  BoutResult.vpo: 'vpo',
  BoutResult.vpo1: 'vpo1',
  BoutResult.vfo: 'vfo',
  BoutResult.dsq: 'dsq',
  BoutResult.dsq2: 'dsq2',
};
