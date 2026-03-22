import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_common/src/mocked_data.dart';
import 'package:wrestling_scoreboard_server/controllers/athlete_bout_state_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_action_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_result_rule_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_bout_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_participation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_system_phase_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_weight_category_controller.dart';
import 'package:wrestling_scoreboard_server/server.dart' as server;
import 'package:wrestling_scoreboard_server/services/postgres_db.dart';

import 'common.dart';

void main() {
  MockableDateTime.isMocked = true;
  MockableDateTime.mockedDateTime = DateTime.utc(2024, 01, 02);
  MockableRandom.isMocked = true;

  final mockedData = MockedData();
  final competitionDataTypes = [
    CompetitionParticipation,
    CompetitionBout,
    CompetitionWeightCategory,
    CompetitionAgeCategory,
    WeightClass,
    CompetitionLineup,
    BoutAction,
    Bout,
    AthleteBoutState,
    Membership,
    CompetitionPerson,
    Person,
    CompetitionSystemPhase,
    CompetitionSystemAffiliation,
    Competition,
    Club,
    AgeCategory,
    Organization,
    BoutResultRule,
    BoutConfig,
  ];

  Future<void> loadMockedData({Iterable<Type> excludedTypes = const []}) async {
    for (final dataType in competitionDataTypes.reversed) {
      if (excludedTypes.contains(dataType)) continue;
      final List<DataObject> objs = mockedData.getByType(dataType);
      final controller = ShelfController.getControllerFromDataType(dataType);
      await controller!.createMany(objs);
    }
  }

  group('Competition', () {
    late PostgresDb db;
    setUp(() async {
      db = PostgresDb();
      await db.open();
    });

    tearDown(() async {
      await db.close();
    });

    group('Mocked', () {
      late HttpServer serverInstance;

      setUp(() async {
        await db.reset();
        serverInstance = await server.init();
      });

      tearDown(() async {
        await serverInstance.close();
      });

      test('Create entities via API', () async {
        await loadMockedData();
        final apiUrl = 'http://${serverInstance.address.address}:${serverInstance.port}/api';
        final authHeaders = await getAuthHeaders(apiUrl);
        final databaseExportForController = await db.export();
        await db.reset();

        for (final dataType in competitionDataTypes.reversed) {
          final Iterable<DataObject> objs = mockedData.getByType(dataType);
          for (var obj in objs) {
            final body = jsonEncode(singleToJson(obj, dataType, CRUD.create));
            final tableUrl = '$apiUrl/${obj.tableName}';
            final uri = Uri.parse(tableUrl);
            final postRes = await http.post(uri, headers: authHeaders, body: body);
            expect(postRes.statusCode, 200, reason: postRes.body);
          }
        }
        final databaseExportForApi = await db.export();

        expect(DatabaseExt.sanitizeSql(databaseExportForApi), DatabaseExt.sanitizeSql(databaseExportForController));
      });

      test('Generate bouts', () async {
        await loadMockedData(excludedTypes: [CompetitionBout, BoutAction, Bout, AthleteBoutState]);

        CompetitionWeightCategory competitionWeightCategory = mockedData.competitionWeightCategory;
        await CompetitionWeightCategoryController().generateInitialBouts(
          weightCategoryId: competitionWeightCategory.id!,
          obfuscate: false,
          isReset: false,
        );

        competitionWeightCategory = await CompetitionWeightCategoryController().getSingle(
          competitionWeightCategory.id!,
          obfuscate: false,
        );
        expect(competitionWeightCategory.competitionSystemAffiliation?.maxContestants, 7);
        final phases = await CompetitionSystemPhaseController().getByCompetitionSystemAffiliation(
          competitionWeightCategory.competitionSystemAffiliation!.id!,
          obfuscate: false,
        );
        expect(phases, [
          CompetitionSystemPhase(
            id: 3,
            pos: 0,
            isCrossOver: false,
            maxRank: 3,
            competitionSystem: CompetitionSystem.nordic,
            poolGroupCount: 2,
            competitionSystemAffiliation: competitionWeightCategory.competitionSystemAffiliation!,
          ),
          CompetitionSystemPhase(
            id: 4,
            pos: 1,
            isCrossOver: true,
            maxRank: 6,
            competitionSystem: CompetitionSystem.finals,
            poolGroupCount: 1,
            competitionSystemAffiliation: competitionWeightCategory.competitionSystemAffiliation!,
          ),
        ]);

        List<CompetitionBout> competitionBouts = await CompetitionBoutController().getByWeightCategory(
          competitionWeightCategory.id!,
          obfuscate: false,
        );
        // 7 non-disqualified contestants: (3 + 2 + 1) + (2 + 1)
        expect(competitionBouts.length, 9);
        expect((await BoutController().getMany(obfuscate: false)).length, 9);
        expect((await AthleteBoutStateController().getMany(obfuscate: false)).length, 18);

        // Create some bout actions, to see if they are getting deleted
        await BoutActionController().createSingle(
          BoutAction(
            actionType: BoutActionType.points,
            bout: competitionBouts.first.bout,
            duration: Duration.zero,
            pointCount: 2,
            role: BoutRole.red,
          ),
        );
        await BoutActionController().createSingle(
          BoutAction(
            actionType: BoutActionType.verbal,
            bout: competitionBouts.first.bout,
            duration: Duration.zero,
            role: BoutRole.blue,
          ),
        );
        expect((await BoutActionController().getMany(obfuscate: false)).length, 2);

        // Generate a second time and check if see the same results
        await CompetitionWeightCategoryController().generateInitialBouts(
          weightCategoryId: competitionWeightCategory.id!,
          obfuscate: false,
          isReset: false,
        );

        competitionBouts = await CompetitionBoutController().getByWeightCategory(
          competitionWeightCategory.id!,
          obfuscate: false,
        );
        expect(competitionBouts.length, 9);
        expect((await BoutController().getMany(obfuscate: false)).length, 9);
        expect((await AthleteBoutStateController().getMany(obfuscate: false)).length, 18);
        expect((await BoutActionController().getMany(obfuscate: false)).length, 0);
      });

      group('Competition Systems', () {
        setUp(() async {
          await loadMockedData(
            excludedTypes: [
              CompetitionBout, BoutAction, Bout, AthleteBoutState,
              // Setup the participants ourselves to be able to test the competition systems.
              CompetitionParticipation,
            ],
          );
        });

        Future<List<CompetitionParticipation>> createCompetitionParticipationsForWeightCategory(
          int count,
          CompetitionWeightCategory weightCategory,
        ) async {
          final participants = mockedData
              .getCompetitionParticipations()
              .where((cp) => cp.weightCategory == weightCategory)
              .toList()
              .sublist(0, count)
              // Remove all additional information, which is set on initial generation
              .map((e) => e.copyWith(poolDrawNumbers: [], poolGroups: [], contestantStatus: null))
              .toList();
          await CompetitionParticipationController().createMany(participants);
          return participants;
        }

        test('BestOfThree', () async {
          final resultRules = await BoutResultRuleController().getByBoutConfigId(
            configId: mockedData.competition.boutConfig.id!,
            obfuscate: false,
          );
          CompetitionWeightCategory competitionWeightCategory = mockedData.competitionWeightCategory;
          var participants = await createCompetitionParticipationsForWeightCategory(2, competitionWeightCategory);

          await CompetitionWeightCategoryController().generateInitialBouts(
            weightCategoryId: competitionWeightCategory.id!,
            obfuscate: false,
            isReset: false,
          );

          competitionWeightCategory = await CompetitionWeightCategoryController().getSingle(
            competitionWeightCategory.id!,
            obfuscate: false,
          );
          expect(competitionWeightCategory.pairedRoundByPhase, [1]);
          expect(competitionWeightCategory.competitionSystemAffiliation?.maxContestants, 2);
          final phases = await CompetitionSystemPhaseController().getByCompetitionSystemAffiliation(
            competitionWeightCategory.competitionSystemAffiliation!.id!,
            obfuscate: false,
          );
          expect(phases, [
            CompetitionSystemPhase(
              id: 1,
              pos: 0,
              isCrossOver: false,
              maxRank: 2,
              competitionSystem: CompetitionSystem.bestOfThree,
              poolGroupCount: 1,
              competitionSystemAffiliation: competitionWeightCategory.competitionSystemAffiliation!,
            ),
          ]);

          participants = await CompetitionParticipationController().getByWeightCategory(
            competitionWeightCategory.id!,
            obfuscate: false,
          );

          List<CompetitionBout> competitionBouts = await CompetitionBoutController().getByWeightCategory(
            competitionWeightCategory.id!,
            obfuscate: false,
          );
          final firstCBout = CompetitionBout(
            id: 1,
            pos: 0,
            round: 0,
            competition: mockedData.competition,
            bout: Bout(
              id: 1,
              organization: mockedData.organization,
              r: AthleteBoutState(id: 1, membership: mockedData.r1),
              b: AthleteBoutState(id: 2, membership: mockedData.b1),
            ),
            roundType: RoundType.elimination,
            phasePos: 0,
            weightCategory: competitionWeightCategory,
          );
          final secondCBout = CompetitionBout(
            id: 2,
            // TODO: pos:2 is an approximation and should be revised
            pos: 2,
            round: 1,
            competition: mockedData.competition,
            bout: Bout(
              id: 2,
              organization: mockedData.organization,
              r: AthleteBoutState(id: 3, membership: mockedData.b1),
              b: AthleteBoutState(id: 4, membership: mockedData.r1),
            ),
            roundType: RoundType.elimination,
            phasePos: 0,
            weightCategory: competitionWeightCategory,
          );
          expect(competitionBouts, [firstCBout, secondCBout]);

          // Generate after first round (0)
          final firstBout = firstCBout.bout.updateBoutResult(
            winnerRole: BoutRole.red,
            result: BoutResult.vin,
            actions: [],
            style: competitionWeightCategory.weightClass.style,
            rules: resultRules,
          );
          await _saveBout(firstBout);

          competitionWeightCategory = await CompetitionWeightCategoryController().getSingle(
            competitionWeightCategory.id!,
            obfuscate: false,
          );
          // Second round in first phase was paired.
          expect(competitionWeightCategory.pairedRoundByPhase, [1]);

          competitionBouts = await CompetitionBoutController().getByWeightCategory(
            competitionWeightCategory.id!,
            obfuscate: false,
          );
          expect(competitionBouts.length, 2);

          // Generate after second round (1)
          final secondBout = secondCBout.bout.updateBoutResult(
            winnerRole: BoutRole.red,
            result: BoutResult.vin,
            actions: [],
            style: competitionWeightCategory.weightClass.style,
            rules: resultRules,
          );
          await _saveBout(secondBout);

          competitionWeightCategory = await CompetitionWeightCategoryController().getSingle(
            competitionWeightCategory.id!,
            obfuscate: false,
          );
          expect(competitionWeightCategory.pairedRoundByPhase, [2]);

          competitionBouts = await CompetitionBoutController().getByWeightCategory(
            competitionWeightCategory.id!,
            obfuscate: false,
          );
          expect(competitionBouts.length, 3);
          final thirdCBout = competitionBouts.last;
          expect(
            thirdCBout,
            CompetitionBout(
              id: 3,
              pos: 4,
              round: 2,
              competition: mockedData.competition,
              bout: Bout(
                id: 3,
                organization: mockedData.organization,
                r: AthleteBoutState(id: 5, membership: mockedData.r1),
                b: AthleteBoutState(id: 6, membership: mockedData.b1),
              ),
              roundType: RoundType.finals,
              phasePos: 0,
              weightCategory: competitionWeightCategory,
            ),
          );

          // STOP generation after third round (2)
          final thirdBout = thirdCBout.bout.updateBoutResult(
            winnerRole: BoutRole.red,
            result: BoutResult.vin,
            actions: [],
            style: competitionWeightCategory.weightClass.style,
            rules: resultRules,
          );
          await _saveBout(thirdBout);

          competitionWeightCategory = await CompetitionWeightCategoryController().getSingle(
            competitionWeightCategory.id!,
            obfuscate: false,
          );
          // Phase and round with no bouts means, weight category has finished (including finals).
          expect(competitionWeightCategory.pairedRoundByPhase, [2, 0]);

          competitionBouts = await CompetitionBoutController().getByWeightCategory(
            competitionWeightCategory.id!,
            obfuscate: false,
          );
          expect(competitionBouts.length, 3);

          // Determine the ranking
          participants = await CompetitionParticipationController().getByWeightCategory(
            competitionWeightCategory.id!,
            obfuscate: false,
          );

          final baController = BoutActionController();
          final ranking = CompetitionWeightCategory.ranking(
            weightCategoryParticipants: participants,
            weightCategoryBoutsWithActions: await Future.wait(
              competitionBouts.map((cb) async {
                final bas = await baController.getByBout(cb.bout.id!, obfuscate: false);
                return MapEntry(cb, bas);
              }),
            ),
            phases: phases,
          );
          expect(ranking.length, 2);
          final firstRank = Rank(rank: 1, metric: RankingMetric(classificationPoints: 10, technicalPoints: 0, wins: 2));
          final secondRank = Rank(rank: 2, metric: RankingMetric(classificationPoints: 5, technicalPoints: 0, wins: 1));
          expect(ranking, {
            mockedData.competitionParticipation1.copyWith(weightCategory: competitionWeightCategory): [firstRank],
            mockedData.competitionParticipation2.copyWith(weightCategory: competitionWeightCategory): [secondRank],
          });
        });

        test('Nordic', () async {
          final resultRules = await BoutResultRuleController().getByBoutConfigId(
            configId: mockedData.competition.boutConfig.id!,
            obfuscate: false,
          );
          CompetitionWeightCategory competitionWeightCategory = mockedData.competitionWeightCategory;
          var participants = await createCompetitionParticipationsForWeightCategory(5, competitionWeightCategory);

          await CompetitionWeightCategoryController().generateInitialBouts(
            weightCategoryId: competitionWeightCategory.id!,
            obfuscate: false,
            isReset: false,
          );

          participants = await CompetitionParticipationController().getByWeightCategory(
            competitionWeightCategory.id!,
            obfuscate: false,
          );

          competitionWeightCategory = await CompetitionWeightCategoryController().getSingle(
            competitionWeightCategory.id!,
            obfuscate: false,
          );
          expect(competitionWeightCategory.competitionSystemAffiliation?.maxContestants, 5);
          final phases = await CompetitionSystemPhaseController().getByCompetitionSystemAffiliation(
            competitionWeightCategory.competitionSystemAffiliation!.id!,
            obfuscate: false,
          );
          expect(phases, [
            CompetitionSystemPhase(
              id: 2,
              pos: 0,
              isCrossOver: false,
              maxRank: 5,
              competitionSystem: CompetitionSystem.nordic,
              poolGroupCount: 1,
              competitionSystemAffiliation: competitionWeightCategory.competitionSystemAffiliation!,
            ),
          ]);

          // # Participants - 1 - 1 <= pairedRound <= # Participants
          final poolRoundIndex = 4;
          expect(competitionWeightCategory.pairedRoundByPhase, [poolRoundIndex]);

          List<CompetitionBout> competitionBouts = await CompetitionBoutController().getByWeightCategory(
            competitionWeightCategory.id!,
            obfuscate: false,
          );
          // 4 + 3 + 2 + 1
          expect(competitionBouts.length, 10);

          // Expected bouts per round
          Map<int?, Set<CompetitionBout>> groupCBoutsByRound = competitionBouts.groupSetsBy((element) => element.round);
          expect(groupCBoutsByRound.map((key, value) => MapEntry(key, value.length)), {0: 2, 1: 2, 2: 2, 3: 2, 4: 2});

          expect(competitionBouts.map((e) => e.phasePos), everyElement(0));
          expect(competitionBouts.map((e) => e.roundType), everyElement(RoundType.elimination));

          // After each round:
          int i = 0;
          while (groupCBoutsByRound[i] != null && groupCBoutsByRound[i]!.isNotEmpty) {
            // Generate after round i
            for (final cBout in groupCBoutsByRound[i]!) {
              final boutActions = List.generate(
                cBout.bout.id!,
                (index) => BoutAction(
                  actionType: BoutActionType.points,
                  pointCount: 1,
                  bout: cBout.bout,
                  duration: Duration.zero,
                  role: BoutRole.red,
                ),
              );

              final bout = cBout.bout.updateBoutResult(
                winnerRole: BoutRole.red,
                result: BoutResult.vpo,
                actions: boutActions,
                style: competitionWeightCategory.weightClass.style,
                rules: resultRules,
              );
              await _saveBout(bout, actions: boutActions);
            }

            competitionWeightCategory = await CompetitionWeightCategoryController().getSingle(
              competitionWeightCategory.id!,
              obfuscate: false,
            );

            if (i < poolRoundIndex) {
              expect(competitionWeightCategory.pairedRoundByPhase, [poolRoundIndex]);
            } else {
              // Phase without any bouts -> finished
              expect(competitionWeightCategory.pairedRoundByPhase, [poolRoundIndex, 0]);
            }

            competitionBouts = await CompetitionBoutController().getByWeightCategory(
              competitionWeightCategory.id!,
              obfuscate: false,
            );
            groupCBoutsByRound = competitionBouts.groupSetsBy((element) => element.round);

            expect(competitionBouts.length, 10);
            i++;
          }

          // Should not generate an additional round (roundIndex + 1):
          expect(i, poolRoundIndex + 1);

          // Determine the ranking
          participants = await CompetitionParticipationController().getByWeightCategory(
            competitionWeightCategory.id!,
            obfuscate: false,
          );

          final baController = BoutActionController();
          final ranking = CompetitionWeightCategory.ranking(
            weightCategoryParticipants: participants,
            weightCategoryBoutsWithActions: await Future.wait(
              competitionBouts.map((cb) async {
                final bas = await baController.getByBout(cb.bout.id!, obfuscate: false);
                return MapEntry(cb, bas);
              }),
            ),
            phases: phases,
          );
          expect(ranking.length, 5);
          expect(
            ranking,
            <CompetitionParticipation, List<Rank?>>{
              mockedData.competitionParticipation5.copyWith(poolDrawNumbers: [0]): [
                Rank(rank: 1, metric: RankingMetric(classificationPoints: 6, technicalPoints: 17, wins: 2)),
              ],
              mockedData.competitionParticipation1.copyWith(poolDrawNumbers: [4]): [
                Rank(rank: 2, metric: RankingMetric(classificationPoints: 6, technicalPoints: 13, wins: 2)),
              ],
              mockedData.competitionParticipation3.copyWith(poolDrawNumbers: [1]): [
                Rank(rank: 3, metric: RankingMetric(classificationPoints: 6, technicalPoints: 11, wins: 2)),
              ],
              mockedData.competitionParticipation2.copyWith(poolDrawNumbers: [3]): [
                Rank(rank: 4, metric: RankingMetric(classificationPoints: 6, technicalPoints: 9, wins: 2)),
              ],
              mockedData.competitionParticipation4.copyWith(poolDrawNumbers: [2]): [
                Rank(rank: 5, metric: RankingMetric(classificationPoints: 6, technicalPoints: 5, wins: 2)),
              ],
            }.map(
              (contestant, ranks) => MapEntry(
                contestant.copyWith(weightCategory: competitionWeightCategory, poolGroups: [0], contestantStatus: null),
                ranks,
              ),
            ),
          );
        });

        test('NordicTwoPools', () async {
          final resultRules = await BoutResultRuleController().getByBoutConfigId(
            configId: mockedData.competition.boutConfig.id!,
            obfuscate: false,
          );
          CompetitionWeightCategory competitionWeightCategory = mockedData.competitionWeightCategory;
          var participants = await createCompetitionParticipationsForWeightCategory(7, competitionWeightCategory);

          await CompetitionWeightCategoryController().generateInitialBouts(
            weightCategoryId: competitionWeightCategory.id!,
            obfuscate: false,
            isReset: false,
          );

          participants = await CompetitionParticipationController().getByWeightCategory(
            competitionWeightCategory.id!,
            obfuscate: false,
          );

          competitionWeightCategory = await CompetitionWeightCategoryController().getSingle(
            competitionWeightCategory.id!,
            obfuscate: false,
          );
          expect(competitionWeightCategory.competitionSystemAffiliation?.maxContestants, 7);
          final phases = await CompetitionSystemPhaseController().getByCompetitionSystemAffiliation(
            competitionWeightCategory.competitionSystemAffiliation!.id!,
            obfuscate: false,
          );
          expect(phases, [
            CompetitionSystemPhase(
              id: 3,
              pos: 0,
              isCrossOver: false,
              maxRank: 3,
              competitionSystem: CompetitionSystem.nordic,
              poolGroupCount: 2,
              competitionSystemAffiliation: competitionWeightCategory.competitionSystemAffiliation!,
            ),
            CompetitionSystemPhase(
              id: 4,
              pos: 1,
              isCrossOver: true,
              maxRank: 6,
              competitionSystem: CompetitionSystem.finals,
              poolGroupCount: 1,
              competitionSystemAffiliation: competitionWeightCategory.competitionSystemAffiliation!,
            ),
          ]);

          // ~ # Participants / 2
          expect(competitionWeightCategory.pairedRoundByPhase, [2]);

          List<CompetitionBout> competitionBouts = await CompetitionBoutController().getByWeightCategory(
            competitionWeightCategory.id!,
            obfuscate: false,
          );
          // (3 + 2 + 1) + (2 + 1) with 4 + 3 contestants
          expect(competitionBouts.length, 9);

          // Expected bouts per phase and round
          Map<int?, Map<int?, Set<CompetitionBout>>> groupByPhaseAndRound(Iterable<CompetitionBout> competitionBouts) =>
              competitionBouts
                  .groupSetsBy((cb) => cb.phasePos)
                  .map((phasePos, cBoutsOfPhase) => MapEntry(phasePos, cBoutsOfPhase.groupSetsBy((cb) => cb.round)));

          var groupCBoutsByPhaseAndRound = groupByPhaseAndRound(competitionBouts);
          expect(
            groupCBoutsByPhaseAndRound.map(
              (phasePos, byRound) => MapEntry(phasePos, byRound.map((round, cbs) => MapEntry(round, cbs.length))),
            ),
            {
              0: {0: 3, 1: 3, 2: 3},
            },
          );

          expect(competitionBouts.map((e) => e.phasePos), everyElement(0));
          expect(competitionBouts.map((e) => e.roundType), everyElement(RoundType.elimination));

          int phasePos = 0;
          while (groupCBoutsByPhaseAndRound[phasePos] != null && groupCBoutsByPhaseAndRound[phasePos]!.isNotEmpty) {
            var boutsOfPhase = groupCBoutsByPhaseAndRound[phasePos];

            int round = 0;
            while (boutsOfPhase?[round] != null && boutsOfPhase![round]!.isNotEmpty) {
              // Generate after round i
              for (final cBout in boutsOfPhase[round]!) {
                final boutActions = List.generate(
                  cBout.bout.id!,
                  (index) => BoutAction(
                    actionType: BoutActionType.points,
                    pointCount: 1,
                    bout: cBout.bout,
                    duration: Duration.zero,
                    role: BoutRole.red,
                  ),
                );

                final bout = cBout.bout.updateBoutResult(
                  winnerRole: BoutRole.red,
                  result: BoutResult.vpo,
                  actions: boutActions,
                  style: competitionWeightCategory.weightClass.style,
                  rules: resultRules,
                );
                await _saveBout(bout, actions: boutActions);
              }

              competitionWeightCategory = await CompetitionWeightCategoryController().getSingle(
                competitionWeightCategory.id!,
                obfuscate: false,
              );
              competitionBouts = await CompetitionBoutController().getByWeightCategory(
                competitionWeightCategory.id!,
                obfuscate: false,
              );
              groupCBoutsByPhaseAndRound = groupByPhaseAndRound(competitionBouts);
              boutsOfPhase = groupCBoutsByPhaseAndRound[phasePos];

              final pairedRoundByPhaseAndPos = {
                // PhasePos
                0: {
                  // Round: (Currently paired rounds, #bouts)
                  0: ([2], 9),
                  1: ([2], 9),
                  // Generated 2 additional bouts for semi-finals, 1 for final rank (5 + 6)
                  2: ([2, 0], 12),
                },
                // Generated 2 additional bouts for finals (1 + 2, 3 + 4)
                1: {
                  0: ([2, 1], 14),
                  // Next phase with round 0 means all bouts have finished.
                  1: ([2, 1, 0], 14),
                },
              };

              final result = pairedRoundByPhaseAndPos[phasePos]![round]!;
              expect(competitionWeightCategory.pairedRoundByPhase, result.$1);
              expect(competitionBouts.length, result.$2);

              round++;
            }

            phasePos++;
          }

          // Should not generate an additional phase (phases.length - 1 (pos) + 1 (last addition)):
          expect(phasePos, phases.length);

          // Determine the ranking
          participants = await CompetitionParticipationController().getByWeightCategory(
            competitionWeightCategory.id!,
            obfuscate: false,
          );

          final baController = BoutActionController();
          final ranking = CompetitionWeightCategory.sortedRanking(
            weightCategoryParticipants: participants,
            weightCategoryBoutsWithActions: await Future.wait(
              competitionBouts.map((cb) async {
                final bas = await baController.getByBout(cb.bout.id!, obfuscate: false);
                return MapEntry(cb, bas);
              }),
            ),
            phases: phases,
          );
          expect(ranking.length, 7);
          expect(
            ranking,
            {
              mockedData.competitionParticipation7.copyWith(poolDrawNumbers: [0], poolGroups: [0, 0]): [
                Rank(rank: 2, metric: RankingMetric(classificationPoints: 3, technicalPoints: 6, wins: 1)),
                Rank(rank: 1, metric: RankingMetric(classificationPoints: 6, technicalPoints: 24, wins: 2)),
              ],
              mockedData.competitionParticipation4.copyWith(poolDrawNumbers: [3], poolGroups: [0, 0]): [
                Rank(rank: 1, metric: RankingMetric(classificationPoints: 9, technicalPoints: 9, wins: 3)),
                Rank(rank: 2, metric: RankingMetric(classificationPoints: 3, technicalPoints: 10, wins: 1)),
              ],
              mockedData.competitionParticipation3.copyWith(poolDrawNumbers: [2], poolGroups: [1, 0]): [
                Rank(rank: 2, metric: RankingMetric(classificationPoints: 3, technicalPoints: 8, wins: 1)),
                Rank(rank: 3, metric: RankingMetric(classificationPoints: 3, technicalPoints: 14, wins: 1)),
              ],
              mockedData.competitionParticipation5.copyWith(poolDrawNumbers: [0], poolGroups: [1, 0]): [
                Rank(rank: 1, metric: RankingMetric(classificationPoints: 3, technicalPoints: 9, wins: 1)),
                Rank(rank: 4, metric: RankingMetric(classificationPoints: 0, technicalPoints: 0, wins: 0)),
              ],
              mockedData.competitionParticipation1.copyWith(poolDrawNumbers: [2], poolGroups: [0, 0]): [
                Rank(rank: 3, metric: RankingMetric(classificationPoints: 3, technicalPoints: 4, wins: 1)),
                Rank(rank: 5, metric: RankingMetric(classificationPoints: 3, technicalPoints: 12, wins: 1)),
              ],
              mockedData.competitionParticipation6.copyWith(poolDrawNumbers: [1], poolGroups: [1, 0]): [
                Rank(rank: 3, metric: RankingMetric(classificationPoints: 3, technicalPoints: 7, wins: 1)),
                Rank(rank: 6, metric: RankingMetric(classificationPoints: 0, technicalPoints: 0, wins: 0)),
              ],
              mockedData.competitionParticipation2.copyWith(poolDrawNumbers: [1], poolGroups: [0]): [
                Rank(rank: 4, metric: RankingMetric(classificationPoints: 3, technicalPoints: 2, wins: 1)),
              ],
            }.map(
              (contestant, ranks) => MapEntry(
                contestant.copyWith(weightCategory: competitionWeightCategory, contestantStatus: null),
                ranks,
              ),
            ),
          );
        });
      });
    });
  });
}

Future<void> _saveBout(Bout thirdBout, {List<BoutAction> actions = const []}) async {
  await BoutActionController().createMany(actions);
  if (thirdBout.r != null) await AthleteBoutStateController().updateSingle(thirdBout.r!);
  if (thirdBout.b != null) await AthleteBoutStateController().updateSingle(thirdBout.b!);
  await BoutController().updateSingle(thirdBout);
  await BoutController().processOnResult(thirdBout);
}
