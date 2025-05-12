// May also called phase
enum RoundType {
  /// Qualify for the regular elimination rounds (e.g. to get to a regular set of 2^x participants).
  qualification,

  /// Regular rounds in an elimination system.
  elimination,

  /// Rounds to give a second chance for fighters which lost against finalists.
  repechage,

  /// Round before the finals (fight across)
  semiFinals,

  /// The round deciding the final ranking.
  finals,
}
