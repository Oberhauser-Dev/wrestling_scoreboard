import 'package:test/test.dart';
import 'package:wrestling_scoreboard_server/utils/competition_system_algorithms.dart';

void main() {
  test('byeDoubleElimination', () async {
    final previousPairings = {
      {7, 5},
      {4, 6},
      {3, 8},
      {6, 5},
      {1, 8},
      {4, 7},
    };
    final remaining = [4, 7, 6];
    final res = generateByeDoubleEliminationRound(remaining, previousPairings);
    expect(res, [(7, 6)]);
  });

  test('bergerTable', () async {
    final res = generateBergerTable(5);
    // 5 (dummy) + 4 + 3 + 2 + 1
    expect(res, [
      [(null, 0), (1, 4), (2, 3)],
      [(null, 1), (2, 0), (3, 4)],
      [(null, 2), (3, 1), (4, 0)],
      [(null, 3), (4, 2), (0, 1)],
      [(null, 4), (0, 3), (1, 2)],
    ]);
  });
}
