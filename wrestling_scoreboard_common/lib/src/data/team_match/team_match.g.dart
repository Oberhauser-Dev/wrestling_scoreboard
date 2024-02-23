// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TeamMatchImpl _$$TeamMatchImplFromJson(Map<String, dynamic> json) => _$TeamMatchImpl(
      id: json['id'] as int?,
      home: Lineup.fromJson(json['home'] as Map<String, dynamic>),
      guest: Lineup.fromJson(json['guest'] as Map<String, dynamic>),
      league: json['league'] == null ? null : League.fromJson(json['league'] as Map<String, dynamic>),
      matChairman: json['matChairman'] == null ? null : Person.fromJson(json['matChairman'] as Map<String, dynamic>),
      referee: json['referee'] == null ? null : Person.fromJson(json['referee'] as Map<String, dynamic>),
      judge: json['judge'] == null ? null : Person.fromJson(json['judge'] as Map<String, dynamic>),
      timeKeeper: json['timeKeeper'] == null ? null : Person.fromJson(json['timeKeeper'] as Map<String, dynamic>),
      transcriptWriter:
          json['transcriptWriter'] == null ? null : Person.fromJson(json['transcriptWriter'] as Map<String, dynamic>),
      no: json['no'] as String?,
      location: json['location'] as String?,
      date: DateTime.parse(json['date'] as String),
      visitorsCount: json['visitorsCount'] as int?,
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$$TeamMatchImplToJson(_$TeamMatchImpl instance) => <String, dynamic>{
      'id': instance.id,
      'home': instance.home.toJson(),
      'guest': instance.guest.toJson(),
      'league': instance.league?.toJson(),
      'matChairman': instance.matChairman?.toJson(),
      'referee': instance.referee?.toJson(),
      'judge': instance.judge?.toJson(),
      'timeKeeper': instance.timeKeeper?.toJson(),
      'transcriptWriter': instance.transcriptWriter?.toJson(),
      'no': instance.no,
      'location': instance.location,
      'date': instance.date.toIso8601String(),
      'visitorsCount': instance.visitorsCount,
      'comment': instance.comment,
    };
