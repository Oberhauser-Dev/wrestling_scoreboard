import 'fight_action.dart';
import 'participant.dart';
import 'weight_class.dart';

class ParticipantStatus {
  final Participant participant;
  final WeightClass weightClass;
  final List<FightAction> _actions = [];
  double? weight;
  int? classificationPoints;

  ParticipantStatus({required this.participant, required this.weightClass, this.weight});

  get actions => this._actions;

  get technicalPoints {
    int res = 0;
    _actions.forEach((el) {
      if (el.actionType == FightActionType.points) {
        res += el.pointCount!;
      }
    });
    return res;
  }
}
