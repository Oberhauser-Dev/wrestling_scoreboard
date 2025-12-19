// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bout_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BoutAction _$BoutActionFromJson(Map<String, dynamic> json) => _BoutAction(
  id: (json['id'] as num?)?.toInt(),
  actionType: $enumDecode(_$BoutActionTypeEnumMap, json['actionType']),
  bout: Bout.fromJson(json['bout'] as Map<String, dynamic>),
  duration: Duration(microseconds: (json['duration'] as num).toInt()),
  role: $enumDecode(_$BoutRoleEnumMap, json['role']),
  pointCount: (json['pointCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$BoutActionToJson(_BoutAction instance) => <String, dynamic>{
  'id': instance.id,
  'actionType': _$BoutActionTypeEnumMap[instance.actionType]!,
  'bout': instance.bout.toJson(),
  'duration': instance.duration.inMicroseconds,
  'role': _$BoutRoleEnumMap[instance.role]!,
  'pointCount': instance.pointCount,
};

const _$BoutActionTypeEnumMap = {
  BoutActionType.points: 'points',
  BoutActionType.passivity: 'passivity',
  BoutActionType.verbal: 'verbal',
  BoutActionType.caution: 'caution',
  BoutActionType.dismissal: 'dismissal',
  BoutActionType.legFoul: 'legFoul',
};

const _$BoutRoleEnumMap = {BoutRole.red: 'red', BoutRole.blue: 'blue'};
