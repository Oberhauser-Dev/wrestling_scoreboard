// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CompetitionImpl _$$CompetitionImplFromJson(Map<String, dynamic> json) =>
    _$CompetitionImpl(
      id: json['id'] as int?,
      name: json['name'] as String,
      boutConfig:
          BoutConfig.fromJson(json['boutConfig'] as Map<String, dynamic>),
      location: json['location'] as String?,
      date: DateTime.parse(json['date'] as String),
      no: json['no'] as String?,
      visitorsCount: json['visitorsCount'] as int?,
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$$CompetitionImplToJson(_$CompetitionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'boutConfig': instance.boutConfig.toJson(),
      'location': instance.location,
      'date': instance.date.toIso8601String(),
      'no': instance.no,
      'visitorsCount': instance.visitorsCount,
      'comment': instance.comment,
    };
