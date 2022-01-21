// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wrestling_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WrestlingEvent _$WrestlingEventFromJson(Map<String, dynamic> json) {
  return WrestlingEvent(
    id: json['id'] as int?,
    no: json['no'] as String?,
    ex_lineups: (json['ex_lineups'] as List<dynamic>)
        .map((e) => Lineup.fromJson(e as Map<String, dynamic>))
        .toList(),
    ex_referees: (json['ex_referees'] as List<dynamic>)
        .map((e) => Person.fromJson(e as Map<String, dynamic>))
        .toList(),
    location: json['location'] as String?,
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
    ex_weightClasses: (json['ex_weightClasses'] as List<dynamic>)
        .map((e) => WeightClass.fromJson(e as Map<String, dynamic>))
        .toList(),
    visitorsCount: json['visitorsCount'] as int?,
    comment: json['comment'] as String?,
  )
    ..ex_tanscriptWriters = (json['ex_tanscriptWriters'] as List<dynamic>)
        .map((e) => Person.fromJson(e as Map<String, dynamic>))
    ..ex_timeKeepers = (json['ex_timeKeepers'] as List<dynamic>)
        .map((e) => Person.fromJson(e as Map<String, dynamic>))
    ..ex_matPresidents = (json['ex_matPresidents'] as List<dynamic>)
        .map((e) => Person.fromJson(e as Map<String, dynamic>))
    ..ex_stewards = (json['ex_stewards'] as List<dynamic>)
        .map((e) => Person.fromJson(e as Map<String, dynamic>))
    ..ex_fights = (json['ex_fights'] as List<dynamic>)
        .map((e) => Fight.fromJson(e as Map<String, dynamic>))
        .toList()
    ..maxRounds = json['maxRounds'] as int;
}

Map<String, dynamic> _$WrestlingEventToJson(WrestlingEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ex_lineups': instance.ex_lineups,
      'ex_referees': instance.ex_referees,
      'ex_tanscriptWriters': instance.ex_tanscriptWriters.toList(),
      'ex_timeKeepers': instance.ex_timeKeepers.toList(),
      'ex_matPresidents': instance.ex_matPresidents.toList(),
      'ex_stewards': instance.ex_stewards.toList(),
      'date': instance.date?.toIso8601String(),
      'no': instance.no,
      'location': instance.location,
      'visitorsCount': instance.visitorsCount,
      'comment': instance.comment,
      'ex_fights': instance.ex_fights,
      'maxRounds': instance.maxRounds,
      'ex_weightClasses': instance.ex_weightClasses,
    };
