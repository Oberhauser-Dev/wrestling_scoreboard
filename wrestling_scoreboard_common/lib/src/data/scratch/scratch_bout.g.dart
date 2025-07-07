// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scratch_bout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScratchBout _$ScratchBoutFromJson(Map<String, dynamic> json) => _ScratchBout(
  id: (json['id'] as num?)?.toInt(),
  bout: Bout.fromJson(json['bout'] as Map<String, dynamic>),
  weightClass: WeightClass.fromJson(json['weightClass'] as Map<String, dynamic>),
  boutConfig: BoutConfig.fromJson(json['boutConfig'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ScratchBoutToJson(_ScratchBout instance) => <String, dynamic>{
  'id': instance.id,
  'bout': instance.bout.toJson(),
  'weightClass': instance.weightClass.toJson(),
  'boutConfig': instance.boutConfig.toJson(),
};
