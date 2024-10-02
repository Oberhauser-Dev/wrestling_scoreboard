import 'package:test/test.dart';
import 'package:wrestling_scoreboard_common/common.dart';

void main() {
  group('Bout Rules Competition', () {
    final boutResultRules = Competition.defaultBoutResultRules;

    group('Freestyle', () {
      final wrestlingStyle = WrestlingStyle.free;
      test('VFA', () {
        final resultRule = BoutConfig.resultRule(
          result: BoutResult.vfa,
          style: wrestlingStyle,
          technicalPointsWinner: 0,
          technicalPointsLoser: 0,
          rules: boutResultRules,
        );
        expect(resultRule.winnerClassificationPoints, 5);
        expect(resultRule.loserClassificationPoints, 0);
      });
      test('VIN', () {
        final resultRule = BoutConfig.resultRule(
          result: BoutResult.vin,
          style: wrestlingStyle,
          technicalPointsWinner: 0,
          technicalPointsLoser: 0,
          rules: boutResultRules,
        );
        expect(resultRule.winnerClassificationPoints, 5);
        expect(resultRule.loserClassificationPoints, 0);
      });
      test('VCA', () {
        final resultRule = BoutConfig.resultRule(
          result: BoutResult.vca,
          style: wrestlingStyle,
          technicalPointsWinner: 0,
          technicalPointsLoser: 0,
          rules: boutResultRules,
        );
        expect(resultRule.winnerClassificationPoints, 5);
        expect(resultRule.loserClassificationPoints, 0);
      });
      test('VSU', () {
        final resultRule = BoutConfig.resultRule(
          result: BoutResult.vsu,
          style: wrestlingStyle,
          technicalPointsWinner: 10,
          technicalPointsLoser: 0,
          rules: boutResultRules,
        );
        expect(resultRule.winnerClassificationPoints, 4);
        expect(resultRule.loserClassificationPoints, 0);
      });
      test('VSU, loser with technical points', () {
        final resultRule = BoutConfig.resultRule(
          result: BoutResult.vsu,
          style: wrestlingStyle,
          technicalPointsWinner: 11,
          technicalPointsLoser: 1,
          rules: boutResultRules,
        );
        expect(resultRule.winnerClassificationPoints, 4);
        expect(resultRule.loserClassificationPoints, 1);
      });
      test('VPO', () {
        final resultRule = BoutConfig.resultRule(
          result: BoutResult.vpo,
          style: wrestlingStyle,
          technicalPointsWinner: 1,
          technicalPointsLoser: 0,
          rules: boutResultRules,
        );
        expect(resultRule.winnerClassificationPoints, 3);
        expect(resultRule.loserClassificationPoints, 0);
      });
      test('VPO, loser with technical points', () {
        final resultRule = BoutConfig.resultRule(
          result: BoutResult.vpo,
          style: wrestlingStyle,
          technicalPointsWinner: 2,
          technicalPointsLoser: 1,
          rules: boutResultRules,
        );
        expect(resultRule.winnerClassificationPoints, 3);
        expect(resultRule.loserClassificationPoints, 1);
      });
      test('VFO', () {
        final resultRule = BoutConfig.resultRule(
          result: BoutResult.vfo,
          style: wrestlingStyle,
          technicalPointsWinner: 0,
          technicalPointsLoser: 0,
          rules: boutResultRules,
        );
        expect(resultRule.winnerClassificationPoints, 5);
        expect(resultRule.loserClassificationPoints, 0);
      });
      test('DSQ', () {
        final resultRule = BoutConfig.resultRule(
          result: BoutResult.dsq,
          style: wrestlingStyle,
          technicalPointsWinner: 0,
          technicalPointsLoser: 0,
          rules: boutResultRules,
        );
        expect(resultRule.winnerClassificationPoints, 5);
        expect(resultRule.loserClassificationPoints, 0);
      });
      test('DSQ2', () {
        final resultRule = BoutConfig.resultRule(
          result: BoutResult.dsq2,
          style: wrestlingStyle,
          technicalPointsWinner: 0,
          technicalPointsLoser: 0,
          rules: boutResultRules,
        );
        expect(resultRule.winnerClassificationPoints, 0);
        expect(resultRule.loserClassificationPoints, 0);
      });
    });

    group('Greco', () {
      final wrestlingStyle = WrestlingStyle.greco;
      test('VSU', () {
        final resultRule = BoutConfig.resultRule(
          result: BoutResult.vsu,
          style: wrestlingStyle,
          technicalPointsWinner: 8,
          technicalPointsLoser: 0,
          rules: boutResultRules,
        );
        expect(resultRule.winnerClassificationPoints, 4);
        expect(resultRule.loserClassificationPoints, 0);
      });
      test('VSU, loser with technical points', () {
        final resultRule = BoutConfig.resultRule(
          result: BoutResult.vsu,
          style: wrestlingStyle,
          technicalPointsWinner: 9,
          technicalPointsLoser: 1,
          rules: boutResultRules,
        );
        expect(resultRule.winnerClassificationPoints, 4);
        expect(resultRule.loserClassificationPoints, 1);
      });
    });
  });

  group('Bout Rules TeamMatch', () {
    final boutResultRules = TeamMatch.defaultBoutResultRules;

    group('Freestyle', () {
      final wrestlingStyle = WrestlingStyle.free;
      test('VFA', () {
        final resultRule = BoutConfig.resultRule(
          result: BoutResult.vfa,
          style: wrestlingStyle,
          technicalPointsWinner: 0,
          technicalPointsLoser: 0,
          rules: boutResultRules,
        );
        expect(resultRule.winnerClassificationPoints, 4);
        expect(resultRule.loserClassificationPoints, 0);
      });
      test('VIN', () {
        final resultRule = BoutConfig.resultRule(
          result: BoutResult.vin,
          style: wrestlingStyle,
          technicalPointsWinner: 0,
          technicalPointsLoser: 0,
          rules: boutResultRules,
        );
        expect(resultRule.winnerClassificationPoints, 4);
        expect(resultRule.loserClassificationPoints, 0);
      });
      test('VCA', () {
        final resultRule = BoutConfig.resultRule(
          result: BoutResult.vca,
          style: wrestlingStyle,
          technicalPointsWinner: 0,
          technicalPointsLoser: 0,
          rules: boutResultRules,
        );
        expect(resultRule.winnerClassificationPoints, 4);
        expect(resultRule.loserClassificationPoints, 0);
      });
      test('VSU', () {
        final resultRule = BoutConfig.resultRule(
          result: BoutResult.vsu,
          style: wrestlingStyle,
          technicalPointsWinner: 15,
          technicalPointsLoser: 0,
          rules: boutResultRules,
        );
        expect(resultRule.winnerClassificationPoints, 4);
        expect(resultRule.loserClassificationPoints, 0);
      });
      test('VSU, loser with technical points', () {
        final resultRule = BoutConfig.resultRule(
          result: BoutResult.vsu,
          style: wrestlingStyle,
          technicalPointsWinner: 16,
          technicalPointsLoser: 1,
          rules: boutResultRules,
        );
        expect(resultRule.winnerClassificationPoints, 4);
        expect(resultRule.loserClassificationPoints, 0);
      });
      test('VPO, 8 points diff', () {
        final resultRule = BoutConfig.resultRule(
          result: BoutResult.vpo,
          style: wrestlingStyle,
          technicalPointsWinner: 8,
          technicalPointsLoser: 0,
          rules: boutResultRules,
        );
        expect(resultRule.winnerClassificationPoints, 3);
        expect(resultRule.loserClassificationPoints, 0);
      });
      test('VPO, 3 points diff', () {
        final resultRule = BoutConfig.resultRule(
          result: BoutResult.vpo,
          style: wrestlingStyle,
          technicalPointsWinner: 3,
          technicalPointsLoser: 0,
          rules: boutResultRules,
        );
        expect(resultRule.winnerClassificationPoints, 2);
        expect(resultRule.loserClassificationPoints, 0);
      });
      test('VPO, 1 point diff', () {
        final resultRule = BoutConfig.resultRule(
          result: BoutResult.vpo,
          style: wrestlingStyle,
          technicalPointsWinner: 1,
          technicalPointsLoser: 0,
          rules: boutResultRules,
        );
        expect(resultRule.winnerClassificationPoints, 1);
        expect(resultRule.loserClassificationPoints, 0);
      });
      test('VFO', () {
        final resultRule = BoutConfig.resultRule(
          result: BoutResult.vfo,
          style: wrestlingStyle,
          technicalPointsWinner: 0,
          technicalPointsLoser: 0,
          rules: boutResultRules,
        );
        expect(resultRule.winnerClassificationPoints, 4);
        expect(resultRule.loserClassificationPoints, 0);
      });
      test('DSQ', () {
        final resultRule = BoutConfig.resultRule(
          result: BoutResult.dsq,
          style: wrestlingStyle,
          technicalPointsWinner: 0,
          technicalPointsLoser: 0,
          rules: boutResultRules,
        );
        expect(resultRule.winnerClassificationPoints, 4);
        expect(resultRule.loserClassificationPoints, 0);
      });
      test('DSQ2', () {
        final resultRule = BoutConfig.resultRule(
          result: BoutResult.dsq2,
          style: wrestlingStyle,
          technicalPointsWinner: 0,
          technicalPointsLoser: 0,
          rules: boutResultRules,
        );
        expect(resultRule.winnerClassificationPoints, 0);
        expect(resultRule.loserClassificationPoints, 0);
      });
    });
  });
}
