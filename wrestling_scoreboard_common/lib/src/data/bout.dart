import 'package:freezed_annotation/freezed_annotation.dart';

import '../../common.dart';

part 'bout.freezed.dart';
part 'bout.g.dart';

/// The bout between two persons, which are represented by a ParticipantStatus.
@freezed
class Bout with _$Bout implements DataObject, Organizational {
  const Bout._();

  const factory Bout({
    int? id,
    String? orgSyncId,
    Organization? organization,
    ParticipantState? r, // red
    ParticipantState? b, // blue
    WeightClass? weightClass,
    int? pool,
    BoutRole? winnerRole,
    BoutResult? result,
    @Default(Duration.zero) Duration duration,
  }) = _Bout;

  factory Bout.fromJson(Map<String, Object?> json) => _$BoutFromJson(json);

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      if (orgSyncId != null) 'org_sync_id': orgSyncId,
      if (organization != null) 'organization_id': organization?.id!,
      'red_id': r?.id!,
      'blue_id': b?.id!,
      'weight_class_id': weightClass?.id!,
      'winner_role': winnerRole?.name,
      'bout_result': result?.name,
      'duration_millis': duration.inMilliseconds,
    };
  }

  static Future<Bout> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final redId = e['red_id'] as int?;
    final blueId = e['blue_id'] as int?;
    final winner = e['winner_role'] as String?;
    final boutResult = e['bout_result'] as String?;
    final weightClassId = e['weight_class_id'] as int?;
    final durationMillis = e['duration_millis'] as int?;
    final organizationId = e['organization_id'] as int?;
    return Bout(
      id: e['id'] as int?,
      orgSyncId: e['org_sync_id'] as String?,
      organization: organizationId == null ? null : await getSingle<Organization>(organizationId),
      r: redId == null ? null : await getSingle<ParticipantState>(redId),
      b: blueId == null ? null : await getSingle<ParticipantState>(blueId),
      weightClass: weightClassId == null ? null : await getSingle<WeightClass>(weightClassId),
      winnerRole: winner == null ? null : BoutRole.values.byName(winner),
      result: boutResult == null ? null : BoutResult.values.byName(boutResult),
      duration: durationMillis == null ? Duration() : Duration(milliseconds: durationMillis),
    );
  }

  Bout updateClassificationPoints(
    List<BoutAction> actions, {
    required List<BoutResultRule> rules,
  }) {
    if (result != null && winnerRole != null) {
      final resultRule = BoutConfig.resultRule(
        result: result!,
        style: weightClass?.style ?? WrestlingStyle.free,
        technicalPointsWinner: ParticipantState.getTechnicalPoints(actions, winnerRole!),
        technicalPointsLoser:
            ParticipantState.getTechnicalPoints(actions, winnerRole == BoutRole.red ? BoutRole.blue : BoutRole.red),
        rules: rules,
      );

      if (resultRule == null) {
        throw Exception('No bout result rule found for $result');
      }

      return copyWith(
        r: r?.copyWith(
          classificationPoints:
              winnerRole == BoutRole.red ? resultRule.winnerClassificationPoints : resultRule.loserClassificationPoints,
        ),
        b: b?.copyWith(
          classificationPoints: winnerRole == BoutRole.blue
              ? resultRule.winnerClassificationPoints
              : resultRule.loserClassificationPoints,
        ),
      );
    } else {
      return copyWith(
        r: r?.copyWith(classificationPoints: null),
        b: b?.copyWith(classificationPoints: null),
      );
    }
  }

  bool equalDuringBout(o) =>
      o is Bout &&
      o.runtimeType == runtimeType &&
      (r?.equalDuringBout(o.r) ?? (r == null && o.r == null)) &&
      (b?.equalDuringBout(o.b) ?? (b == null && o.b == null)) &&
      weightClass == o.weightClass;

  @override
  String get tableName => 'bout';

  @override
  Bout copyWithId(int? id) {
    return copyWith(id: id);
  }

  static Set<String> searchableAttributes = {};

  static Map<String, Type> searchableForeignAttributeMapping = {
    'red_id': ParticipantState,
    'blue_id': ParticipantState,
  };
}
