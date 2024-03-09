// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrganizationImpl _$$OrganizationImplFromJson(Map<String, dynamic> json) => _$OrganizationImpl(
      id: json['id'] as int?,
      name: json['name'] as String,
      abbreviation: json['abbreviation'] as String?,
      parent: json['parent'] == null ? null : Organization.fromJson(json['parent'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$OrganizationImplToJson(_$OrganizationImpl instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'abbreviation': instance.abbreviation,
      'parent': instance.parent?.toJson(),
    };
