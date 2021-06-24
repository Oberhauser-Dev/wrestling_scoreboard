import 'package:flutter/cupertino.dart';

import 'fight_action.dart';
import 'fight_result.dart';
import 'fight_role.dart';
import 'participant_status.dart';
import 'weight_class.dart';

class Fight extends ChangeNotifier {
  final ParticipantStatus? r; // red
  final ParticipantStatus? b; // blue
  final WeightClass weightClass;
  final int? pool;
  final List<FightAction> _actions = [];
  FightResult? result;
  FightRole? winner;

  Duration _duration = Duration();

  Fight(this.r, this.b, this.weightClass, {this.pool}) {
    this.r?.addListener(() {
      notifyListeners();
    });
    this.b?.addListener(() {
      notifyListeners();
    });
  }

  Duration get duration => _duration;

  set duration(Duration duration) {
    _duration = duration;
    notifyListeners();
  }

  addAction(FightAction action) {
    ParticipantStatus? pStatus = action.role == FightRole.red ? this.r : this.b;
    if (pStatus != null) {
      _actions.add(action);
      pStatus.addAction(action);
      notifyListeners();
    }
  }

  removeAction(FightAction action) {
    _actions.remove(action);
    action.role == FightRole.red ? this.r?.removeAction(action) : this.b?.removeAction(action);
    notifyListeners();
  }

  get actions => this._actions;

  updateClassificationPoints({bool isTournament = false}) {
    ParticipantStatus? _winner = this.winner == FightRole.red ? this.r : this.b;
    ParticipantStatus? _looser = this.winner == FightRole.red ? this.b : this.r;

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
