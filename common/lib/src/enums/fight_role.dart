/// The role of the participant (red = home, blue = guest).
enum FightRole {
  red,
  blue,
}

extension FightRoleParser on FightRole {
  String get name => toString().split('.').last;

  static FightRole valueOf(String name) => FightRole.values.singleWhere((element) => element.name == name);
}