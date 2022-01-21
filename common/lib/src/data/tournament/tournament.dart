import 'package:json_annotation/json_annotation.dart';

import '../fight.dart';
import '../lineup.dart';
import '../person.dart';
import '../weight_class.dart';
import '../wrestling_event.dart';

part 'tournament.g.dart';

/// For team matches only.
@JsonSerializable()
class Tournament extends WrestlingEvent {
  final String name;

  @override
  Duration roundDuration = Duration(minutes: 3);

  @override
  Duration breakDuration = Duration(seconds: 30);

  @override
  Duration activityDuration = Duration(seconds: 30);

  @override
  Duration injuryDuration = Duration(seconds: 30);

  @override
  int maxRounds = 2;

  Tournament({
    int? id,
    required this.name,
    required List<Lineup> lineups,
    required List<WeightClass> weightClasses,
    required List<Person> referees,
    String? location,
    DateTime? date,
    int? visitorsCount,
    String? comment,
  }) : super(
          id: id,
          lineups: lineups,
          referees: referees,
          location: location,
          date: date,
          weightClasses: weightClasses,
          comment: comment,
          visitorsCount: visitorsCount,
        );

  factory Tournament.fromJson(Map<String, dynamic> json) => _$TournamentFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TournamentToJson(this);

  @override
  Map<String, dynamic> toRaw() {
    return super.toRaw()..addAll({
      if (id != null) 'id': id,
      'name': name,
    });
  }
}
