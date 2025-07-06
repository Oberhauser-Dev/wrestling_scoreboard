import 'dart:math' as math;

import 'package:collection/collection.dart';

/// Returns a list of rounds (index) which hold a lists of bouts with red (id) and blue (id)
List<List<(int?, int?)>> generateBergerTable(int participationSize, {int? maxRounds}) {
  final List<int?> participations = Iterable<int?>.generate(participationSize).toList();
  if (participations.length.isOdd) participations.insert(0, null);
  final useDummy = false;

  final n = participations.length;
  final numberOfRounds = math.min(maxRounds ?? participationSize - 1, participationSize - 1);
  final boutsPerRound = n ~/ 2;

  List<int?> columnA = participations.slice(0, boutsPerRound).toList();
  final List<int?> columnB = participations.slice(boutsPerRound).toList();
  final fixed = participations[0];

  final gen =
      Iterable<int>.generate(numberOfRounds).map((roundIndex) {
        final genBoutsPerRound = Iterable<int>.generate(boutsPerRound);
        final boutsArr = <(int?, int?)>[];
        for (final k in genBoutsPerRound) {
          if (useDummy || (columnA[k] != null && columnB[k] != null)) {
            boutsArr.insert(0, (columnA[k], columnB[k]));
          }
        }

        // rotate elements
        final pop = columnA.removeLast();
        columnA = [fixed, columnB.removeAt(0), ...columnA.slice(1)];
        columnB.insert(0, pop);
        return boutsArr;
      }).toList();
  return gen;
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
          final List<int> recursiveSingles =
              List.from(singles)
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
