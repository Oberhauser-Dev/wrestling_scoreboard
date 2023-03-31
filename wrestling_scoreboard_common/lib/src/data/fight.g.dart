// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fight.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Fight _$FightFromJson(Map<String, dynamic> json) => Fight(
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
      winnerRole: $enumDecodeNullable(_$FightRoleEnumMap, json['winnerRole']),
      result: $enumDecodeNullable(_$FightResultEnumMap, json['result']),
      duration: json['duration'] == null
          ? const Duration()
          : Duration(microseconds: json['duration'] as int),
    );

Map<String, dynamic> _$FightToJson(Fight instance) => <String, dynamic>{
      'id': instance.id,
      'r': instance.r?.toJson(),
      'b': instance.b?.toJson(),
      'weightClass': instance.weightClass.toJson(),
      'pool': instance.pool,
      'result': _$FightResultEnumMap[instance.result],
      'winnerRole': _$FightRoleEnumMap[instance.winnerRole],
      'duration': instance.duration.inMicroseconds,
    };

const _$FightRoleEnumMap = {
  FightRole.red: 'red',
  FightRole.blue: 'blue',
};

const _$FightResultEnumMap = {
  FightResult.vfa: 'vfa',
  FightResult.vin: 'vin',
  FightResult.vca: 'vca',
  FightResult.vsu: 'vsu',
  FightResult.vsu1: 'vsu1',
  FightResult.vpo: 'vpo',
  FightResult.vpo1: 'vpo1',
  FightResult.vfo: 'vfo',
  FightResult.dsq: 'dsq',
  FightResult.dsq2: 'dsq2',
};
