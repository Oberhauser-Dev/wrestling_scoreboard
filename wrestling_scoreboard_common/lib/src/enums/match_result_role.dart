/// The role of the participant.
enum MatchResultRole {
  home,
  guest,
  tie;

  MatchResultRole get opponent => switch (this) {
    home => guest,
    guest => home,
    tie => tie,
  };
}
