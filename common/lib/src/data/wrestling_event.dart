import 'package:json_annotation/json_annotation.dart';

import '../data.dart';

part 'wrestling_event.g.dart';

@JsonSerializable()
class WrestlingEvent extends DataObject {
  final List<Lineup> lineups;
  final Iterable<Person> referees;
  Iterable<Person> transcriptWriters = [];
  Iterable<Person> timeKeepers = [];
  Iterable<Person> matPresidents = [];
  Iterable<Person> stewards = [];
  DateTime? date;
  String? no;
  String? location;
  int? visitorsCount;
  String? comment;
  List<Fight> fights = [];
  final Duration roundDuration = Duration(minutes: 3);
  final Duration breakDuration = Duration(seconds: 30);
  final Duration activityDuration = Duration(seconds: 30);
  final Duration injuryDuration = Duration(seconds: 30);
  int maxRounds = 2;
  List<WeightClass> weightClasses;

  WrestlingEvent(
      {int? id,
      required this.lineups,
      required this.referees,
      this.location,
      this.date,
      this.weightClasses = const [],
      this.visitorsCount,
      this.comment})
      : super(id) {
    date ??= DateTime.now();
  }

  Future<void> generateFights() {
    throw UnimplementedError('Base class does not support generating fights. Use TeamMatch or Tournament instead.');
  }

  factory WrestlingEvent.fromJson(Map<String, dynamic> json) => _$WrestlingEventFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WrestlingEventToJson(this);

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
