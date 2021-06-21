import 'package:flutter/cupertino.dart';

import 'fight_action.dart';
import 'participant.dart';
import 'weight_class.dart';

class ParticipantStatus extends ChangeNotifier {
  final Participant participant;
  final WeightClass weightClass;
  final List<FightAction> _actions = [];
  double? weight;
  int? _classificationPoints;

  ParticipantStatus({required this.participant, required this.weightClass, this.weight});

  get actions => this._actions;

  addAction(FightAction action) {
    _actions.add(action);
    notifyListeners();
  }

  removeAction(FightAction action) {
    _actions.remove(action);
    notifyListeners();
  }

  set classificationPoints(int? points) {
    _classificationPoints = points;
    notifyListeners();
  }

  int? get classificationPoints => _classificationPoints;

  int get technicalPoints {
    int res = 0;
    _actions.forEach((el) {
      if (el.actionType == FightActionType.points) {
        res += el.pointCount!;
      }
    });
    return res;
  }
}
