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
  Person? referee;
  Person? judge;
  Person? matChairman;
  Person? timeKeeper;
  Person? transcriptWriter;

  // TODO add missing stewards to extra table

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

  Lineup home;

  Lineup guest;

  TeamMatch({
    int? id,
    required this.home,
    required this.guest,
    this.matChairman,
    this.referee,
    this.judge,
    this.timeKeeper,
    this.transcriptWriter,
    String? no,
    String? location,
    DateTime? date,
    int? visitorsCount,
    String? comment,
  }) : super(
          id: id,
          no: no,
          location: location,
          date: date,
          comment: comment,
          visitorsCount: visitorsCount,
        ) {
    if (home.team.league == guest.team.league && home.team.league != null) {
      league = home.team.league!;
    } else {
      league = League.outOfCompetition;
    }
  }

  factory TeamMatch.fromJson(Map<String, dynamic> json) => _$TeamMatchFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TeamMatchToJson(this);

  static Future<TeamMatch> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final home = await getSingle<Lineup>(e['home_id'] as int);
    final guest = await getSingle<Lineup>(e['guest_id'] as int);
    final int? refereeId = e['referee_id'];
    final int? matChairmanId = e['mat_chairman_id'];
    final int? judgeId = e['judge_id'];
    final int? timeKeeperId = e['time_keeper_id'];
    final int? transcriptWriterId = e['time_keeper_id'];
    // TODO ditch weightclasses, always handle at client
    // final weightClasses = home != null && home.team.league != null
    // ? await LeagueController().getWeightClasses(home.team.league!.id.toString())
    //     : await WeightClassController().getMany();
    // TODO may add weightclasses of both teams leagues

    return TeamMatch(
      id: e['id'] as int?,
      no: e['no'] as String?,
      location: e['location'] as String?,
      date: e['date'] as DateTime?,
      visitorsCount: e['visitors_count'] as int?,
      comment: e['comment'] as String?,
      home: home!,
      guest: guest!,
      referee: refereeId == null ? null : await getSingle<Person>(refereeId),
      matChairman: matChairmanId == null ? null : await getSingle<Person>(matChairmanId),
      judge: judgeId == null ? null : await getSingle<Person>(judgeId),
      transcriptWriter: transcriptWriterId == null ? null : await getSingle<Person>(transcriptWriterId),
      timeKeeper: timeKeeperId == null ? null : await getSingle<Person>(timeKeeperId),
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return super.toRaw()
      ..addAll({
        'home_id': home.id,
        'guest_id': guest.id,
        'referee_id': referee?.id,
        'judge_id': judge?.id,
        'mat_chairman': matChairman?.id,
        'transcript_writer': transcriptWriter?.id,
        'time_keeper': timeKeeper?.id,
      });
  }

  static int getHomePoints(List<Fight> fights) {
    var res = 0;
    for (final fight in fights) {
      res += fight.r?.classificationPoints ?? 0;
    }
    return res;
  }

  static int getGuestPoints(List<Fight> fights) {
    var res = 0;
    for (final fight in fights) {
      res += fight.b?.classificationPoints ?? 0;
    }
    return res;
  }

  @override
  Future<List<Fight>> generateFights(List<List<Participation>> teamParticipations, List<WeightClass> weightClasses) async {
    final fights = <Fight>[];
    if (teamParticipations.length != 2) throw 'TeamMatch must have exactly two lineups';
    for (final weightClass in weightClasses) {
      final homePartList = teamParticipations[0].where((el) => el.weightClass == weightClass);
      if (homePartList.length > 1) {
        throw Exception(
            'Home team has two or more participants in the same weight class ${weightClass.name}: ${homePartList.map((e) => e.membership.person.fullName).join(', ')}');
      }
      final guestPartList = teamParticipations[1].where((el) => (el.weightClass == weightClass));
      if (guestPartList.length > 1) {
        throw Exception(
            'Guest team has two or more participants in the same weight class ${weightClass.name}: ${guestPartList.map((e) => e.membership.person.fullName).join(', ')}');
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
    return fights;
  }
}
