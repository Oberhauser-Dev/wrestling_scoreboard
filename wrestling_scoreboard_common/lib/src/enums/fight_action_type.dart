enum FightActionType {
  points,
  passivity, // P
  verbal, // V admonition
  caution, // yellow card
  dismissal // red card
}

extension FightActionTypeParser on FightActionType {
  String get name => toString().split('.').last;

  static FightActionType valueOf(String name) => FightActionType.values.singleWhere((element) => element.name == name);
}
