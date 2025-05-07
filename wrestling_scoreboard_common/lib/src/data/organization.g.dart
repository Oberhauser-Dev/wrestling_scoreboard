// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Organization _$OrganizationFromJson(Map<String, dynamic> json) => _Organization(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String,
  abbreviation: json['abbreviation'] as String?,
  parent: json['parent'] == null ? null : Organization.fromJson(json['parent'] as Map<String, dynamic>),
  apiProvider: $enumDecodeNullable(_$WrestlingApiProviderEnumMap, json['apiProvider']),
  reportProvider: $enumDecodeNullable(_$WrestlingReportProviderEnumMap, json['reportProvider']),
);

Map<String, dynamic> _$OrganizationToJson(_Organization instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'abbreviation': instance.abbreviation,
  'parent': instance.parent?.toJson(),
  'apiProvider': _$WrestlingApiProviderEnumMap[instance.apiProvider],
  'reportProvider': _$WrestlingReportProviderEnumMap[instance.reportProvider],
};

const _$WrestlingApiProviderEnumMap = {
  WrestlingApiProvider.deNwRingenApi: 'deNwRingenApi',
  WrestlingApiProvider.deByRingenApi: 'deByRingenApi',
};

const _$WrestlingReportProviderEnumMap = {WrestlingReportProvider.deNwRdb274: 'deNwRdb274'};
