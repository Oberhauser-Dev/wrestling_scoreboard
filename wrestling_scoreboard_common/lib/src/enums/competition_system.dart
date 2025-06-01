/// See: https://en.wikipedia.org/wiki/Tournament#Knockout
enum CompetitionSystem {
  /// https://en.wikipedia.org/wiki/Single-elimination_tournament
  singleElimination,

  /// https://en.wikipedia.org/wiki/Double-elimination_tournament
  doubleElimination,

  /// https://en.wikipedia.org/wiki/Round-robin_tournament
  nordic,

  /// TODO: rewritten
  /// Mainly used in pool system.
  ///
  /// Run the nordic system.
  /// A contestant is eliminated when loosing two times.
  /// For each upcoming round, calculate a nordic system with the remaining participants.
  /// Skip all bouts, which already have taken place.
  /// Skip a bout, if one of its participant already has a fight in the upcoming round.
  /// Fill the upcoming round with `min(remainingBouts, remainingParticipants ~/ 2)` bouts (max bout count).
  ///   - If the max bout count cannot be fulfilled, replace the last added item with the next possible one.
  ///   - If the max bout count still cannot be fulfilled, recursively remove the last 2[,3,...,n] items and replace with the next possible ones, until the max bout count is matched, or keep the last possible combination.
  /// The pool system ends, if the last 3 remaining contestants have fought against each other, no matter if they did loose more than 2 times.
  nordicDoubleElimination,
}
