// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bout_result_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BoutResultRule _$BoutResultRuleFromJson(Map<String, dynamic> json) => _BoutResultRule(
      id: (json['id'] as num?)?.toInt(),
      boutConfig: BoutConfig.fromJson(json['boutConfig'] as Map<String, dynamic>),
      boutResult: $enumDecode(_$BoutResultEnumMap, json['boutResult']),
      style: $enumDecodeNullable(_$WrestlingStyleEnumMap, json['style']),
      winnerTechnicalPoints: (json['winnerTechnicalPoints'] as num?)?.toInt(),
      loserTechnicalPoints: (json['loserTechnicalPoints'] as num?)?.toInt(),
      technicalPointsDifference: (json['technicalPointsDifference'] as num?)?.toInt(),
      winnerClassificationPoints: (json['winnerClassificationPoints'] as num).toInt(),
      loserClassificationPoints: (json['loserClassificationPoints'] as num).toInt(),
    );

Map<String, dynamic> _$BoutResultRuleToJson(_BoutResultRule instance) => <String, dynamic>{
      'id': instance.id,
      'boutConfig': instance.boutConfig.toJson(),
      'boutResult': _$BoutResultEnumMap[instance.boutResult]!,
      'style': _$WrestlingStyleEnumMap[instance.style],
      'winnerTechnicalPoints': instance.winnerTechnicalPoints,
      'loserTechnicalPoints': instance.loserTechnicalPoints,
      'technicalPointsDifference': instance.technicalPointsDifference,
      'winnerClassificationPoints': instance.winnerClassificationPoints,
      'loserClassificationPoints': instance.loserClassificationPoints,
    };

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

const _$WrestlingStyleEnumMap = {
  WrestlingStyle.free: 'free',
  WrestlingStyle.greco: 'greco',
};
