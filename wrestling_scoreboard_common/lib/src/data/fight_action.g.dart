// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fight_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FightAction _$FightActionFromJson(Map<String, dynamic> json) => FightAction(
      id: json['id'] as int?,
      actionType: $enumDecode(_$FightActionTypeEnumMap, json['actionType']),
      fight: Fight.fromJson(json['fight'] as Map<String, dynamic>),
      duration: Duration(microseconds: json['duration'] as int),
      role: $enumDecode(_$FightRoleEnumMap, json['role']),
      pointCount: json['pointCount'] as int?,
    );

Map<String, dynamic> _$FightActionToJson(FightAction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'duration': instance.duration.inMicroseconds,
      'actionType': _$FightActionTypeEnumMap[instance.actionType]!,
      'pointCount': instance.pointCount,
      'role': _$FightRoleEnumMap[instance.role]!,
      'fight': instance.fight.toJson(),
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
