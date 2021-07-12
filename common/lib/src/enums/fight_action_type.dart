enum FightActionType {
  points,
  passivity, // P
  verbal, // V admonition
  caution, // yellow card
  dismissal // red card
}

FightActionType fightActionTypeDecode(String val) {
  return FightActionType.values.singleWhere((element) => element.toString() == 'FightActionType.' + val);
}
