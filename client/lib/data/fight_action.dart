import 'package:wrestling_scoreboard/data/fight_role.dart';

enum FightActionType {
  points,
  passivity, // P
  verbal, // V admonition
  caution, // yellow card
  dismissal // red card
}

class FightAction {
  Duration duration;
  FightActionType actionType;
  int? pointCount;
  FightRole role;

  FightAction({required this.actionType, required this.duration, required this.role, this.pointCount});

  @override
  String toString() {
    switch (actionType) {
      case FightActionType.points:
        return pointCount?.toString() ?? '0';
      case FightActionType.passivity:
        return 'P';
      case FightActionType.verbal:
        return 'V';
      case FightActionType.caution:
        return 'O';
      case FightActionType.dismissal:
        return 'D';
      default:
        return '';
    }
  }
}
