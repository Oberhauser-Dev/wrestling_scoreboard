// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fight_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FightActionImpl _$$FightActionImplFromJson(Map<String, dynamic> json) =>
    _$FightActionImpl(
      id: json['id'] as int?,
      actionType: $enumDecode(_$FightActionTypeEnumMap, json['actionType']),
      fight: Fight.fromJson(json['fight'] as Map<String, dynamic>),
      duration: Duration(microseconds: json['duration'] as int),
      role: $enumDecode(_$FightRoleEnumMap, json['role']),
      pointCount: json['pointCount'] as int?,
    );

Map<String, dynamic> _$$FightActionImplToJson(_$FightActionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'actionType': _$FightActionTypeEnumMap[instance.actionType]!,
      'fight': instance.fight.toJson(),
      'duration': instance.duration.inMicroseconds,
      'role': _$FightRoleEnumMap[instance.role]!,
      'pointCount': instance.pointCount,
    };

const _$FightActionTypeEnumMap = {
  FightActionType.points: 'points',
  FightActionType.passivity: 'passivity',
  FightActionType.verbal: 'verbal',
  FightActionType.caution: 'caution',
  FightActionType.dismissal: 'dismissal',
};

const _$FightRoleEnumMap = {
  FightRole.red: 'red',
  FightRole.blue: 'blue',
};
