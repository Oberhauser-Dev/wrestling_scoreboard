// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BackupRule _$BackupRuleFromJson(Map<String, dynamic> json) => _BackupRule(
  name: json['name'] as String,
  period: Duration(microseconds: (json['period'] as num).toInt()),
  deleteAfter: Duration(microseconds: (json['deleteAfter'] as num).toInt()),
);

Map<String, dynamic> _$BackupRuleToJson(_BackupRule instance) => <String, dynamic>{
  'name': instance.name,
  'period': instance.period.inMicroseconds,
  'deleteAfter': instance.deleteAfter.inMicroseconds,
};
