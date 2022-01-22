import 'package:json_annotation/json_annotation.dart';

import '../data.dart';

part 'wrestling_event.g.dart';

@JsonSerializable()
abstract class WrestlingEvent extends DataObject {
  final List<Lineup> ex_lineups;
  final List<Person> ex_referees;
  Iterable<Person> ex_tanscriptWriters = [];
  Iterable<Person> ex_timeKeepers = [];
  Iterable<Person> ex_matPresidents = [];
  Iterable<Person> ex_stewards = [];
  DateTime? date;

  /// competitionId (CID), eventId, matchId or Kampf-Id
  String? no;

  String? location;
  int? visitorsCount;
  String? comment;
  List<Fight> ex_fights = [];
  final Duration roundDuration = Duration(minutes: 3);
  final Duration breakDuration = Duration(seconds: 30);
  final Duration activityDuration = Duration(seconds: 30);
  final Duration injuryDuration = Duration(seconds: 30);
  int maxRounds = 2;
  List<WeightClass> ex_weightClasses;

  WrestlingEvent(
      {int? id,
      this.no,
      required this.ex_lineups,
      required this.ex_referees,
      this.location,
      this.date,
      this.ex_weightClasses = const [],
      this.visitorsCount,
      this.comment})
      : super(id) {
    date ??= DateTime.now();
  }

  Future<void> generateFights(List<List<Participation>> teamParticipations);

  factory WrestlingEvent.fromJson(Map<String, dynamic> json) => _$WrestlingEventFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WrestlingEventToJson(this);

  // static Future<WrestlingEvent> fromRaw(Map<String, dynamic> e) async => WrestlingEvent(
  //       id: e['id'] as int?,
  //       ex_lineups: [],
  //       ex_weightClasses: [],
  //       ex_referees: [],
  //       location: e['location'] as String?,
  //       date: e['date'] as DateTime?,
  //       visitorsCount: e['visitors_count'] as int?,
  //       comment: e['comment'] as String?,
  //     );

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'no': no,
      'location': location,
      'date': date,
      'visitors_count': visitorsCount,
      'comment': comment,
    };
  }
}
