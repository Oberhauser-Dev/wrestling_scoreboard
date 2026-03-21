import 'dart:math' as math;

import 'package:collection/collection.dart';

/// Returns a list of rounds (index) which hold a lists of bouts with red (id) and blue (id)
List<List<(int?, int?)>> generateBergerTable(int participationSize, {int? maxRounds, bool alternateColors = false}) {
  if (participationSize < 2) return [];

  final int n = participationSize.isEven ? participationSize : participationSize + 1;
  final int rounds = math.min(maxRounds ?? n - 1, n - 1);
  final int boutsPerRound = n ~/ 2;

  // Create a list of player indices: [0, 1, 2, ..., n-1]
  // If participationSize was odd, the last index (n-1) represents the dummy.
  final List<int?> contestants = List.generate(n, (index) => index >= participationSize ? null : index);

  final List<List<(int?, int?)>> boutsByRound = [];

  for (int r = 0; r < rounds; r++) {
    final List<(int?, int?)> roundMatches = [];

    final int? c1 = contestants[r];
    // Fixed player is at the end
    final int? c2 = contestants[n - 1];

    roundMatches.add((!alternateColors || r.isEven) ? (c2, c1) : (c1, c2));

    // We pair the remaining indices: (r+1) vs (n-2), (r+2) vs (n-3), etc.
    // We use modulo arithmetic to simulate the rotation without modifying the array.
    for (int i = 1; i < boutsPerRound; i++) {
      final int idx1 = (r + i) % (n - 1);
      final int idx2 = (r + (n - 1) - i) % (n - 1);

      final home = contestants[idx1];
      final guest = contestants[idx2];

      roundMatches.add((!alternateColors || i.isOdd) ? (home, guest) : (guest, home));
    }
    boutsByRound.add(roundMatches);
  }
  return boutsByRound;
}

List<(int?, int?)> generateSingleEliminationRound(List<int> participants) {
  final List<int?> list = [...participants];
  if (list.length.isOdd) {
    list.add(null);
  }
  return list.slices(2).map((pairs) => (pairs[0], pairs[1])).toList();
}

List<(int?, int?)> generateDoubleEliminationRound({
  required List<int> winnerBracket,
  List<int> looserBracket = const [],
}) {
  final List<(int?, int?)> list = [];
  list.addAll(generateSingleEliminationRound(winnerBracket));
  list.addAll(generateSingleEliminationRound(looserBracket));
  return list;
}

Iterable<(int, int)> generateByeDoubleEliminationRound(List<int> remaining, Iterable<Set<int>> previousPairings) {
  Iterable<Set<int>>? pairWithThreshold(
    List<int> singles,
    Iterable<Set<int>> oldPairs,
    Iterable<Set<int>> newPairs,
    int threshold,
  ) {
    if (singles.length <= threshold) return newPairs;

    for (int i = 0; i < singles.length - 1; i++) {
      for (int j = i + 1; j < singles.length; j++) {
        final pair = {singles[i], singles[j]};
        if (!{...oldPairs, ...newPairs}.any((s) => s.containsAll(pair))) {
          final List<int> recursiveSingles = List.from(singles)
            ..remove(singles[i])
            ..remove(singles[j]);
          final Iterable<Set<int>> recursivePairs = Set.from(newPairs)..add(pair);
          final result = pairWithThreshold(recursiveSingles, oldPairs, recursivePairs, threshold);
          if (result != null) return result;
        }
      }
    }

    return null;
  }

  Iterable<(int, int)>? newPairings;
  for (int i = 1; i <= remaining.length; i++) {
    newPairings = pairWithThreshold(remaining, previousPairings, {}, i)?.map((e) {
      final pair = e.toList();
      return (pair[0], pair[1]);
    });
    if (newPairings != null) break;
  }

  return newPairings ?? [];
}
