import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';

part 'competition.freezed.dart';
part 'competition.g.dart';

/// For team matches only.
@freezed
class Competition extends WrestlingEvent with _$Competition {
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
      });
  }

  @override
  Future<List<Bout>> generateBouts(List<List<Participation>> teamParticipations, List<WeightClass> weightClasses) {
    // TODO: implement generateBouts
    throw UnimplementedError();
  }

  @override
  String get tableName => 'competition';

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
      boutResult: BoutResult.dsq2,
      winnerClassificationPoints: 0,
      loserClassificationPoints: 0,
    ),
  ];
}
