// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'league.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeagueImpl _$$LeagueImplFromJson(Map<String, dynamic> json) => _$LeagueImpl(
      id: (json['id'] as num?)?.toInt(),
      orgSyncId: json['orgSyncId'] as String?,
      organization:
          json['organization'] == null ? null : Organization.fromJson(json['organization'] as Map<String, dynamic>),
      name: json['name'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      division: Division.fromJson(json['division'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$LeagueImplToJson(_$LeagueImpl instance) => <String, dynamic>{
      'id': instance.id,
      'orgSyncId': instance.orgSyncId,
      'organization': instance.organization?.toJson(),
      'name': instance.name,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'division': instance.division.toJson(),
    };
