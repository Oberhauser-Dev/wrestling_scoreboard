import 'dart:collection';
import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:postgres/postgres.dart' as psql;
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/athlete_bout_state_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_action_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/exceptions.dart';
import 'package:wrestling_scoreboard_server/controllers/common/orderable_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/websocket_handler.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_bout_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_participation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_system_affiliation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_system_phase_controller.dart';
import 'package:wrestling_scoreboard_server/request.dart';
import 'package:wrestling_scoreboard_server/utils/competition_system_algorithms.dart';

class CompetitionWeightCategoryController extends ShelfController<CompetitionWeightCategory>
    with OrderableController<CompetitionWeightCategory> {
  static final CompetitionWeightCategoryController _singleton = CompetitionWeightCategoryController._internal();

  factory CompetitionWeightCategoryController() {
    return _singleton;
  }

  CompetitionWeightCategoryController._internal() : super();

  @override
  Future<Response> handlePostRequestSingle(Map<String, Object?> json) async {
    // If updating the skipped_cycles, then also update the competition bout order.
    final updatedCompetitionWeightCategory = parseSingleJson<CompetitionWeightCategory>(json);

    CompetitionWeightCategory? oldCompetitionWeightCategory;
    final operation = CRUD.values.byName(json['operation'] as String);
    if (operation == CRUD.update) {
      oldCompetitionWeightCategory = await getSingle(updatedCompetitionWeightCategory.id!, obfuscate: false);
    }

    // Need to update before further sorting calculations
    final response = await super.handlePostRequestSingle(json);

    // There are probably no bouts to sort, if no competition_weight_category was present
    if (oldCompetitionWeightCategory != null &&
        !SetEquality().equals(
          oldCompetitionWeightCategory.skippedCycles.toSet(),
          updatedCompetitionWeightCategory.skippedCycles.toSet(),
        )) {
      await CompetitionBoutController().reorderBlocks(
        orderType: CompetitionWeightCategory,
        filterType: Competition,
        filterId: updatedCompetitionWeightCategory.competition.id!,
      );
    }
    return response;
  }

  @override
  Future<Response> postRequestReorder(Request request, User? user, String idAsStr) async {
    final response = await super.postRequestReorder(request, user, idAsStr);
    final filterTypes = request.filterTypes.map((ft) => getTypeFromTableName(ft)).toList();
    final filterIds = request.filterIds;
    for (int i = 0; i < filterTypes.length; i++) {
      await CompetitionBoutController().reorderBlocks(
        orderType: CompetitionWeightCategory,
        filterType: filterTypes[i],
        filterId: filterIds[i],
      );
    }
    return response;
  }

  /// isReset: delete all previous Bouts and CompetitionBouts, else reuse the states
  Future<Response> postGenerateBouts(Request request, User? user, String id) async {
    final bool obfuscate = user?.obfuscate ?? true;
    // TODO: option to reset, override existing bouts if present, keep athlete bout state.
    final isReset = (request.url.queryParameters['isReset'] ?? '').parseBool();
    final weightCategoryId = int.parse(id);

    await generateInitialBouts(weightCategoryId: weightCategoryId, obfuscate: obfuscate, isReset: isReset);

    return Response.ok('{"status": "success"}');
  }

  Future<void> generateInitialBouts({
    required int weightCategoryId,
    required bool obfuscate,
    required bool isReset,
  }) async {
    CompetitionWeightCategory competitionWeightCategory = (await getSingle(weightCategoryId, obfuscate: false));

    final oldCompetitionBouts = await CompetitionBoutController().getByWeightCategory(
      competitionWeightCategory.id!,
      obfuscate: obfuscate,
    );
    if (isReset) {
      await Future.forEach(oldCompetitionBouts, (CompetitionBout competitionBout) async {
        if (competitionBout.id != null) {
          await CompetitionBoutController().deleteSingle(competitionBout.id!);
          // Bout, AthleteBoutState and BoutActions are deleted subsequently
        }
      });
    } else {
      // TODO: just delete those who aren't reused any more
      await Future.forEach(oldCompetitionBouts, (CompetitionBout competitionBout) async {
        if (competitionBout.id != null) {
          await CompetitionBoutController().deleteSingle(competitionBout.id!);
          // Bout, AthleteBoutState and BoutActions are deleted subsequently
        }
      });
    }

    List<CompetitionParticipation> participations = await CompetitionParticipationController().getByWeightCategory(
      competitionWeightCategory.id!,
      obfuscate: false,
    );
    // Reset elimination
    participations = participations
        .map(
          (e) => e.copyWith(
            contestantStatus: e.contestantStatus == ContestantStatus.eliminated ? null : e.contestantStatus,
          ),
        )
        .toList();

    participations.removeWhere((element) => element.isExcluded);
    if (participations.isEmpty) {
      throw Exception('No eligible contestants found to pair: ${competitionWeightCategory.name}');
    }

    CompetitionSystemAffiliation? competitionSystemAffiliation = competitionWeightCategory.competitionSystemAffiliation;
    if (competitionSystemAffiliation == null || isReset) {
      final competitionSystemAffiliations = await CompetitionSystemAffiliationController().getByCompetition(
        competitionWeightCategory.competition.id!,
        obfuscate: obfuscate,
      );
      // Sort DESC
      competitionSystemAffiliations.sort(
        (a, b) => (b.maxContestants ?? double.infinity).compareTo(a.maxContestants ?? double.infinity),
      );
      // Get the competition system affiliation, which matches the max contestants
      for (final csa in competitionSystemAffiliations) {
        if (participations.length > (csa.maxContestants ?? double.infinity)) break;
        competitionSystemAffiliation = csa;
      }
    }
    if (competitionSystemAffiliation?.id == null) {
      throw InvalidParameterException(
        'No matching competition system affiliation found for weight category ${competitionWeightCategory.name}',
      );
    }

    final phases = await CompetitionSystemPhaseController().getByCompetitionSystemAffiliation(
      competitionSystemAffiliation!.id!,
      obfuscate: obfuscate,
    );
    if (phases.isEmpty) {
      throw InvalidParameterException(
        'No matching competition system phases found for weight category ${competitionWeightCategory.name}',
      );
    }

    competitionWeightCategory = competitionWeightCategory.copyWith(
      competitionSystemAffiliation: competitionSystemAffiliation,
    );

    // Make draw numbers random:
    participations.shuffle(MockableRandom.create());

    await _generateInitialBoutsOfPhase(
      phase: phases.first,
      competitionWeightCategory: competitionWeightCategory,
      contestantsByPoolGroup: participations
          .slices((participations.length / phases.first.poolGroupCount).ceil())
          .toList(),
    );
  }

  static Future<void> createAndBroadcastBouts(List<CompetitionBout> createdBouts) async {
    for (final element in createdBouts.indexed) {
      final (index, competitionBout) = element;
      Bout bout = competitionBout.bout;
      if (bout.r != null) {
        bout = bout.copyWith(r: await AthleteBoutStateController().createSingleReturn(bout.r!));
      }
      if (bout.b != null) {
        bout = bout.copyWith(b: await AthleteBoutStateController().createSingleReturn(bout.b!));
      }
      bout = await BoutController().createSingleReturn(bout);
      createdBouts[index] = await CompetitionBoutController().createSingleReturn(competitionBout.copyWith(bout: bout));
    }

    // Broadcast updated list of competition and weight class.
    if (createdBouts.isNotEmpty) broadcastDependants(createdBouts.first);
  }

  static List<List<CompetitionBout>> convertBouts(
    CompetitionWeightCategory weightCategory,
    List<CompetitionParticipation> participations, {
    required List<List<(int?, int?)>> boutIndexList,
    required RoundType roundType,
    required int phasePos,
    int roundShift = 0,
  }) {
    return boutIndexList.indexed.map((indexedRoundBouts) {
      final (round, boutsOfRound) = indexedRoundBouts;
      return convertBoutsOfRound(
        weightCategory,
        participations,
        boutIndexListOfRound: boutsOfRound,
        round: roundShift + round,
        roundType: roundType,
        phasePos: phasePos,
      );
    }).toList();
  }

  /// The [boutIndexListOfRound] is the list of bouts referencing the index in [participations] list.
  static List<CompetitionBout> convertBoutsOfRound(
    CompetitionWeightCategory weightCategory,
    List<CompetitionParticipation> participations, {
    required List<(int?, int?)> boutIndexListOfRound,
    required int round,
    required RoundType roundType,
    required int phasePos,
    int? rank,
  }) {
    return boutIndexListOfRound.indexed
        .map((indexedBoutTuple) {
          final (boutIndex, boutTuple) = indexedBoutTuple;
          final (rIndex, bIndex) = boutTuple;
          if (rIndex == null || bIndex == null) return null;
          if (participations[rIndex].isExcluded || participations[bIndex].isExcluded) return null;
          return CompetitionBout(
            competition: weightCategory.competition,
            pos: (round * participations.length) + boutIndex,
            weightCategory: weightCategory,
            round: round,
            bout: Bout(
              organization: weightCategory.competition.organization,
              r: AthleteBoutState(membership: participations[rIndex].membership),
              b: AthleteBoutState(membership: participations[bIndex].membership),
            ),
            roundType: roundType,
            rank: rank,
            phasePos: phasePos,
          );
        })
        .nonNulls
        .toList();
  }

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {'paired_round_by_phase': psql.Type.smallIntegerArray, 'skipped_cycles': psql.Type.smallIntegerArray};
  }

  List<CompetitionParticipation> _drawNumberInPool(List<CompetitionParticipation> participations, {int? pool}) {
    final List<CompetitionParticipation> updatedParticipations = [];
    for (final participationIndexed in participations.indexed) {
      final (drawNumber, participation) = participationIndexed;
      final updatedParticipation = participation.copyWith(
        poolDrawNumbers: [...participation.poolDrawNumbers, drawNumber],
        poolGroups: [...participation.poolGroups, pool ?? 0],
      );
      updatedParticipations.add(updatedParticipation);
    }
    return updatedParticipations;
  }

  List<CompetitionParticipation> _assignPool(List<CompetitionParticipation> participations, {required int pool}) {
    return participations.map((e) => e.copyWith(poolGroups: [...e.poolGroups, pool])).toList();
  }

  Future<void> generateSubsequence(
    CompetitionWeightCategory weightCategory, {
    required int round,
    required int phasePos,
  }) async {
    final obfuscate = false;
    final pastCompetitionBouts = await CompetitionBoutController().getByWeightCategory(
      weightCategory.id!,
      obfuscate: obfuscate,
    );
    final competitionBoutsOfRound = pastCompetitionBouts.where((cb) => cb.phasePos == phasePos && cb.round == round);

    if (competitionBoutsOfRound.every((cb) => cb.bout.result != null)) {
      final pastCompetitionBoutsWithActions = await Future.wait(
        pastCompetitionBouts
            .where((cb) => cb.phasePos == phasePos && cb.round != null && cb.round! <= round)
            .map((cb) async => MapEntry(cb, await BoutActionController().getByBout(cb.bout.id!, obfuscate: obfuscate))),
      );

      // Every bout has a bout result, so can pair a new round
      final pairedRoundsByPhase = weightCategory.pairedRoundByPhase.toList();
      final pairedRound = pairedRoundsByPhase[phasePos] + 1;

      final participations = await CompetitionParticipationController().getByWeightCategory(
        weightCategory.id!,
        obfuscate: false,
      );

      final poolParticipationGroups = participations
          // Only consider contestants, who qualified for the pool.
          .where((contestant) => (contestant.poolGroups.length - 1) >= phasePos)
          .groupListsBy((participation) => participation.poolGroups[phasePos]);
      final List<CompetitionBout> createdCompetitionBouts = [];

      final phases = await CompetitionSystemPhaseController().getByCompetitionSystemAffiliation(
        weightCategory.competitionSystemAffiliation!.id!,
        obfuscate: obfuscate,
      );
      final phase = phases[phasePos];
      assert(phase.pos == phasePos);

      for (final poolParticipations in poolParticipationGroups.values) {
        final poolCompetitionBouts = await _updateBoutsOfPhase(
          weightCategory: weightCategory,
          pairedRound: pairedRound,
          pastCompetitionBoutsWithActions: pastCompetitionBoutsWithActions,
          poolParticipations: poolParticipations,
          phase: phase,
        );
        createdCompetitionBouts.addAll(poolCompetitionBouts);
      }

      if (createdCompetitionBouts.isNotEmpty) {
        await CompetitionWeightCategoryController.createAndBroadcastBouts(createdCompetitionBouts);

        pairedRoundsByPhase[phasePos] = pairedRound;
        await CompetitionWeightCategoryController().updateSingle(
          weightCategory.copyWith(pairedRoundByPhase: pairedRoundsByPhase),
        );
      } else {
        // If all bouts of phase are finished -> Start new phase.
        final nextPhasePos = phase.pos + 1;
        if (nextPhasePos < phases.length) {
          // Calculate pool rankings
          final List<LinkedHashMap<CompetitionParticipation, RankingMetric>> rankingByPool = [];
          final mapPastPhaseBouts = Map.fromEntries(pastCompetitionBoutsWithActions);
          for (final poolParticipations in poolParticipationGroups.values) {
            rankingByPool.add(
              CompetitionWeightCategory.calculatePoolRanking(
                poolParticipations,
                mapPastPhaseBouts,
                phase.competitionSystem,
              ),
            );
          }

          // Starting a new phase
          await _generateInitialBoutsOfPhase(
            competitionWeightCategory: weightCategory,
            // List of ranked contestants
            contestantsByPoolGroup: rankingByPool
                .map((e) => e.keys.toList().sublist(0, (phase.maxRank ?? 0) + 1))
                .toList(),
            phase: phases[nextPhasePos],
          );
        } else if (nextPhasePos == phases.length) {
          // If length of phases for weight category is greater than the possible affiliation phases, the weight category has finished all phases -> can rank all contestants.
          await updateSingle(weightCategory.copyWith(pairedRoundByPhase: [...weightCategory.pairedRoundByPhase, 0]));
        }
      }
    }
  }

  final _defaultMaxRankedFinalists = 3;

  Future<List<CompetitionBout>> _updateBoutsOfPhase({
    required CompetitionWeightCategory weightCategory,
    required List<CompetitionParticipation> poolParticipations,
    required List<MapEntry<CompetitionBout, Iterable<BoutAction>>> pastCompetitionBoutsWithActions,
    required int pairedRound,
    required CompetitionSystemPhase phase,
  }) async {
    final competitionSystem = phase.competitionSystem;
    final maxRankedFinalists = phase.maxRank ?? _defaultMaxRankedFinalists;

    switch (competitionSystem) {
      case CompetitionSystem.finals:
      case CompetitionSystem.singleElimination:
        final Set<CompetitionParticipation> nonEliminatedPoolParticipants = {};
        // If round types other than `finals` occur, further finals will be generated.
        final hasOnlyFinals = pastCompetitionBoutsWithActions
            .where((e) => e.key.round == pairedRound - 1)
            .every((e) => e.key.roundType == RoundType.finals);
        if (hasOnlyFinals) {
          // Finals are already finished, therefore can create a new phase or finish completely.
          return [];
        }

        final previousSemiFinals = pastCompetitionBoutsWithActions.where(
          (e) => e.key.round == pairedRound - 1 && e.key.roundType == RoundType.semiFinals,
        );
        if (previousSemiFinals.isNotEmpty) {
          // Semi-finals exists, so can create the according finals for 1+2, 3+4.
          final List<List<CompetitionParticipation>> ranking =
              CompetitionWeightCategory.calculateRankingByRoundWinsAndLosses(poolParticipations, previousSemiFinals);
          final List<CompetitionParticipation> rankingUpperBracket = [];
          final List<CompetitionParticipation> rankingLowerBracket = [];
          for (int rank = 0; rank < 2 && rank < ranking.length; rank++) {
            if (ranking[rank].length >= 2) {
              rankingUpperBracket.add(ranking[rank][0]);
              rankingLowerBracket.add(ranking[rank][1]);
            }
          }
          return _createFinals(
            weightCategory: weightCategory,
            pairedRound: pairedRound,
            rankingUpperBracket: rankingUpperBracket,
            rankingLowerBracket: rankingLowerBracket,
            phase: phase,
          );
        }

        assert(competitionSystem != CompetitionSystem.finals, 'Finals do not have previous rounds.');
        final ranking = CompetitionWeightCategory.calculateRankingByRoundWinsAndLosses(
          poolParticipations,
          pastCompetitionBoutsWithActions,
        );
        // Determine if there are only 2 or less contestants left, which have never lost.
        final isFinalsOrSemiFinals = ranking.isNotEmpty && ranking[0].length <= 2;
        if (isFinalsOrSemiFinals) {
          final List<CompetitionParticipation> rankingUpperBracket = [];
          final List<CompetitionParticipation> rankingLowerBracket = [];
          for (int rank = 0; rank < ranking.length; rank++) {
            for (int i = 0; i < ranking[rank].length; i++) {
              if (i.isEven) {
                rankingUpperBracket.add(ranking[rank][i]);
              } else {
                rankingLowerBracket.add(ranking[rank][i]);
              }
            }
          }

          return _createFinalsOrSemiFinals(
            pairedRound: pairedRound,
            rankingUpperBracket: rankingUpperBracket,
            rankingLowerBracket: rankingLowerBracket,
            weightCategory: weightCategory,
            phase: phase,
          );
        }

        // Create next round of single elimination round
        for (final (index, roundLosses) in ranking.indexed) {
          for (final participation in roundLosses) {
            // Skip already excluded participants.
            if (participation.isExcluded) continue;

            // Eliminate participants more than 1 loss.
            if (index <= 0) {
              // Index 0 means, participant never lost.
              nonEliminatedPoolParticipants.add(participation);
            } else {
              await CompetitionParticipationController().updateSingle(
                participation.copyWith(contestantStatus: ContestantStatus.eliminated),
              );
            }
          }
        }

        return CompetitionWeightCategoryController.convertBoutsOfRound(
          weightCategory,
          nonEliminatedPoolParticipants.toList(),
          round: pairedRound,
          boutIndexListOfRound: generateSingleEliminationRound(
            Iterable<int>.generate(nonEliminatedPoolParticipants.length).toList(),
          ),
          roundType: RoundType.elimination,
          phasePos: phase.pos,
        );
      case CompetitionSystem.doubleElimination:
        final List<int> winnerBracket = [];
        final List<int> looserBracket = [];
        final List<CompetitionParticipation> nonEliminatedPoolParticipants = [];
        for (final participation in poolParticipations) {
          // Skip already excluded participants.
          if (participation.isExcluded) continue;
          // Eliminate participants with 2 or more losses.
          final participantLosses = pastCompetitionBoutsWithActions.map((entry) => entry.key).where((cb) {
            return (cb.bout.r?.membership == participation.membership && cb.bout.winnerRole != BoutRole.red) ||
                (cb.bout.b?.membership == participation.membership && cb.bout.winnerRole != BoutRole.blue);
          });
          if (participantLosses.isEmpty) {
            winnerBracket.add(nonEliminatedPoolParticipants.length);
            nonEliminatedPoolParticipants.add(participation);
          } else if (participantLosses.length == 1) {
            looserBracket.add(nonEliminatedPoolParticipants.length);
            nonEliminatedPoolParticipants.add(participation);
          } else {
            await CompetitionParticipationController().updateSingle(
              participation.copyWith(contestantStatus: ContestantStatus.eliminated),
            );
          }
        }

        if (winnerBracket.length <= 1 && looserBracket.length <= 1) {
          if (winnerBracket.isNotEmpty && looserBracket.isNotEmpty) {
            // Add the final fight of winner and looser bracket
            return CompetitionWeightCategoryController.convertBoutsOfRound(
              weightCategory,
              nonEliminatedPoolParticipants,
              round: pairedRound,
              boutIndexListOfRound: [(winnerBracket.single, looserBracket.single)],
              roundType: RoundType.elimination,
              phasePos: phase.pos,
            );
          } else {
            // No bouts left -> finished
            return [];
          }
        } else {
          return CompetitionWeightCategoryController.convertBoutsOfRound(
            weightCategory,
            nonEliminatedPoolParticipants,
            round: pairedRound,
            boutIndexListOfRound: generateDoubleEliminationRound(
              winnerBracket: winnerBracket,
              looserBracket: looserBracket,
            ),
            roundType: RoundType.elimination,
            phasePos: phase.pos,
          );
        }
      case CompetitionSystem.nordicDoubleElimination:
        final Set<CompetitionParticipation> nonEliminatedPoolParticipants = {};
        final Set<CompetitionParticipation> eliminatedPoolParticipants = {};
        for (final participation in poolParticipations) {
          // Skip already excluded participants.
          if (participation.isExcluded) continue;
          // Eliminate participants with 2 or more losses.
          final participantLosses = pastCompetitionBoutsWithActions.map((e) => e.key).where((cb) {
            return (cb.bout.r?.membership == participation.membership && cb.bout.winnerRole != BoutRole.red) ||
                (cb.bout.b?.membership == participation.membership && cb.bout.winnerRole != BoutRole.blue);
          });
          if (participantLosses.length <= 1) {
            nonEliminatedPoolParticipants.add(participation);
          } else {
            eliminatedPoolParticipants.add(participation);
          }
        }

        if (nonEliminatedPoolParticipants.length < maxRankedFinalists) {
          // At least $maxRankedFinalists participants need to be ranked.
          final ranking = CompetitionWeightCategory.calculateRankingByPoints(
            poolParticipations,
            Map.fromEntries(pastCompetitionBoutsWithActions),
          );
          final rankingList = ranking.entries.toList();

          for (int i = 0; i < maxRankedFinalists && i < rankingList.length; i++) {
            nonEliminatedPoolParticipants.add(rankingList[i].key);
            eliminatedPoolParticipants.remove(rankingList[i].key);
          }

          if (nonEliminatedPoolParticipants.length > maxRankedFinalists) {
            throw Exception(
              'Something went wrong during the pool pairing! More than $maxRankedFinalists participants left. Please investigate!\n$poolParticipations',
            );
          }
        }

        // Set status of newly eliminated participants
        for (final participation in eliminatedPoolParticipants) {
          await CompetitionParticipationController().updateSingle(
            participation.copyWith(contestantStatus: ContestantStatus.eliminated),
          );
        }

        final nonEliminatedPoolParticipantsAsList = nonEliminatedPoolParticipants.toList();
        return CompetitionWeightCategoryController.convertBoutsOfRound(
          weightCategory,
          nonEliminatedPoolParticipantsAsList,
          boutIndexListOfRound:
              generateByeDoubleEliminationRound(
                nonEliminatedPoolParticipantsAsList.map((e) => e.membership.id!).toList(),
                pastCompetitionBoutsWithActions.map(
                  (e) => {e.key.bout.r!.membership.id!, e.key.bout.b!.membership.id!},
                ),
              ).map((boutMembershipIds) {
                // Convert membership id to index of participants list
                return (
                  nonEliminatedPoolParticipantsAsList.indexWhere(
                    (participant) => participant.membership.id == boutMembershipIds.$1,
                  ),
                  nonEliminatedPoolParticipantsAsList.indexWhere(
                    (participant) => participant.membership.id == boutMembershipIds.$2,
                  ),
                );
              }).toList(),
          roundType: RoundType.elimination,
          phasePos: phase.pos,
          round: pairedRound,
        );
      case CompetitionSystem.bestOfThree:
        final rankings = CompetitionWeightCategory.calculateRankingByPoints(
          poolParticipations,
          Map.fromEntries(pastCompetitionBoutsWithActions),
        );
        if (rankings.isNotEmpty &&
            rankings.entries.every((ranking) => ranking.value.wins == rankings.entries.first.value.wins)) {
          // Everyone has one win, so need to add a final bout
          return CompetitionWeightCategoryController.convertBoutsOfRound(
            weightCategory,
            poolParticipations,
            boutIndexListOfRound: generateSingleEliminationRound(
              Iterable<int>.generate(poolParticipations.length).toList(),
            ),
            round: pairedRound,
            roundType: RoundType.finals,
            phasePos: phase.pos,
          );
        }
        return [];
      case CompetitionSystem.nordic:
        // Nothing to pair
        return [];
    }
  }

  /// With [alignFinals] you can postpone the finals of [5+] to be aligned with the round of the finals which have a cross-over semi-finals first.
  /// This usually is not desired to accelerate the tournament.
  List<CompetitionBout> _createFinalsOrSemiFinals({
    required int pairedRound,
    required List<CompetitionParticipation> rankingUpperBracket,
    required List<CompetitionParticipation> rankingLowerBracket,
    required CompetitionWeightCategory weightCategory,
    required CompetitionSystemPhase phase,
    bool? isCrossOver,
    bool alignFinals = false,
  }) {
    isCrossOver ??= phase.isCrossOver;
    if (isCrossOver && rankingUpperBracket.length >= 2 && rankingLowerBracket.length >= 2) {
      return [
        ...CompetitionWeightCategoryController.convertBoutsOfRound(
          weightCategory,
          // [Pool A][first] against [Pool B][second]
          [rankingUpperBracket[0], rankingLowerBracket[1]],
          round: pairedRound,
          boutIndexListOfRound: [(0, 1)],
          roundType: RoundType.semiFinals,
          phasePos: phase.pos,
        ),
        ...CompetitionWeightCategoryController.convertBoutsOfRound(
          weightCategory,
          // [Pool A][second] against [Pool B][first]
          [rankingUpperBracket[1], rankingLowerBracket[0]],
          round: pairedRound,
          boutIndexListOfRound: [(0, 1)],
          roundType: RoundType.semiFinals,
          phasePos: phase.pos,
        ),
        // In semi finals, we pair the additional final rounds, which are not in cross-over:
        ..._createFinals(
          rank: 2,
          pairedRound: alignFinals ? (pairedRound + 1) : pairedRound,
          rankingUpperBracket: rankingUpperBracket,
          rankingLowerBracket: rankingLowerBracket,
          weightCategory: weightCategory,
          phase: phase,
        ),
      ];
    } else {
      return _createFinals(
        pairedRound: pairedRound,
        rankingUpperBracket: rankingUpperBracket,
        rankingLowerBracket: rankingLowerBracket,
        weightCategory: weightCategory,
        phase: phase,
      );
    }
  }

  List<CompetitionBout> _createFinals({
    required int pairedRound,
    int rank = 0,
    required List<CompetitionParticipation> rankingUpperBracket,
    required List<CompetitionParticipation> rankingLowerBracket,
    required CompetitionWeightCategory weightCategory,
    required CompetitionSystemPhase phase,
  }) {
    final createdCompetitionBouts = <CompetitionBout>[];
    final maxRankedFinalists = phase.maxRank ?? _defaultMaxRankedFinalists;
    while (rank < rankingUpperBracket.length && rank < rankingLowerBracket.length && rank < maxRankedFinalists) {
      createdCompetitionBouts.addAll(
        CompetitionWeightCategoryController.convertBoutsOfRound(
          weightCategory,
          // [Pool A][rank] against [Pool B][rank]
          [rankingUpperBracket[rank], rankingLowerBracket[rank]],
          round: pairedRound,
          boutIndexListOfRound: [(0, 1)],
          roundType: RoundType.finals,
          phasePos: phase.pos,
          rank: rank,
        ),
      );
      rank++;
    }
    return createdCompetitionBouts;
  }

  Future<void> _generateInitialBoutsOfPhase({
    required CompetitionWeightCategory competitionWeightCategory,
    required CompetitionSystemPhase phase,
    required List<List<CompetitionParticipation>> contestantsByPoolGroup,
  }) async {
    final List<CompetitionBout> createdBouts = [];
    final List<CompetitionParticipation> updatedParticipations = [];
    switch (phase.competitionSystem) {
      case CompetitionSystem.nordic:
        int pairedRounds = 0;
        for (final poolParticipationsIndexed in contestantsByPoolGroup.indexed) {
          final (poolGroup, poolParticipations) = poolParticipationsIndexed;
          final updatedPoolParticipations = _drawNumberInPool(poolParticipations, pool: poolGroup);
          updatedParticipations.addAll(updatedPoolParticipations);
          final rounds = convertBouts(
            competitionWeightCategory,
            updatedPoolParticipations,
            boutIndexList: generateBergerTable(updatedPoolParticipations.length),
            roundType: RoundType.elimination,
            phasePos: phase.pos,
          );
          pairedRounds = math.max(rounds.length, pairedRounds);
          createdBouts.addAll(rounds.expand((element) => element).toList());
        }
        competitionWeightCategory = competitionWeightCategory.copyWith(
          // The index of the paired round is different from the length.
          // E.g. if no round was paired (0), the index is still null.
          // If one round was paired (1), the index is 0.
          pairedRoundByPhase: [
            ...competitionWeightCategory.pairedRoundByPhase,
            if (pairedRounds > 0) (pairedRounds - 1),
          ],
        );
      case CompetitionSystem.finals:
        if (phase.poolGroupCount > 1) {
          throw Exception(
            'Providing finals with more than one pool group is not supported. Please choose another competition system.',
          );
        }
        if (contestantsByPoolGroup.length != 2) {
          throw Exception('Finals do not have exactly two brackets groups.');
        }
        // Only have one pool (0)
        final firstBracket = _assignPool(contestantsByPoolGroup[0], pool: 0);
        final secondBracket = _assignPool(contestantsByPoolGroup[1], pool: 0);
        updatedParticipations.addAll(firstBracket);
        updatedParticipations.addAll(secondBracket);
        createdBouts.addAll(
          _createFinalsOrSemiFinals(
            pairedRound: 0,
            rankingUpperBracket: firstBracket,
            rankingLowerBracket: secondBracket,
            weightCategory: competitionWeightCategory,
            phase: phase,
          ),
        );
        competitionWeightCategory = competitionWeightCategory.copyWith(
          // Purposely only mark the first round as paired,
          // as if there were semi-finals, the finals still have to be generated,
          // although the bouts for the ranks from 5+ onwards probably are already paired.
          pairedRoundByPhase: [...competitionWeightCategory.pairedRoundByPhase, 0],
        );
      case CompetitionSystem.singleElimination:
        for (final poolParticipationsIndexed in contestantsByPoolGroup.indexed) {
          final (poolGroup, poolParticipations) = poolParticipationsIndexed;
          final updatedPoolParticipations = _drawNumberInPool(poolParticipations, pool: poolGroup);
          updatedParticipations.addAll(updatedPoolParticipations);
          final pairedRound = 0;

          // Only generate first round, as the others are not determined yet.
          createdBouts.addAll(
            convertBoutsOfRound(
              competitionWeightCategory,
              updatedPoolParticipations,
              boutIndexListOfRound: generateSingleEliminationRound(
                Iterable<int>.generate(updatedPoolParticipations.length).toList(),
              ),
              round: pairedRound,
              roundType: RoundType.elimination,
              phasePos: phase.pos,
            ),
          );
        }
        competitionWeightCategory = competitionWeightCategory.copyWith(
          pairedRoundByPhase: [...competitionWeightCategory.pairedRoundByPhase, 0],
        );
      case CompetitionSystem.doubleElimination:
        for (final poolParticipationsIndexed in contestantsByPoolGroup.indexed) {
          final (poolGroup, poolParticipations) = poolParticipationsIndexed;
          final updatedPoolParticipations = _drawNumberInPool(poolParticipations, pool: poolGroup);
          updatedParticipations.addAll(updatedPoolParticipations);
          // Only generate first round, as the winner and looser bracket will be determined after each round.
          createdBouts.addAll(
            convertBoutsOfRound(
              competitionWeightCategory,
              updatedPoolParticipations,
              boutIndexListOfRound: generateDoubleEliminationRound(
                winnerBracket: Iterable<int>.generate(updatedPoolParticipations.length).toList(),
              ),
              round: 0,
              roundType: RoundType.elimination,
              phasePos: phase.pos,
            ),
          );
        }
        competitionWeightCategory = competitionWeightCategory.copyWith(
          pairedRoundByPhase: [...competitionWeightCategory.pairedRoundByPhase, 0],
        );
      case CompetitionSystem.bestOfThree:
        for (final poolParticipationsIndexed in contestantsByPoolGroup.indexed) {
          final (poolGroup, poolParticipations) = poolParticipationsIndexed;
          final updatedPoolParticipations = _drawNumberInPool(poolParticipations, pool: poolGroup);
          updatedParticipations.addAll(updatedPoolParticipations);
          // Generate the first two rounds, as they can be determined.
          createdBouts.addAll(
            convertBoutsOfRound(
              competitionWeightCategory,
              updatedPoolParticipations,
              boutIndexListOfRound: generateSingleEliminationRound(
                Iterable<int>.generate(updatedPoolParticipations.length).toList(),
              ),
              round: 0,
              roundType: RoundType.elimination,
              phasePos: phase.pos,
            ),
          );
          createdBouts.addAll(
            convertBoutsOfRound(
              competitionWeightCategory,
              updatedPoolParticipations.reversed.toList(),
              boutIndexListOfRound: generateSingleEliminationRound(
                Iterable<int>.generate(updatedPoolParticipations.length).toList(),
              ),
              round: 1,
              roundType: RoundType.elimination,
              phasePos: phase.pos,
            ),
          );
        }
        competitionWeightCategory = competitionWeightCategory.copyWith(
          pairedRoundByPhase: [...competitionWeightCategory.pairedRoundByPhase, 1],
        );
      case CompetitionSystem.nordicDoubleElimination:
        for (final poolParticipationsIndexed in contestantsByPoolGroup.indexed) {
          final (poolGroup, poolParticipations) = poolParticipationsIndexed;
          final updatedPoolParticipations = _drawNumberInPool(poolParticipations, pool: poolGroup);
          updatedParticipations.addAll(updatedPoolParticipations);
          // Generate the first two rounds, as they can be determined.
          final rounds = convertBouts(
            competitionWeightCategory,
            updatedPoolParticipations,
            boutIndexList: generateBergerTable(updatedPoolParticipations.length, maxRounds: 2),
            roundType: RoundType.elimination,
            phasePos: phase.pos,
          );
          createdBouts.addAll(rounds.expand((element) => element));
        }
        competitionWeightCategory = competitionWeightCategory.copyWith(
          pairedRoundByPhase: [...competitionWeightCategory.pairedRoundByPhase, 1],
        );
    }

    await updateSingle(competitionWeightCategory);

    for (final participation in updatedParticipations) {
      await CompetitionParticipationController().updateSingle(participation);
    }

    await createAndBroadcastBouts(createdBouts);
  }
}
