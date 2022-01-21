import 'package:json_annotation/json_annotation.dart';

import '../data_object.dart';
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
  /// competitionId (CID), eventId, matchId or Kampf-Id
  // TODO move to wrestling event
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

  TeamMatch({
    int? id,
    required Lineup home,
    required Lineup guest,
    required List<WeightClass> weightClasses,
    required List<Person> referees,
    this.no,
    String? location,
    DateTime? date,
    int? visitorsCount,
    String? comment,
  }) : super(
          id: id,
          lineups: [home, guest],
          referees: referees,
          location: location,
          date: date,
          weightClasses: weightClasses,
          comment: comment,
          visitorsCount: visitorsCount,
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

  @override
  Map<String, dynamic> toJson() => _$TeamMatchToJson(this);

  static Future<TeamMatch> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final home = await getSingle<Lineup>(e['home_id'] as int);
    final guest = await getSingle<Lineup>(e['guest_id'] as int);
    final int? refereeId = e['referee_id'];
    // TODO need extra table for multiple referees.
    final List<Person> referees = refereeId != null ? [(await getSingle<Person>(refereeId))!] : [];
    // TODO ditch weightclasses, always handle at client
    // final weightClasses = home != null && home.team.league != null
    // ? await LeagueController().getWeightClasses(home.team.league!.id.toString())
    //     : await WeightClassController().getMany();
    // TODO may add weightclasses of both teams leagues

    return TeamMatch(
    id: e['id'] as int?,
    no: e['no'] as String?,
    home: home!,
    guest: guest!,
    weightClasses: [], // weightClasses
    referees: referees,
    location: e['location'] as String?,
    date: e['date'] as DateTime?,
    visitorsCount: e['visitors_count'] as int?,
    comment: e['comment'] as String?,
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return super.toRaw()
      ..addAll({
        'home_id': home.id,
        'guest_id': guest.id,
        'referee_id': referees.isNotEmpty ? referees.first.id : null,
      });
  }

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
