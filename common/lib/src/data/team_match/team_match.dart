import 'package:json_annotation/json_annotation.dart';

import '../fight.dart';
import '../league.dart';
import '../lineup.dart';
import '../person.dart';
import '../weight_class.dart';
import '../wrestling_event.dart';

part 'team_match.g.dart';

/// For team matches only.
@JsonSerializable()
class TeamMatch extends WrestlingEvent {
  final String? no;
  late League league; // Liga

  @override
  final Duration roundDuration = Duration(minutes: 3);

  @override
  final Duration breakDuration = Duration(seconds: 30);

  @override
  final Duration activityDuration = Duration(seconds: 30);

  @override
  final Duration injuryDuration = Duration(seconds: 30);

  @override
  int maxRounds = 2;

  TeamMatch(
      {int? id,
      required Lineup home,
      required Lineup guest,
      required List<WeightClass> weightClasses,
      required List<Person> referees,
      this.no,
      String? location,
      DateTime? date})
      : super(
          id: id,
          lineups: [home, guest],
          referees: referees,
          location: location,
          date: date,
          weightClasses: weightClasses,
        ) {
    if (home.team.league == guest.team.league && home.team.league != null) {
      league = home.team.league!;
    } else {
      league = League.outOfCompetition;
    }
  }

  Lineup get home => lineups[0];

  Lineup get guest => lineups[1];

  factory TeamMatch.fromJson(Map<String, dynamic> json) => _$TeamMatchFromJson(json);

  Map<String, dynamic> toJson() => _$TeamMatchToJson(this);

  int get homePoints {
    var res = 0;
    for (final fight in fights) {
      res += fight.r?.classificationPoints ?? 0;
    }
    return res;
  }

  int get guestPoints {
    var res = 0;
    for (final fight in fights) {
      res += fight.b?.classificationPoints ?? 0;
    }
    return res;
  }
}
