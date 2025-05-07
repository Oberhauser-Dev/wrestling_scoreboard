// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'migration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Migration _$MigrationFromJson(Map<String, dynamic> json) =>
    _Migration(semver: json['semver'] as String, minClientVersion: json['minClientVersion'] as String);

Map<String, dynamic> _$MigrationToJson(_Migration instance) => <String, dynamic>{
  'semver': instance.semver,
  'minClientVersion': instance.minClientVersion,
};
