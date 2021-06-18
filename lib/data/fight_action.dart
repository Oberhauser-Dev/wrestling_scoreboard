import 'package:wrestling_scoreboard/data/fight_role.dart';

enum FightActionType {
  points,
  passivity, // P
  caution, // yellow card
  dismissal // red card
}

class FightAction {
  Duration duration;
  FightActionType actionType;
  int? pointCount;
  FightRole actor;

  FightAction({required this.actionType, required this.duration, required this.actor, this.pointCount});

  @override
  String toString() {
    switch (actionType) {
      case FightActionType.points:
        return pointCount?.toString() ?? '0';
      case FightActionType.passivity:
        return 'P';
      case FightActionType.caution:
        return 'V';
      case FightActionType.dismissal:
        return 'D';
      default:
        return '';
    }
  }
}
