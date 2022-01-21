// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wrestling_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WrestlingEvent _$WrestlingEventFromJson(Map<String, dynamic> json) {
  return WrestlingEvent(
    id: json['id'] as int?,
    lineups: (json['lineups'] as List<dynamic>)
        .map((e) => Lineup.fromJson(e as Map<String, dynamic>))
        .toList(),
    referees: (json['referees'] as List<dynamic>)
        .map((e) => Person.fromJson(e as Map<String, dynamic>)),
    location: json['location'] as String?,
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
    weightClasses: (json['weightClasses'] as List<dynamic>)
        .map((e) => WeightClass.fromJson(e as Map<String, dynamic>))
        .toList(),
    visitorsCount: json['visitorsCount'] as int?,
    comment: json['comment'] as String?,
  )
    ..transcriptWriters = (json['transcriptWriters'] as List<dynamic>)
        .map((e) => Person.fromJson(e as Map<String, dynamic>))
    ..timeKeepers = (json['timeKeepers'] as List<dynamic>)
        .map((e) => Person.fromJson(e as Map<String, dynamic>))
    ..matPresidents = (json['matPresidents'] as List<dynamic>)
        .map((e) => Person.fromJson(e as Map<String, dynamic>))
    ..stewards = (json['stewards'] as List<dynamic>)
        .map((e) => Person.fromJson(e as Map<String, dynamic>))
    ..no = json['no'] as String?
    ..fights = (json['fights'] as List<dynamic>)
        .map((e) => Fight.fromJson(e as Map<String, dynamic>))
        .toList()
    ..maxRounds = json['maxRounds'] as int;
}

Map<String, dynamic> _$WrestlingEventToJson(WrestlingEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lineups': instance.lineups,
      'referees': instance.referees.toList(),
      'transcriptWriters': instance.transcriptWriters.toList(),
      'timeKeepers': instance.timeKeepers.toList(),
      'matPresidents': instance.matPresidents.toList(),
      'stewards': instance.stewards.toList(),
      'date': instance.date?.toIso8601String(),
      'no': instance.no,
      'location': instance.location,
      'visitorsCount': instance.visitorsCount,
      'comment': instance.comment,
      'fights': instance.fights,
      'maxRounds': instance.maxRounds,
      'weightClasses': instance.weightClasses,
    };
