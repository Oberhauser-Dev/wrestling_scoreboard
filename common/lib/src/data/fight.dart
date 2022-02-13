import 'package:json_annotation/json_annotation.dart';

import '../enums/fight_result.dart';
import '../enums/fight_role.dart';
import 'data_object.dart';
import 'fight_action.dart';
import 'participant_state.dart';
import 'weight_class.dart';

part 'fight.g.dart';

/// The fight between two persons, which are represented by a ParticipantStatus.
@JsonSerializable()
class Fight extends DataObject {
  ParticipantState? r; // red
  ParticipantState? b; // blue
  final WeightClass weightClass;
  final int? pool;
  FightResult? result;
  FightRole? winner;
  Duration duration;

  Fight(
      {int? id,
      this.r,
      this.b,
      required this.weightClass,
      this.pool,
      this.winner,
      this.result,
      this.duration = const Duration()})
      : super(id);

  factory Fight.fromJson(Map<String, dynamic> json) => _$FightFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FightToJson(this);

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'red_id': r?.id,
      'blue_id': b?.id,
      'weight_class_id': weightClass.id,
      'winner': winner?.name,
      'fight_result': result?.name,
      'duration_millis': duration.inMilliseconds,
    };
  }

  static Future<Fight> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final redId = e['red_id'] as int?;
    final blueId = e['blue_id'] as int?;
    final winner = e['winner'] as String?;
    final fightResult = e['fight_result'] as String?;
    final weightClass = await getSingle<WeightClass>(e['weight_class_id'] as int);
    final durationMillis = e['duration_millis'] as int?;
    return Fight(
      id: e['id'] as int?,
      r: redId == null ? null : await getSingle<ParticipantState>(redId),
      b: blueId == null ? null : await getSingle<ParticipantState>(blueId),
      weightClass: weightClass!,
      winner: winner == null ? null : FightRoleParser.valueOf(winner),
      result: fightResult == null ? null : FightResultParser.valueOf(fightResult),
      duration: durationMillis == null ? Duration() : Duration(milliseconds: durationMillis),
    );
  }

  void updateClassificationPoints(List<FightAction> actions, {bool isTournament = false}) {
    var _winner = winner == FightRole.red ? r : b;
    var _looser = winner == FightRole.red ? b : r;

    if (result != null) {
      if (_winner != null) {
        _winner.classificationPoints = isTournament
            ? getClassificationPointsWinnerTournament(result!)
            : getClassificationPointsWinnerTeamMatch(
                result!,
                ParticipantState.getTechnicalPoints(actions, winner!) -
                    ParticipantState.getTechnicalPoints(
                        actions, winner == FightRole.red ? FightRole.blue : FightRole.red));
      }

      if (_looser != null) {
        _looser.classificationPoints = isTournament
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

  static int getClassificationPointsWinnerTournament(FightResult result) {
    switch (result) {
      case FightResult.VFA:
      case FightResult.VIN:
      case FightResult.VCA:
      case FightResult.VFO:
      case FightResult.DSQ:
        return 5;
      case FightResult.VSU:
      case FightResult.VSU1:
        return 4;
      case FightResult.VPO:
      case FightResult.VPO1:
        return 3;
      case FightResult.DSQ2:
      default:
        return 0;
    }
  }

  static int getClassificationPointsLooserTournament(FightResult result) {
    switch (result) {
      case FightResult.VSU1:
      case FightResult.VPO1:
        return 1;
      case FightResult.VFA:
      case FightResult.VIN:
      case FightResult.VCA:
      case FightResult.VFO:
      case FightResult.VSU:
      case FightResult.VPO:
      case FightResult.DSQ:
      case FightResult.DSQ2:
      default:
        return 0;
    }
  }

  static int getClassificationPointsWinnerTeamMatch(FightResult result, int diff) {
    switch (result) {
      case FightResult.VFA:
      case FightResult.VIN:
      case FightResult.VCA:
      case FightResult.VFO:
      case FightResult.DSQ:
      case FightResult.VSU:
      case FightResult.VSU1:
        return 4;
      case FightResult.VPO:
      case FightResult.VPO1:
        return diff >= 8 ? 3 : (diff >= 3 ? 2 : 1);
      case FightResult.DSQ2:
      default:
        return 0;
    }
  }

  static int getClassificationPointsLooserTeamMatch(FightResult result) {
    switch (result) {
      case FightResult.VFA:
      case FightResult.VIN:
      case FightResult.VCA:
      case FightResult.VFO:
      case FightResult.DSQ:
      case FightResult.VSU:
      case FightResult.VSU1:
      case FightResult.VPO:
      case FightResult.VPO1:
      case FightResult.DSQ2:
      default:
        return 0;
    }
  }
}
