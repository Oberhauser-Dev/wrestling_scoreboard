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
  final List<FightAction> _actions = [];
  FightResult? result;
  FightRole? winner;
  Duration duration;

  Fight({int? id, this.r, this.b, required this.weightClass, this.pool, this.winner, this.result, this.duration = const Duration()}) : super(id);

  factory Fight.fromJson(Map<String, dynamic> json) => _$FightFromJson(json);

  Map<String, dynamic> toJson() => _$FightToJson(this);

  bool addAction(FightAction action) {
    ParticipantState? pStatus = action.role == FightRole.red ? this.r : this.b;
    if (pStatus != null) {
      _actions.add(action);
      pStatus.addAction(action);
      return true;
    }
    return false;
  }

  removeAction(FightAction action) {
    _actions.remove(action);
    action.role == FightRole.red ? this.r?.removeAction(action) : this.b?.removeAction(action);
  }

  get actions => this._actions;

  updateClassificationPoints({bool isTournament = false}) {
    ParticipantState? _winner = this.winner == FightRole.red ? this.r : this.b;
    ParticipantState? _looser = this.winner == FightRole.red ? this.b : this.r;

    if (this.result != null) {
      if (_winner != null) {
        _winner.classificationPoints = isTournament
            ? getClassificationPointsWinnerTournament(this.result!)
            : getClassificationPointsWinnerTeamMatch(
            this.result!, _winner.technicalPoints - (_looser?.technicalPoints ?? 0));
      }

      if (_looser != null) {
        _looser.classificationPoints = isTournament
            ? getClassificationPointsLooserTournament(this.result!)
            : getClassificationPointsLooserTeamMatch(this.result!);
      }
    } else {
      this.r?.classificationPoints = null;
      this.b?.classificationPoints = null;
    }
  }

  bool equalDuringFight(o) =>
      o is Fight && o.runtimeType == runtimeType
          && (r?.equalDuringFight(o.r) ?? (r == null && o.r == null))
          && (b?.equalDuringFight(o.b) ?? (b == null && o.b == null))
          && weightClass == o.weightClass;

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
