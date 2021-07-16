import '../data.dart';

class WrestlingEvent extends DataObject {
  final List<Lineup> lineups;
  final List<Person> referees;
  List<Person> transcriptWriters = [];
  List<Person> timeKeepers = [];
  List<Person> matPresidents = [];
  List<Person> stewards = [];
  DateTime? date;
  String? location;
  int visitorsCount = 0;
  String comment = '';
  List<Fight>? fights;
  final Duration roundDuration = Duration(minutes: 3);
  final Duration breakDuration = Duration(seconds: 30);
  final Duration activityDuration = Duration(seconds: 30);
  final Duration injuryDuration = Duration(seconds: 30);
  int maxRounds = 2;
  List<WeightClass> weightClasses;

  WrestlingEvent(
      {int? id, required this.lineups, required this.referees, this.location, this.date, this.weightClasses = const []})
      : super(id) {
    date ??= DateTime.now();
  }
}
