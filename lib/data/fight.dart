import 'fight_result.dart';
import 'participant_status.dart';
import 'weight_class.dart';

enum FightRole {
  red,
  blue,
}

class Fight {
  final ParticipantStatus? r; // red
  final ParticipantStatus? b; // blue
  final WeightClass weightClass;
  final int? pool;
  FightResult? result;
  FightRole? winner;

  Duration duration = Duration();

  Fight(this.r, this.b, this.weightClass, {this.pool});

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
