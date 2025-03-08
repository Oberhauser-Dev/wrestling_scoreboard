// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'age_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AgeCategory _$AgeCategoryFromJson(Map<String, dynamic> json) => _AgeCategory(
      id: (json['id'] as num?)?.toInt(),
      orgSyncId: json['orgSyncId'] as String?,
      organization: json['organization'] == null
          ? null
          : Organization.fromJson(json['organization'] as Map<String, dynamic>),
      name: json['name'] as String,
      minAge: (json['minAge'] as num).toInt(),
      maxAge: (json['maxAge'] as num).toInt(),
    );

Map<String, dynamic> _$AgeCategoryToJson(_AgeCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orgSyncId': instance.orgSyncId,
      'organization': instance.organization?.toJson(),
      'name': instance.name,
      'minAge': instance.minAge,
      'maxAge': instance.maxAge,
    };
