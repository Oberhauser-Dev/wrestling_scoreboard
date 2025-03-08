// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'league.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_League _$LeagueFromJson(Map<String, dynamic> json) => _League(
      id: (json['id'] as num?)?.toInt(),
      orgSyncId: json['orgSyncId'] as String?,
      organization: json['organization'] == null
          ? null
          : Organization.fromJson(json['organization'] as Map<String, dynamic>),
      name: json['name'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      division: Division.fromJson(json['division'] as Map<String, dynamic>),
      boutDays: (json['boutDays'] as num).toInt(),
    );

Map<String, dynamic> _$LeagueToJson(_League instance) => <String, dynamic>{
      'id': instance.id,
      'orgSyncId': instance.orgSyncId,
      'organization': instance.organization?.toJson(),
      'name': instance.name,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'division': instance.division.toJson(),
      'boutDays': instance.boutDays,
    };
