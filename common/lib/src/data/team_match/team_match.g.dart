// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamMatch _$TeamMatchFromJson(Map<String, dynamic> json) {
  return TeamMatch(
    id: json['id'] as int?,
    home: Lineup.fromJson(json['home'] as Map<String, dynamic>),
    guest: Lineup.fromJson(json['guest'] as Map<String, dynamic>),
    ex_weightClasses: (json['ex_weightClasses'] as List<dynamic>)
        .map((e) => WeightClass.fromJson(e as Map<String, dynamic>))
        .toList(),
    ex_referees: (json['ex_referees'] as List<dynamic>)
        .map((e) => Person.fromJson(e as Map<String, dynamic>))
        .toList(),
    no: json['no'] as String?,
    location: json['location'] as String?,
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
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
    ..league = League.fromJson(json['league'] as Map<String, dynamic>)
    ..maxRounds = json['maxRounds'] as int;
}

Map<String, dynamic> _$TeamMatchToJson(TeamMatch instance) => <String, dynamic>{
      'id': instance.id,
      'ex_referees': instance.ex_referees.map((e) => e.toJson()).toList(),
      'ex_tanscriptWriters':
          instance.ex_tanscriptWriters.map((e) => e.toJson()).toList(),
      'ex_timeKeepers': instance.ex_timeKeepers.map((e) => e.toJson()).toList(),
      'ex_matPresidents':
          instance.ex_matPresidents.map((e) => e.toJson()).toList(),
      'ex_stewards': instance.ex_stewards.map((e) => e.toJson()).toList(),
      'date': instance.date?.toIso8601String(),
      'no': instance.no,
      'location': instance.location,
      'visitorsCount': instance.visitorsCount,
      'comment': instance.comment,
      'ex_fights': instance.ex_fights.map((e) => e.toJson()).toList(),
      'ex_weightClasses':
          instance.ex_weightClasses.map((e) => e.toJson()).toList(),
      'league': instance.league.toJson(),
      'maxRounds': instance.maxRounds,
      'home': instance.home.toJson(),
      'guest': instance.guest.toJson(),
    };
