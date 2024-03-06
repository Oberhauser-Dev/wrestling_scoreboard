import 'package:freezed_annotation/freezed_annotation.dart';

import '../data_object.dart';
import '../bout.dart';
import '../lineup.dart';
import '../participant_state.dart';
import '../participation.dart';
import '../person.dart';
import '../weight_class.dart';
import '../wrestling_event.dart';
import 'league.dart';

part 'team_match.freezed.dart';
part 'team_match.g.dart';

/// For team matches only.
@freezed
class TeamMatch extends WrestlingEvent with _$TeamMatch {
  // TODO add missing stewards to extra table
  const TeamMatch._();

  const factory TeamMatch({
    int? id,
    required Lineup home,
    required Lineup guest,
    League? league,
    int? seasonPartition,
    Person? matChairman,
    Person? referee,
    Person? judge,
    Person? timeKeeper,
    Person? transcriptWriter,
    String? no,
    String? location,
    required DateTime date,
    int? visitorsCount,
    String? comment,
  }) = _TeamMatch;

  factory TeamMatch.fromJson(Map<String, Object?> json) => _$TeamMatchFromJson(json);

  static Future<TeamMatch> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final home = await getSingle<Lineup>(e['home_id'] as int);
    final guest = await getSingle<Lineup>(e['guest_id'] as int);
    final int? refereeId = e['referee_id'];
    final int? matChairmanId = e['mat_chairman_id'];
    final int? judgeId = e['judge_id'];
    final int? timeKeeperId = e['time_keeper_id'];
    final int? transcriptWriterId = e['transcript_writer_id'];
    final int? leagueId = e['league_id'];
    // TODO ditch weightclasses, always handle at client
    // final weightClasses = home != null && home.team.league != null
    // ? await LeagueController().getWeightClasses(home.team.league!.id.toString())
    //     : await WeightClassController().getMany();
    // TODO may add weightclasses of both teams leagues

    return TeamMatch(
      id: e['id'] as int?,
      no: e['no'] as String?,
      location: e['location'] as String?,
      date: e['date'] as DateTime,
      visitorsCount: e['visitors_count'] as int?,
      comment: e['comment'] as String?,
      home: home,
      guest: guest,
      referee: refereeId == null ? null : await getSingle<Person>(refereeId),
      matChairman: matChairmanId == null ? null : await getSingle<Person>(matChairmanId),
      judge: judgeId == null ? null : await getSingle<Person>(judgeId),
      transcriptWriter: transcriptWriterId == null ? null : await getSingle<Person>(transcriptWriterId),
      timeKeeper: timeKeeperId == null ? null : await getSingle<Person>(timeKeeperId),
      league: leagueId == null ? null : await getSingle<League>(leagueId),
      seasonPartition: e['season_partition'] as int?,
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return super.toRaw()
      ..addAll({
        'home_id': home.id,
        'guest_id': guest.id,
        'league_id': league?.id,
        'season_partition': seasonPartition,
        'referee_id': referee?.id,
        'judge_id': judge?.id,
        'mat_chairman_id': matChairman?.id,
        'transcript_writer_id': transcriptWriter?.id,
        'time_keeper_id': timeKeeper?.id,
      });
  }

  static int getHomePoints(Iterable<Bout> bouts) {
    var res = 0;
    for (final bout in bouts) {
      res += bout.r?.classificationPoints ?? 0;
    }
    return res;
  }

  static int getGuestPoints(Iterable<Bout> bouts) {
    var res = 0;
    for (final bout in bouts) {
      res += bout.b?.classificationPoints ?? 0;
    }
    return res;
  }

  @override
  Future<List<Bout>> generateBouts(
      List<List<Participation>> teamParticipations, List<WeightClass> weightClasses) async {
    final bouts = <Bout>[];
    if (teamParticipations.length != 2) throw 'TeamMatch must have exactly two lineups';
    for (final weightClass in weightClasses) {
      final homePartList = teamParticipations[0].where((el) => el.weightClass == weightClass);
      if (homePartList.length > 1) {
        throw Exception(
            'Home team has two or more participants in the same weight class ${weightClass.suffix}: ${homePartList.map((e) => e.membership.person.fullName).join(', ')}');
      }
      final guestPartList = teamParticipations[1].where((el) => (el.weightClass == weightClass));
      if (guestPartList.length > 1) {
        throw Exception(
            'Guest team has two or more participants in the same weight class ${weightClass.suffix}: ${guestPartList.map((e) => e.membership.person.fullName).join(', ')}');
      }
      final red = homePartList.isNotEmpty ? homePartList.single : null;
      final blue = guestPartList.isNotEmpty ? guestPartList.single : null;

      var bout = Bout(
        r: red == null ? null : ParticipantState(participation: red),
        b: blue == null ? null : ParticipantState(participation: blue),
        weightClass: weightClass,
      );
      bouts.add(bout);
    }
    return bouts;
  }

  @override
  String get tableName => 'team_match';

  @override
  TeamMatch copyWithId(int? id) {
    return copyWith(id: id);
  }
}
