enum ActionType {
  points,
  passivity, // P
  caution, // yellow card
  dismissal // red card
}

class Action {
  Duration duration;
  ActionType actionType;
  int? pointCount;

  Action(this.actionType, this.duration, {this.pointCount});
}
