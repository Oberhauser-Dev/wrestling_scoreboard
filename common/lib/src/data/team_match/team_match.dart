import 'package:json_annotation/json_annotation.dart';

import '../data_object.dart';
import '../fight.dart';
import '../league.dart';
import '../lineup.dart';
import '../participant_state.dart';
import '../participation.dart';
import '../person.dart';
import '../weight_class.dart';
import '../wrestling_event.dart';

part 'team_match.g.dart';

/// For team matches only.
@JsonSerializable()
class TeamMatch extends WrestlingEvent {
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
    required List<WeightClass> ex_weightClasses,
    required List<Person> ex_referees,
    String? no,
    String? location,
    DateTime? date,
    int? visitorsCount,
    String? comment,
  }) : super(
          id: id,
          no: no,
          ex_lineups: [home, guest],
          ex_referees: ex_referees,
          location: location,
          date: date,
          ex_weightClasses: ex_weightClasses,
          comment: comment,
          visitorsCount: visitorsCount,
        ) {
    if (home.team.league == guest.team.league && home.team.league != null) {
      league = home.team.league!;
    } else {
      league = League.outOfCompetition;
    }
  }

  Lineup get home => ex_lineups[0];

  Lineup get guest => ex_lineups[1];

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
    ex_weightClasses: [], // weightClasses
    ex_referees: referees,
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
        'referee_id': ex_referees.isNotEmpty ? ex_referees.first.id : null,
      });
  }

  int get homePoints {
    var res = 0;
    for (final fight in ex_fights) {
      res += fight.r?.classificationPoints ?? 0;
    }
    return res;
  }

  int get guestPoints {
    var res = 0;
    for (final fight in ex_fights) {
      res += fight.b?.classificationPoints ?? 0;
    }
    return res;
  }

  @override
  Future<void> generateFights(List<List<Participation>> teamParticipations) async {
    final fights = <Fight>[];
    if(teamParticipations.length != 2) throw 'TeamMatch must have exactly two lineups';
    for (final weightClass in ex_weightClasses) {
      final homePartList = teamParticipations[0].where((el) => el.weightClass == weightClass);
      if (homePartList.length > 1) {
        throw Exception(
            'Home team has two or more participants in the same weight class ${weightClass.name}: ${homePartList.map((
                e) => e.membership.person.fullName).join(', ')}');
      }
      final guestPartList = teamParticipations[1].where((el) => (el.weightClass == weightClass));
      if (guestPartList.length > 1) {
        throw Exception(
            'Guest team has two or more participants in the same weight class ${weightClass.name}: ${guestPartList.map((
                e) => e.membership.person.fullName).join(', ')}');
      }
      final red = homePartList.isNotEmpty ? homePartList.single : null;
      final blue = guestPartList.isNotEmpty ? guestPartList.single : null;

      var fight = Fight(
        r: red == null ? null : ParticipantState(participation: red),
        b: blue == null ? null : ParticipantState(participation: blue),
        weightClass: weightClass,
      );
      fights.add(fight);
    }
    ex_fights = fights;
  }
}
