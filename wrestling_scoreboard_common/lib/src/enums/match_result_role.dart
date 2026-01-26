/// The role of the participant.
enum MatchResultRole {
  home,
  guest,
  tie;

  MatchResultRole get opponent =>
      switch (this) {
        home => guest,
        guest => home,
        tie => tie,
      };

  static MatchResultRole fromDiff(int diff) {
    return diff > 0
        ? MatchResultRole.home
        : (diff < 0 ? MatchResultRole.guest : MatchResultRole.tie);
  }
}
