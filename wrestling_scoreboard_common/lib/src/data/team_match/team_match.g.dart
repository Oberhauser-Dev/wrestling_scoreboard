// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TeamMatch _$TeamMatchFromJson(Map<String, dynamic> json) => _TeamMatch(
  id: (json['id'] as num?)?.toInt(),
  orgSyncId: json['orgSyncId'] as String?,
  organization:
      json['organization'] == null ? null : Organization.fromJson(json['organization'] as Map<String, dynamic>),
  home: TeamLineup.fromJson(json['home'] as Map<String, dynamic>),
  guest: TeamLineup.fromJson(json['guest'] as Map<String, dynamic>),
  league: json['league'] == null ? null : League.fromJson(json['league'] as Map<String, dynamic>),
  seasonPartition: (json['seasonPartition'] as num?)?.toInt(),
  no: json['no'] as String?,
  location: json['location'] as String?,
  date: DateTime.parse(json['date'] as String),
  endDate: json['endDate'] == null ? null : DateTime.parse(json['endDate'] as String),
  visitorsCount: (json['visitorsCount'] as num?)?.toInt(),
  comment: json['comment'] as String?,
);

Map<String, dynamic> _$TeamMatchToJson(_TeamMatch instance) => <String, dynamic>{
  'id': instance.id,
  'orgSyncId': instance.orgSyncId,
  'organization': instance.organization?.toJson(),
  'home': instance.home.toJson(),
  'guest': instance.guest.toJson(),
  'league': instance.league?.toJson(),
  'seasonPartition': instance.seasonPartition,
  'no': instance.no,
  'location': instance.location,
  'date': instance.date.toIso8601String(),
  'endDate': instance.endDate?.toIso8601String(),
  'visitorsCount': instance.visitorsCount,
  'comment': instance.comment,
};
