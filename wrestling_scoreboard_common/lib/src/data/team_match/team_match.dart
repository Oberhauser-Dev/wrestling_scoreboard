import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';

part 'team_match.freezed.dart';

part 'team_match.g.dart';

/// For team matches only.
@freezed
abstract class TeamMatch extends WrestlingEvent with _$TeamMatch {
  // TODO add missing stewards to extra table
  const TeamMatch._();

  /// The [seasonPartition] is started counting at 0.
  const factory TeamMatch({
    int? id,
    String? orgSyncId,
    Organization? organization,
    required TeamLineup home,
    required TeamLineup guest,
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
    final home = await getSingle<TeamLineup>(e['home_id'] as int);
    final guest = await getSingle<TeamLineup>(e['guest_id'] as int);
    final int? refereeId = e['referee_id'];
    final int? matChairmanId = e['mat_chairman_id'];
    final int? judgeId = e['judge_id'];
    final int? timeKeeperId = e['time_keeper_id'];
    final int? transcriptWriterId = e['transcript_writer_id'];
    final int? leagueId = e['league_id'];
    final organizationId = e['organization_id'] as int?;
    // TODO ditch weightclasses, always handle at client
    // final weightClasses = home != null && home.team.league != null
    // ? await LeagueController().getWeightClasses(home.team.league!.id.toString())
    //     : await WeightClassController().getMany();
    // TODO may add weightclasses of both teams leagues

    return TeamMatch(
      id: e['id'] as int?,
      orgSyncId: e['org_sync_id'] as String?,
      organization: organizationId == null ? null : await getSingle<Organization>(organizationId),
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
    return super.toRaw()..addAll({
      'home_id': home.id!,
      'guest_id': guest.id!,
      'league_id': league?.id!,
      'season_partition': seasonPartition,
      'referee_id': referee?.id!,
      'judge_id': judge?.id!,
      'mat_chairman_id': matChairman?.id!,
      'transcript_writer_id': transcriptWriter?.id!,
      'time_keeper_id': timeKeeper?.id!,
    });
  }

  static int getHomePoints(Iterable<TeamMatchBout> bouts) {
    return getClassificationPoints(bouts.map((tmb) => tmb.bout.r));
  }

  static int getGuestPoints(Iterable<TeamMatchBout> bouts) {
    return getClassificationPoints(bouts.map((tmb) => tmb.bout.b));
  }

  static int getClassificationPoints(Iterable<AthleteBoutState?> participationStates) {
    var res = 0;
    for (final state in participationStates) {
      res += state?.classificationPoints ?? 0;
    }
    return res;
  }

  Future<List<TeamMatchBout>> generateBouts(
    List<List<TeamLineupParticipation>> teamParticipations,
    List<WeightClass> weightClasses,
  ) async {
    final bouts = <TeamMatchBout>[];
    if (teamParticipations.length != 2) throw 'TeamMatch must have exactly two lineups';
    for (final weightClass in weightClasses) {
      final homePartList = teamParticipations[0].where((el) => el.weightClass == weightClass);
      if (homePartList.length > 1) {
        throw Exception(
          'Home team has two or more participants in the same weight class ${weightClass.suffix}: ${homePartList.map((e) => e.membership.person.fullName).join(', ')}',
        );
      }
      final guestPartList = teamParticipations[1].where((el) => (el.weightClass == weightClass));
      if (guestPartList.length > 1) {
        throw Exception(
          'Guest team has two or more participants in the same weight class ${weightClass.suffix}: ${guestPartList.map((e) => e.membership.person.fullName).join(', ')}',
        );
      }
      final red = homePartList.isNotEmpty ? homePartList.single : null;
      final blue = guestPartList.isNotEmpty ? guestPartList.single : null;

      final bout = TeamMatchBout(
        organization: organization,
        teamMatch: this,
        pos: bouts.length,
        bout: Bout(
          r: red == null ? null : AthleteBoutState(membership: red.membership),
          b: blue == null ? null : AthleteBoutState(membership: blue.membership),
        ),
        weightClass: weightClass,
      );
      bouts.add(bout);
    }
    return bouts;
  }

  @override
  @override
  String get tableName => cTableName;
  static const cTableName = 'team_match';

  @override
  TeamMatch copyWithId(int? id) {
    return copyWith(id: id);
  }

  static BoutConfig defaultBoutConfig = BoutConfig(
    periodDuration: Duration(minutes: 3),
    breakDuration: Duration(seconds: 30),
    activityDuration: Duration(seconds: 30),
    injuryDuration: Duration(minutes: 2),
    periodCount: 2,
  );

  static List<BoutResultRule> defaultBoutResultRules = [
    BoutResultRule(
      boutConfig: defaultBoutConfig,
      boutResult: BoutResult.vfa,
      winnerClassificationPoints: 4,
      loserClassificationPoints: 0,
    ),
    BoutResultRule(
      boutConfig: defaultBoutConfig,
      boutResult: BoutResult.vin,
      winnerClassificationPoints: 4,
      loserClassificationPoints: 0,
    ),
    BoutResultRule(
      boutConfig: defaultBoutConfig,
      boutResult: BoutResult.vca,
      winnerClassificationPoints: 4,
      loserClassificationPoints: 0,
    ),
    BoutResultRule(
      boutConfig: defaultBoutConfig,
      boutResult: BoutResult.vsu,
      technicalPointsDifference: 15,
      winnerClassificationPoints: 4,
      loserClassificationPoints: 0,
    ),
    BoutResultRule(
      boutConfig: defaultBoutConfig,
      boutResult: BoutResult.vpo,
      technicalPointsDifference: 8,
      winnerClassificationPoints: 3,
      loserClassificationPoints: 0,
    ),
    BoutResultRule(
      boutConfig: defaultBoutConfig,
      boutResult: BoutResult.vpo,
      technicalPointsDifference: 3,
      winnerClassificationPoints: 2,
      loserClassificationPoints: 0,
    ),
    BoutResultRule(
      boutConfig: defaultBoutConfig,
      boutResult: BoutResult.vpo,
      technicalPointsDifference: 1,
      winnerClassificationPoints: 1,
      loserClassificationPoints: 0,
    ),
    BoutResultRule(
      boutConfig: defaultBoutConfig,
      boutResult: BoutResult.vfo,
      winnerClassificationPoints: 4,
      loserClassificationPoints: 0,
    ),
    BoutResultRule(
      boutConfig: defaultBoutConfig,
      boutResult: BoutResult.dsq,
      winnerClassificationPoints: 4,
      loserClassificationPoints: 0,
    ),
    BoutResultRule(
      boutConfig: defaultBoutConfig,
      boutResult: BoutResult.bothDsq,
      winnerClassificationPoints: 0,
      loserClassificationPoints: 0,
    ),
    BoutResultRule(
      boutConfig: defaultBoutConfig,
      boutResult: BoutResult.bothVfo,
      winnerClassificationPoints: 0,
      loserClassificationPoints: 0,
    ),
    BoutResultRule(
      boutConfig: defaultBoutConfig,
      boutResult: BoutResult.bothVin,
      winnerClassificationPoints: 0,
      loserClassificationPoints: 0,
    ),
  ];
}
