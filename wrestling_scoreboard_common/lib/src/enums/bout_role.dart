/// The role of the participant (red = home, blue = guest).
enum BoutRole {
  red,
  blue,
}

extension BoutRoleParser on BoutRole {
  String get name => toString().split('.').last;

  static BoutRole valueOf(String name) => BoutRole.values.singleWhere((element) => element.name == name);
}
