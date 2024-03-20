/// The persons gender.
enum Gender {
  male,
  female,
  other;

  String get name => toString().split('.').last;
}
