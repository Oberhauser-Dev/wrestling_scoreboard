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
}
