import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/fight_result.dart';
import '../enums/fight_role.dart';
import 'data_object.dart';
import 'fight_action.dart';
import 'participant_state.dart';
import 'weight_class.dart';

part 'fight.freezed.dart';
part 'fight.g.dart';

/// The fight between two persons, which are represented by a ParticipantStatus.
@freezed
class Fight with _$Fight implements DataObject {
  const Fight._();

  const factory Fight({
    int? id,
    ParticipantState? r, // red
    ParticipantState? b, // blue
    required WeightClass weightClass,
    int? pool,
    FightRole? winnerRole,
    FightResult? result,
    @Default(Duration.zero) Duration duration,
  }) = _Fight;

  factory Fight.fromJson(Map<String, Object?> json) => _$FightFromJson(json);

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'red_id': r?.id,
      'blue_id': b?.id,
      'weight_class_id': weightClass.id,
      'winner_role': winnerRole?.name,
      'fight_result': result?.name,
      'duration_millis': duration.inMilliseconds,
    };
  }

  static Future<Fight> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final redId = e['red_id'] as int?;
    final blueId = e['blue_id'] as int?;
    final winner = e['winner_role'] as String?;
    final fightResult = e['fight_result'] as String?;
    final weightClass = await getSingle<WeightClass>(e['weight_class_id'] as int);
    final durationMillis = e['duration_millis'] as int?;
    return Fight(
      id: e['id'] as int?,
      r: redId == null ? null : await getSingle<ParticipantState>(redId),
      b: blueId == null ? null : await getSingle<ParticipantState>(blueId),
      weightClass: weightClass!,
      winnerRole: winner == null ? null : FightRoleParser.valueOf(winner),
      result: fightResult == null ? null : FightResultParser.valueOf(fightResult),
      duration: durationMillis == null ? Duration() : Duration(milliseconds: durationMillis),
    );
  }

  void updateClassificationPoints(List<FightAction> actions, {bool isTournament = false}) {
    if (result != null && winnerRole != null) {
      var winner = winnerRole == FightRole.red ? r : b;
      var looser = winnerRole == FightRole.red ? b : r;

      if (winner != null) {
        winner.classificationPoints = isTournament
            ? getClassificationPointsWinnerTournament(result!)
            : getClassificationPointsWinnerTeamMatch(
                result!,
                ParticipantState.getTechnicalPoints(actions, winnerRole!) -
                    ParticipantState.getTechnicalPoints(
                        actions, winnerRole == FightRole.red ? FightRole.blue : FightRole.red));
      }

      if (looser != null) {
        looser.classificationPoints = isTournament
            ? getClassificationPointsLooserTournament(result!)
            : getClassificationPointsLooserTeamMatch(result!);
      }
    } else {
      r?.classificationPoints = null;
      b?.classificationPoints = null;
    }
  }

  bool equalDuringFight(o) =>
      o is Fight &&
      o.runtimeType == runtimeType &&
      (r?.equalDuringFight(o.r) ?? (r == null && o.r == null)) &&
      (b?.equalDuringFight(o.b) ?? (b == null && o.b == null)) &&
      weightClass == o.weightClass;

  @override
  String get tableName => 'fight';

  static int getClassificationPointsWinnerTournament(FightResult result) {
    switch (result) {
      case FightResult.vfa:
      case FightResult.vin:
      case FightResult.vca:
      case FightResult.vfo:
      case FightResult.dsq:
        return 5;
      case FightResult.vsu:
      case FightResult.vsu1:
        return 4;
      case FightResult.vpo:
      case FightResult.vpo1:
        return 3;
      case FightResult.dsq2:
      default:
        return 0;
    }
  }

  static int getClassificationPointsLooserTournament(FightResult result) {
    switch (result) {
      case FightResult.vsu1:
      case FightResult.vpo1:
        return 1;
      case FightResult.vfa:
      case FightResult.vin:
      case FightResult.vca:
      case FightResult.vfo:
      case FightResult.vsu:
      case FightResult.vpo:
      case FightResult.dsq:
      case FightResult.dsq2:
      default:
        return 0;
    }
  }

  static int getClassificationPointsWinnerTeamMatch(FightResult result, int diff) {
    switch (result) {
      case FightResult.vfa:
      case FightResult.vin:
      case FightResult.vca:
      case FightResult.vfo:
      case FightResult.dsq:
      case FightResult.vsu:
      case FightResult.vsu1:
        return 4;
      case FightResult.vpo:
      case FightResult.vpo1:
        return diff >= 8 ? 3 : (diff >= 3 ? 2 : 1);
      case FightResult.dsq2:
      default:
        return 0;
    }
  }

  static int getClassificationPointsLooserTeamMatch(FightResult result) {
    switch (result) {
      case FightResult.vfa:
      case FightResult.vin:
      case FightResult.vca:
      case FightResult.vfo:
      case FightResult.dsq:
      case FightResult.vsu:
      case FightResult.vsu1:
      case FightResult.vpo:
      case FightResult.vpo1:
      case FightResult.dsq2:
      default:
        return 0;
    }
  }
}
