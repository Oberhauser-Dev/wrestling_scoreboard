/// The persons gender.
enum Gender {
  male,
  female,
  other,
}

extension GenderParser on Gender {
  String get name => toString().split('.').last;

  static Gender valueOf(String name) => Gender.values.singleWhere((element) => element.name == name);
}
