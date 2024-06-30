// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bout_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BoutActionImpl _$$BoutActionImplFromJson(Map<String, dynamic> json) => _$BoutActionImpl(
      id: (json['id'] as num?)?.toInt(),
      actionType: $enumDecode(_$BoutActionTypeEnumMap, json['actionType']),
      bout: Bout.fromJson(json['bout'] as Map<String, dynamic>),
      duration: Duration(microseconds: (json['duration'] as num).toInt()),
      role: $enumDecode(_$BoutRoleEnumMap, json['role']),
      pointCount: (json['pointCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$BoutActionImplToJson(_$BoutActionImpl instance) => <String, dynamic>{
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
};

const _$BoutRoleEnumMap = {
  BoutRole.red: 'red',
  BoutRole.blue: 'blue',
};
