/// The role of the participant (red = home, blue = guest).
enum BoutRole {
  red,
  blue;

  String get name => toString().split('.').last;
}
