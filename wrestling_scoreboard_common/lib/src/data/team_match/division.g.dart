// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'division.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DivisionImpl _$$DivisionImplFromJson(Map<String, dynamic> json) => _$DivisionImpl(
      id: json['id'] as int?,
      orgSyncId: json['orgSyncId'] as String?,
      organization: Organization.fromJson(json['organization'] as Map<String, dynamic>),
      name: json['name'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      boutConfig: BoutConfig.fromJson(json['boutConfig'] as Map<String, dynamic>),
      seasonPartitions: json['seasonPartitions'] as int,
      parent: json['parent'] == null ? null : Division.fromJson(json['parent'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$DivisionImplToJson(_$DivisionImpl instance) => <String, dynamic>{
      'id': instance.id,
      'orgSyncId': instance.orgSyncId,
      'organization': instance.organization.toJson(),
      'name': instance.name,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'boutConfig': instance.boutConfig.toJson(),
      'seasonPartitions': instance.seasonPartitions,
      'parent': instance.parent?.toJson(),
    };
