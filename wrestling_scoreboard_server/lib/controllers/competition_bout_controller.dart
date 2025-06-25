import 'package:collection/collection.dart';
import 'package:postgres/postgres.dart' as psql;
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_action_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/orderable_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_participation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_weight_category_controller.dart';
import 'package:wrestling_scoreboard_server/utils/competition_system_algorithms.dart';

class CompetitionBoutController extends ShelfController<CompetitionBout> with OrderableController<CompetitionBout> {
  static final CompetitionBoutController _singleton = CompetitionBoutController._internal();

  factory CompetitionBoutController() {
    return _singleton;
  }

  CompetitionBoutController._internal() : super();

  @override
  Future<bool> deleteSingle(int id) async {
    final competitionBoutRaw = await getSingleRaw(id, obfuscate: false);
    final boutId = competitionBoutRaw['bout_id'] as int;
    await BoutController().deleteSingle(boutId);
    return super.deleteSingle(id);
  }

  static String get _currentCompetitionBoutOfMatQuery => '''
        SELECT cb.* 
        FROM ${CompetitionBout.cTableName} as cb
        JOIN ${Bout.cTableName} AS b ON cb.bout_id = b.id
        WHERE cb.mat = @mat AND b.bout_result IS NULL;''';

  @override
  Future<Response> handlePostRequestSingle(Map<String, Object?> json) async {
    final updatedCompetitionBout = parseSingleJson<CompetitionBout>(json);
    final obfuscate = false;
    if (updatedCompetitionBout.bout.result == null) {
      if (updatedCompetitionBout.mat != null) {
        // Update bout mat
        // Prohibit from adding a bout to an already occupied mat
        final curCompetitionBoutsOfMat = await getManyFromQuery(
          _currentCompetitionBoutOfMatQuery,
          obfuscate: obfuscate,
          substitutionValues: {'mat': updatedCompetitionBout.mat},
        );
        // final operation = CRUD.values.byName(json['operation']);
        if (curCompetitionBoutsOfMat.isNotEmpty) {
          // Don't let occupy the mat with more than one bout
          final curCompetitionBout = curCompetitionBoutsOfMat.first;
          if (curCompetitionBout.id != json['id']) {
            // But only complain if the updated bout is not the current one on the mat
            return Response.badRequest(
              body:
                  'Mat ${updatedCompetitionBout.mat} is already occupied a CompetitionBout. Please add a bout result first:\n${curCompetitionBout.toJson()}',
            );
          }
        }
      }
    } else if (updatedCompetitionBout.weightCategory?.id != null) {
      final weightCategory = await CompetitionWeightCategoryController().getSingle(
        updatedCompetitionBout.weightCategory!.id!,
        obfuscate: obfuscate,
      );

      if (weightCategory.pairedRound != null &&
          updatedCompetitionBout.round != null &&
          updatedCompetitionBout.round! >= weightCategory.pairedRound!) {
        // Only compute if pairedRound is equal to round of updated bout
        if (updatedCompetitionBout.round! > weightCategory.pairedRound!) {
          throw Exception(
            'Round of bout $updatedCompetitionBout must be smaller or equal to paired round ${weightCategory.pairedRound}',
          );
        }

        final pastCompetitionBouts = await getByWeightCategory(
          updatedCompetitionBout.weightCategory!.id!,
          obfuscate: obfuscate,
        );
        final pastCompetitionBoutsWithActions = await Future.wait(
          pastCompetitionBouts.map(
            (cb) async => MapEntry(cb, await BoutActionController().getByBout(cb.bout.id!, obfuscate: obfuscate)),
          ),
        );
        final competitionBoutsOfRound = pastCompetitionBouts.where((cb) => cb.round == updatedCompetitionBout.round);

        if (competitionBoutsOfRound.every((cb) => cb.bout.result != null)) {
          // Every bout has a bout result, so can pair a new round
          RoundType roundType = updatedCompetitionBout.roundType;
          final pairedRound = weightCategory.pairedRound! + 1;

          final participations = await CompetitionParticipationController().getByWeightCategory(
            false,
            weightCategory.id!,
          );

          final poolParticipationGroups = participations.groupListsBy((participation) => participation.poolGroup);
          final List<CompetitionBout> createdCompetitionBouts = [];

          if (roundType == RoundType.elimination) {
            final pastEliminationBouts = Map.fromEntries(
              pastCompetitionBoutsWithActions.where((cb) => cb.key.roundType == RoundType.elimination),
            );
            for (final poolParticipations in poolParticipationGroups.values) {
              final poolCompetitionBouts = await _updatePoolCompetitionBouts(
                weightCategory: weightCategory,
                pairedRound: pairedRound,
                pastCompetitionBoutsWithActions: pastEliminationBouts,
                poolParticipations: poolParticipations,
              );
              createdCompetitionBouts.addAll(poolCompetitionBouts);
            }
            // If all pool bouts were finished
            if (createdCompetitionBouts.isEmpty) {
              // Calculate pool rankings
              final List<List<RankingMetric>> rankingByPool = [];
              for (final poolParticipations in poolParticipationGroups.values) {
                rankingByPool.add(
                  CompetitionWeightCategory.calculatePoolRanking(
                    poolParticipations,
                    pastEliminationBouts,
                    weightCategory.competitionSystem,
                  ),
                );
              }
              if (weightCategory.poolGroupCount >= 2) {
                // Slice pools in 2, so each can compete against another pool (in most cases there are only 2 pools anyways).
                final poolRankingSlices = rankingByPool.slices(2);
                // TODO: implement "across" mode.
                final isAcross = false;
                for (final poolRankingSlice in poolRankingSlices) {
                  // ignore: dead_code
                  if (isAcross) {
                    roundType = RoundType.semiFinals;
                    createdCompetitionBouts.addAll(
                      CompetitionWeightCategoryController.convertBoutsOfRound(
                        weightCategory,
                        // [Pool A][first] against [Pool B][second]
                        [poolRankingSlice[0][0].participation, poolRankingSlice[1][1].participation],
                        round: pairedRound,
                        boutIndexListOfRound: [(0, 1)],
                        roundType: roundType,
                      ),
                    );
                    createdCompetitionBouts.addAll(
                      CompetitionWeightCategoryController.convertBoutsOfRound(
                        weightCategory,
                        // [Pool A][second] against [Pool B][first]
                        [poolRankingSlice[0][1].participation, poolRankingSlice[1][0].participation],
                        round: pairedRound,
                        boutIndexListOfRound: [(0, 1)],
                        roundType: roundType,
                      ),
                    );
                    // TODO: pair finals
                  } else {
                    roundType = RoundType.finals;
                    int rank = 0;
                    while (rank < poolRankingSlice[0].length &&
                        rank < poolRankingSlice[1].length &&
                        rank < maxPoolFinalists) {
                      createdCompetitionBouts.addAll(
                        CompetitionWeightCategoryController.convertBoutsOfRound(
                          weightCategory,
                          // [Pool A][rank] against [Pool B][rank]
                          [poolRankingSlice[0][rank].participation, poolRankingSlice[1][rank].participation],
                          round: pairedRound,
                          boutIndexListOfRound: [(0, 1)],
                          roundType: roundType,
                          rank: rank,
                        ),
                      );
                      rank++;
                    }
                  }
                }
              }
            }
          }

          await CompetitionWeightCategoryController.createAndBroadcastBouts(createdCompetitionBouts, weightCategory);

          await CompetitionWeightCategoryController().updateSingle(weightCategory.copyWith(pairedRound: pairedRound));
        }
      }
    }
    return super.handlePostRequestSingle(json);
  }

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {'mat': psql.Type.smallInteger, 'round': psql.Type.smallInteger, 'rank': psql.Type.smallInteger};
  }

  Future<List<CompetitionBout>> getByWeightCategory(int id, {required bool obfuscate}) async {
    return await getMany(
      conditions: ['weight_category_id = @id'],
      substitutionValues: {'id': id},
      obfuscate: obfuscate,
    );
  }

  static const maxPoolFinalists = 3;

  Future<List<CompetitionBout>> _updatePoolCompetitionBouts({
    required CompetitionWeightCategory weightCategory,
    required List<CompetitionParticipation> poolParticipations,
    required Map<CompetitionBout, Iterable<BoutAction>> pastCompetitionBoutsWithActions,
    required int pairedRound,
  }) async {
    final roundType = RoundType.elimination;
    switch (weightCategory.competitionSystem) {
      case CompetitionSystem.singleElimination:
        final Set<CompetitionParticipation> nonEliminatedPoolParticipants = {};
        for (final participation in poolParticipations) {
          // Skip already excluded participants.
          if (participation.isExcluded) continue;
          // Eliminate participants with 2 or more losses.
          final participantLosses = pastCompetitionBoutsWithActions.keys.where((cb) {
            return (cb.bout.r?.membership == participation.membership && cb.bout.winnerRole != BoutRole.red) ||
                (cb.bout.b?.membership == participation.membership && cb.bout.winnerRole != BoutRole.blue);
          });
          if (participantLosses.isEmpty) {
            nonEliminatedPoolParticipants.add(participation);
          } else {
            await CompetitionParticipationController().updateSingle(
              participation.copyWith(contestantStatus: ContestantStatus.eliminated),
            );
          }
        }

        return CompetitionWeightCategoryController.convertBoutsOfRound(
          weightCategory,
          nonEliminatedPoolParticipants.toList(),
          round: pairedRound,
          boutIndexListOfRound: generateSingleEliminationRound(
            Iterable<int>.generate(nonEliminatedPoolParticipants.length).toList(),
          ),
          roundType: roundType,
        );
      case CompetitionSystem.doubleElimination:
        final List<int> winnerBracket = [];
        final List<int> looserBracket = [];
        final List<CompetitionParticipation> nonEliminatedPoolParticipants = [];
        for (final participation in poolParticipations) {
          // Skip already excluded participants.
          if (participation.isExcluded) continue;
          // Eliminate participants with 2 or more losses.
          final participantLosses = pastCompetitionBoutsWithActions.keys.where((cb) {
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
              roundType: roundType,
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
            roundType: roundType,
          );
        }
      case CompetitionSystem.nordicDoubleElimination:
        final Set<CompetitionParticipation> nonEliminatedPoolParticipants = {};
        final Set<CompetitionParticipation> eliminatedPoolParticipants = {};
        for (final participation in poolParticipations) {
          // Skip already excluded participants.
          if (participation.isExcluded) continue;
          // Eliminate participants with 2 or more losses.
          final participantLosses = pastCompetitionBoutsWithActions.keys.where((cb) {
            return (cb.bout.r?.membership == participation.membership && cb.bout.winnerRole != BoutRole.red) ||
                (cb.bout.b?.membership == participation.membership && cb.bout.winnerRole != BoutRole.blue);
          });
          if (participantLosses.length <= 1) {
            nonEliminatedPoolParticipants.add(participation);
          } else {
            eliminatedPoolParticipants.add(participation);
          }
        }

        if (nonEliminatedPoolParticipants.length < maxPoolFinalists) {
          // At least $rankedPoolCount participants need to be ranked.
          final ranking = CompetitionWeightCategory.calculateRankingByPoints(
            poolParticipations,
            pastCompetitionBoutsWithActions,
          );

          for (int i = 0; i < maxPoolFinalists && i < ranking.length; i++) {
            nonEliminatedPoolParticipants.add(ranking[i].participation);
            eliminatedPoolParticipants.remove(ranking[i].participation);
          }

          if (nonEliminatedPoolParticipants.length > maxPoolFinalists) {
            throw Exception(
              'Something went wrong during the pool pairing! More than $maxPoolFinalists participants left. Please investigate!\n$poolParticipations',
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
                pastCompetitionBoutsWithActions.keys.map((e) => {e.bout.r!.membership.id!, e.bout.b!.membership.id!}),
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
          round: pairedRound,
        );
      default:
        // Nothing to pair
        return [];
    }
  }

  @override
  Future<void> reorderBlocks({
    required Type orderType,
    required Type filterType,
    required int filterId,
    String? orderByStmt,
  }) {
    // Adjust round by subtracting all earlier skipped cycles
    orderByStmt ??= '''
      (t.round + (
        SELECT COUNT(*)
        FROM unnest(ot.skipped_cycles) AS sc
        WHERE sc <= t.round
      ))
    ''';
    return super.reorderBlocks(
      orderType: orderType,
      filterType: filterType,
      filterId: filterId,
      orderByStmt: orderByStmt,
    );
  }
}
