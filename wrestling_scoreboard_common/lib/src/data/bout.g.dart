// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Bout _$BoutFromJson(Map<String, dynamic> json) => _Bout(
  id: (json['id'] as num?)?.toInt(),
  orgSyncId: json['orgSyncId'] as String?,
  organization:
      json['organization'] == null ? null : Organization.fromJson(json['organization'] as Map<String, dynamic>),
  r: json['r'] == null ? null : AthleteBoutState.fromJson(json['r'] as Map<String, dynamic>),
  b: json['b'] == null ? null : AthleteBoutState.fromJson(json['b'] as Map<String, dynamic>),
  winnerRole: $enumDecodeNullable(_$BoutRoleEnumMap, json['winnerRole']),
  result: $enumDecodeNullable(_$BoutResultEnumMap, json['result']),
  duration: json['duration'] == null ? Duration.zero : Duration(microseconds: (json['duration'] as num).toInt()),
  comment: json['comment'] as String?,
);

Map<String, dynamic> _$BoutToJson(_Bout instance) => <String, dynamic>{
  'id': instance.id,
  'orgSyncId': instance.orgSyncId,
  'organization': instance.organization?.toJson(),
  'r': instance.r?.toJson(),
  'b': instance.b?.toJson(),
  'winnerRole': _$BoutRoleEnumMap[instance.winnerRole],
  'result': _$BoutResultEnumMap[instance.result],
  'duration': instance.duration.inMicroseconds,
  'comment': instance.comment,
};

const _$BoutRoleEnumMap = {BoutRole.red: 'red', BoutRole.blue: 'blue'};

const _$BoutResultEnumMap = {
  BoutResult.vfa: 'vfa',
  BoutResult.vin: 'vin',
  BoutResult.bothVin: 'bothVin',
  BoutResult.vca: 'vca',
  BoutResult.vsu: 'vsu',
  BoutResult.vpo: 'vpo',
  BoutResult.vfo: 'vfo',
  BoutResult.bothVfo: 'bothVfo',
  BoutResult.dsq: 'dsq',
  BoutResult.bothDsq: 'bothDsq',
};
