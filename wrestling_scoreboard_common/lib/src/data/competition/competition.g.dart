// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Competition _$CompetitionFromJson(Map<String, dynamic> json) => _Competition(
      id: (json['id'] as num?)?.toInt(),
      orgSyncId: json['orgSyncId'] as String?,
      organization: json['organization'] == null
          ? null
          : Organization.fromJson(json['organization'] as Map<String, dynamic>),
      name: json['name'] as String,
      boutConfig:
          BoutConfig.fromJson(json['boutConfig'] as Map<String, dynamic>),
      location: json['location'] as String?,
      date: DateTime.parse(json['date'] as String),
      no: json['no'] as String?,
      visitorsCount: (json['visitorsCount'] as num?)?.toInt(),
      comment: json['comment'] as String?,
      matCount: (json['matCount'] as num).toInt(),
    );

Map<String, dynamic> _$CompetitionToJson(_Competition instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orgSyncId': instance.orgSyncId,
      'organization': instance.organization?.toJson(),
      'name': instance.name,
      'boutConfig': instance.boutConfig.toJson(),
      'location': instance.location,
      'date': instance.date.toIso8601String(),
      'no': instance.no,
      'visitorsCount': instance.visitorsCount,
      'comment': instance.comment,
      'matCount': instance.matCount,
    };
