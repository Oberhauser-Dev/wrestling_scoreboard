enum ActionType {
  points,
  passivity, // P
  caution, // yellow card
  dismissal // red card
}

class WrestlingAction {
  Duration duration;
  ActionType actionType;
  int? pointCount;

  WrestlingAction({required this.actionType, required this.duration, this.pointCount});
}
