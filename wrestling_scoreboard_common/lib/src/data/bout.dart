import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/bout_result.dart';
import '../enums/bout_role.dart';
import 'data_object.dart';
import 'bout_action.dart';
import 'participant_state.dart';
import 'weight_class.dart';

part 'bout.freezed.dart';
part 'bout.g.dart';

/// The bout between two persons, which are represented by a ParticipantStatus.
@freezed
class Bout with _$Bout implements DataObject {
  const Bout._();

  const factory Bout({
    int? id,
    ParticipantState? r, // red
    ParticipantState? b, // blue
    required WeightClass weightClass,
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
      'red_id': r?.id,
      'blue_id': b?.id,
      'weight_class_id': weightClass.id,
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
    final weightClass = await getSingle<WeightClass>(e['weight_class_id'] as int);
    final durationMillis = e['duration_millis'] as int?;
    return Bout(
      id: e['id'] as int?,
      r: redId == null ? null : await getSingle<ParticipantState>(redId),
      b: blueId == null ? null : await getSingle<ParticipantState>(blueId),
      weightClass: weightClass!,
      winnerRole: winner == null ? null : BoutRoleParser.valueOf(winner),
      result: boutResult == null ? null : BoutResultParser.valueOf(boutResult),
      duration: durationMillis == null ? Duration() : Duration(milliseconds: durationMillis),
    );
  }

  Bout updateClassificationPoints(List<BoutAction> actions, {bool isTournament = false}) {
    if (result != null && winnerRole != null) {
      var winner = winnerRole == BoutRole.red ? r : b;
      var looser = winnerRole == BoutRole.red ? b : r;

      int? winnerClassificationPoints;
      int? looserClassificationPoints;
      if (winner != null) {
        winnerClassificationPoints = isTournament
            ? getClassificationPointsWinnerTournament(result!)
            : getClassificationPointsWinnerTeamMatch(
                result!,
                ParticipantState.getTechnicalPoints(actions, winnerRole!) -
                    ParticipantState.getTechnicalPoints(
                        actions, winnerRole == BoutRole.red ? BoutRole.blue : BoutRole.red));
      }

      if (looser != null) {
        looserClassificationPoints = isTournament
            ? getClassificationPointsLooserTournament(result!)
            : getClassificationPointsLooserTeamMatch(result!);
      }
      return copyWith(
        r: r?.copyWith(
          classificationPoints: winnerRole == BoutRole.red ? winnerClassificationPoints : looserClassificationPoints,
        ),
        b: b?.copyWith(
          classificationPoints: winnerRole == BoutRole.blue ? winnerClassificationPoints : looserClassificationPoints,
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

  static int getClassificationPointsWinnerTournament(BoutResult result) {
    switch (result) {
      case BoutResult.vfa:
      case BoutResult.vin:
      case BoutResult.vca:
      case BoutResult.vfo:
      case BoutResult.dsq:
        return 5;
      case BoutResult.vsu:
      case BoutResult.vsu1:
        return 4;
      case BoutResult.vpo:
      case BoutResult.vpo1:
        return 3;
      case BoutResult.dsq2:
      default:
        return 0;
    }
  }

  static int getClassificationPointsLooserTournament(BoutResult result) {
    switch (result) {
      case BoutResult.vsu1:
      case BoutResult.vpo1:
        return 1;
      case BoutResult.vfa:
      case BoutResult.vin:
      case BoutResult.vca:
      case BoutResult.vfo:
      case BoutResult.vsu:
      case BoutResult.vpo:
      case BoutResult.dsq:
      case BoutResult.dsq2:
      default:
        return 0;
    }
  }

  static int getClassificationPointsWinnerTeamMatch(BoutResult result, int diff) {
    switch (result) {
      case BoutResult.vfa:
      case BoutResult.vin:
      case BoutResult.vca:
      case BoutResult.vfo:
      case BoutResult.dsq:
      case BoutResult.vsu:
      case BoutResult.vsu1:
        return 4;
      case BoutResult.vpo:
      case BoutResult.vpo1:
        return diff >= 8 ? 3 : (diff >= 3 ? 2 : 1);
      case BoutResult.dsq2:
      default:
        return 0;
    }
  }

  static int getClassificationPointsLooserTeamMatch(BoutResult result) {
    switch (result) {
      case BoutResult.vfa:
      case BoutResult.vin:
      case BoutResult.vca:
      case BoutResult.vfo:
      case BoutResult.dsq:
      case BoutResult.vsu:
      case BoutResult.vsu1:
      case BoutResult.vpo:
      case BoutResult.vpo1:
      case BoutResult.dsq2:
      default:
        return 0;
    }
  }

  @override
  Bout copyWithId(int? id) {
    return copyWith(id: id);
  }
}
