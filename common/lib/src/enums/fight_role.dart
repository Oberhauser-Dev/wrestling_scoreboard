/// The role of the participant (red = home, blue = guest).
enum FightRole {
  red,
  blue,
}

FightRole fightRoleDecode(String val) {
  return FightRole.values.singleWhere((element) => element.toString() == 'FightRole.' + val);
}