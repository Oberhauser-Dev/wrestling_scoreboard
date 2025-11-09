// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApiMetadata _$ApiMetadataFromJson(Map<String, dynamic> json) => _ApiMetadata(
  entityId: (json['entityId'] as num).toInt(),
  entityType: json['entityType'] as String,
  lastImport: json['lastImport'] == null ? null : DateTime.parse(json['lastImport'] as String),
);

Map<String, dynamic> _$ApiMetadataToJson(_ApiMetadata instance) => <String, dynamic>{
  'entityId': instance.entityId,
  'entityType': instance.entityType,
  'lastImport': instance.lastImport?.toIso8601String(),
};
