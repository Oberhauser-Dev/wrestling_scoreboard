/// The role of the participant (red = home, blue = guest).
enum BoutRole {
  red,
  blue;

  BoutRole get opponent => this == red ? blue : red;
}
