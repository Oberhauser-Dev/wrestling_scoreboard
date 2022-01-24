/// The role of the person.
enum PersonRole {
  referee,
  matChairman,
  judge,
  transcriptWriter,
  timeKeeper,
  steward,
}

extension PersonRoleParser on PersonRole {
  String get name => toString().split('.').last;

  static PersonRole valueOf(String name) => PersonRole.values.singleWhere((element) => element.name == name);
}
