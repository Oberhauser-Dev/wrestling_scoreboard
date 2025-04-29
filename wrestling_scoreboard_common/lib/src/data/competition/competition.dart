import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';

part 'competition.freezed.dart';

part 'competition.g.dart';

/// For team matches only.
@freezed
abstract class Competition extends WrestlingEvent with _$Competition {
  const Competition._();

  const factory Competition({
    int? id,
    String? orgSyncId,
    Organization? organization,
    required String name,
    required BoutConfig boutConfig,
    String? location,
    required DateTime date,
    String? no,
    int? visitorsCount,
    String? comment,
    required int matCount,

    /// The ranks which must be determined
    @Default(10) maxRanking,
  }) = _Competition;

  factory Competition.fromJson(Map<String, Object?> json) => _$CompetitionFromJson(json);

  static Future<Competition> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final boutConfig = await getSingle<BoutConfig>(e['bout_config_id'] as int);
    final organizationId = e['organization_id'] as int?;
    // TODO: fetch lineups, referees, weightClasses, etc.
    return Competition(
      id: e['id'] as int?,
      orgSyncId: e['org_sync_id'] as String?,
      organization: organizationId == null ? null : await getSingle<Organization>(organizationId),
      name: e['name'],
      location: e['location'] as String?,
      date: e['date'] as DateTime,
      visitorsCount: e['visitors_count'] as int?,
      matCount: e['mat_count'] as int,
      maxRanking: e['max_ranking'] as int,
      comment: e['comment'] as String?,
      boutConfig: boutConfig,
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return super.toRaw()
      ..addAll({
        'name': name,
        'bout_config_id': boutConfig.id!,
        'mat_count': matCount,
        'max_ranking': maxRanking,
      });
  }

  Future<List<CompetitionBout>> generateBouts(
      List<List<CompetitionParticipation>> teamParticipations, List<WeightClass> weightClasses) {
    // TODO: implement generateBouts
    throw UnimplementedError();
  }

  @override

  @override
  String get tableName => cTableName;
  static const cTableName = 'competition';

  @override
  Competition copyWithId(int? id) {
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
      winnerClassificationPoints: 5,
      loserClassificationPoints: 0,
    ),
    BoutResultRule(
      boutConfig: defaultBoutConfig,
      boutResult: BoutResult.vin,
      winnerClassificationPoints: 5,
      loserClassificationPoints: 0,
    ),
    BoutResultRule(
      boutConfig: defaultBoutConfig,
      boutResult: BoutResult.vca,
      winnerClassificationPoints: 5,
      loserClassificationPoints: 0,
    ),
    BoutResultRule(
      boutConfig: defaultBoutConfig,
      boutResult: BoutResult.vsu,
      style: WrestlingStyle.greco,
      technicalPointsDifference: 8,
      winnerClassificationPoints: 4,
      loserClassificationPoints: 0,
    ),
    BoutResultRule(
      boutConfig: defaultBoutConfig,
      boutResult: BoutResult.vsu,
      style: WrestlingStyle.free,
      technicalPointsDifference: 10,
      winnerClassificationPoints: 4,
      loserClassificationPoints: 0,
    ),
    BoutResultRule(
      boutConfig: defaultBoutConfig,
      boutResult: BoutResult.vsu,
      style: WrestlingStyle.greco,
      technicalPointsDifference: 8,
      loserTechnicalPoints: 1,
      winnerClassificationPoints: 4,
      loserClassificationPoints: 1,
    ),
    BoutResultRule(
      boutConfig: defaultBoutConfig,
      boutResult: BoutResult.vsu,
      style: WrestlingStyle.free,
      technicalPointsDifference: 10,
      loserTechnicalPoints: 1,
      winnerClassificationPoints: 4,
      loserClassificationPoints: 1,
    ),
    BoutResultRule(
      boutConfig: defaultBoutConfig,
      boutResult: BoutResult.vpo,
      technicalPointsDifference: 1,
      winnerClassificationPoints: 3,
      loserClassificationPoints: 0,
    ),
    BoutResultRule(
      boutConfig: defaultBoutConfig,
      boutResult: BoutResult.vpo,
      technicalPointsDifference: 1,
      loserTechnicalPoints: 1,
      winnerClassificationPoints: 3,
      loserClassificationPoints: 1,
    ),
    BoutResultRule(
      boutConfig: defaultBoutConfig,
      boutResult: BoutResult.vfo,
      winnerClassificationPoints: 5,
      loserClassificationPoints: 0,
    ),
    BoutResultRule(
      boutConfig: defaultBoutConfig,
      boutResult: BoutResult.dsq,
      winnerClassificationPoints: 5,
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
