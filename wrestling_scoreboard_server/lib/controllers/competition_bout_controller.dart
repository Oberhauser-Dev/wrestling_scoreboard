import 'dart:collection';
import 'dart:convert';
import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:postgres/postgres.dart' as psql;
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_controller.dart';
import 'package:wrestling_scoreboard_server/utils/competition_system_algorithms.dart';

import 'competition_participation_controller.dart';
import 'competition_weight_category_controller.dart';
import 'entity_controller.dart';

class CompetitionBoutController extends ShelfController<CompetitionBout> {
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
  Future<Response> postRequestSingle(Request request, User? user) async {
    final message = await request.readAsString();
    try {
      final json = jsonDecode(message);
      final updatedCompetitionBout = parseSingleJson<CompetitionBout>(json);
      final obfuscate = user?.obfuscate ?? true;
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
              for (final poolParticipations in poolParticipationGroups.values) {
                final poolCompetitionBouts = await _updatePoolCompetitionBouts(
                  weightCategory: weightCategory,
                  pairedRound: pairedRound,
                  pastCompetitionBouts: pastCompetitionBouts,
                  poolParticipations: poolParticipations,
                );
                createdCompetitionBouts.addAll(poolCompetitionBouts);
              }
              // If all pool bouts were finished
              if (createdCompetitionBouts.isEmpty) {
                // Calculate pool rankings
                final List<List<(CompetitionParticipation, int, int)>> poolRankings = [];
                for (final poolParticipations in poolParticipationGroups.values) {
                  poolRankings.add(_calculateRanking(poolParticipations, pastCompetitionBouts));
                }
                if (weightCategory.poolGroupCount >= 2) {
                  // Slice pools in 2, so each can compete against another pool (in most cases there are only 2 pools anyways).
                  final poolRankingSlices = poolRankings.slices(2);
                  // TODO: implement "across" mode.
                  final isAcross = false;
                  for (final poolRankingSlice in poolRankingSlices) {
                    // ignore: dead_code
                    if (isAcross) {
                      roundType = RoundType.semiFinals;
                      createdCompetitionBouts.addAll(
                        CompetitionWeightCategoryController.convertBoutsOfRound(
                          weightCategory,
                          [poolRankingSlice[0][0].$1, poolRankingSlice[1][0].$1],
                          round: pairedRound,
                          boutIndexListOfRound: [(0, 1)],
                          roundType: roundType,
                        ),
                      );
                      createdCompetitionBouts.addAll(
                        CompetitionWeightCategoryController.convertBoutsOfRound(
                          weightCategory,
                          [poolRankingSlice[0][1].$1, poolRankingSlice[1][1].$1],
                          round: pairedRound,
                          boutIndexListOfRound: [(0, 1)],
                          roundType: roundType,
                        ),
                      );
                      // TODO: pair finals
                    } else {
                      roundType = RoundType.finals;
                      createdCompetitionBouts.addAll(
                        CompetitionWeightCategoryController.convertBoutsOfRound(
                          weightCategory,
                          [poolRankingSlice[0][0].$1, poolRankingSlice[1][1].$1],
                          round: pairedRound,
                          boutIndexListOfRound: [(0, 1)],
                          roundType: roundType,
                        ),
                      );
                      createdCompetitionBouts.addAll(
                        CompetitionWeightCategoryController.convertBoutsOfRound(
                          weightCategory,
                          [poolRankingSlice[0][1].$1, poolRankingSlice[1][0].$1],
                          round: pairedRound,
                          boutIndexListOfRound: [(0, 1)],
                          roundType: roundType,
                        ),
                      );
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
      return handlePostRequestSingle(json);
    } on FormatException catch (e) {
      final errMessage =
          'The data object of table "$tableName" could not be created. Check the format: $message'
          '\nFormatException: ${e.message}';
      logger.warning(errMessage.toString());
      return Response.badRequest(body: errMessage);
    }
  }

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {'mat': psql.Type.smallInteger, 'round': psql.Type.smallInteger};
  }

  Future<List<CompetitionBout>> getByWeightCategory(int id, {required bool obfuscate}) async {
    return await getMany(
      conditions: ['weight_category_id = @id'],
      substitutionValues: {'id': id},
      obfuscate: obfuscate,
    );
  }

  /// Calculate the ranking as tuple of (participant, classificationPoints, technicalPoints)
  List<(CompetitionParticipation, int, int)> _calculateRanking(
    Iterable<CompetitionParticipation> participations,
    Iterable<CompetitionBout> pastCompetitionBouts,
  ) {
    final List<(CompetitionParticipation, int, int)> ranking = [];
    for (final participant in participations) {
      final participantBoutsRed = pastCompetitionBouts.where(
        (bout) => bout.bout.r?.membership == participant.membership,
      );
      final participantBoutsBlue = pastCompetitionBouts.where(
        (bout) => bout.bout.b?.membership == participant.membership,
      );
      final classificationPoints =
          participantBoutsRed.fold<int>(
            0,
            (previousValue, element) => previousValue + (element.bout.r?.classificationPoints ?? 0),
          ) +
          participantBoutsBlue.fold<int>(
            0,
            (previousValue, element) => previousValue + (element.bout.b?.classificationPoints ?? 0),
          );
      // TODO: get all bout actions to sum up the technical points
      final technicalPoints = 0;
      ranking.add((participant, classificationPoints, technicalPoints));
      ranking.sort((a, b) {
        int cmp = b.$2.compareTo(a.$2);
        if (cmp != 0) return cmp;
        return b.$3.compareTo(a.$3);
      });
    }
    return ranking;
  }

  Future<List<CompetitionBout>> _updatePoolCompetitionBouts({
    required CompetitionWeightCategory weightCategory,
    required List<CompetitionParticipation> poolParticipations,
    required List<CompetitionBout> pastCompetitionBouts,
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
          final participantLosses = pastCompetitionBouts.where((cb) {
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
          final participantLosses = pastCompetitionBouts.where((cb) {
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
          final participantLosses = pastCompetitionBouts.where((cb) {
            return (cb.bout.r?.membership == participation.membership && cb.bout.winnerRole != BoutRole.red) ||
                (cb.bout.b?.membership == participation.membership && cb.bout.winnerRole != BoutRole.blue);
          });
          if (participantLosses.length <= 1) {
            nonEliminatedPoolParticipants.add(participation);
          } else {
            eliminatedPoolParticipants.add(participation);
          }
        }

        if (nonEliminatedPoolParticipants.length <= 2) {
          final ranking = _calculateRanking(poolParticipations, pastCompetitionBouts);
          nonEliminatedPoolParticipants.add(ranking[0].$1);
          eliminatedPoolParticipants.remove(ranking[0].$1);
          nonEliminatedPoolParticipants.add(ranking[1].$1);
          eliminatedPoolParticipants.remove(ranking[1].$1);
          nonEliminatedPoolParticipants.add(ranking[2].$1);
          eliminatedPoolParticipants.remove(ranking[2].$1);

          if (nonEliminatedPoolParticipants.length > 3) {
            throw Exception(
              'Something went wrong during the pool pairing! More than 3 participants left. Please investigate!\n$poolParticipations',
            );
          }
        }

        // Set status of newly eliminated participants
        for (final participation in eliminatedPoolParticipants) {
          await CompetitionParticipationController().updateSingle(
            participation.copyWith(contestantStatus: ContestantStatus.eliminated),
          );
        }

        // Calculate a nordic system with the remaining participants.
        final rounds = CompetitionWeightCategoryController.convertBouts(
          weightCategory,
          nonEliminatedPoolParticipants.toList(),
          boutIndexList: generateBergerTable(nonEliminatedPoolParticipants.length),
          roundType: RoundType.elimination,
          roundShift: pairedRound,
        );
        var remainingBouts = rounds.expand((element) => element).toList();
        final pastPairingIds = _comparableHashSet(
          pastCompetitionBouts.map((e) => {e.bout.r?.membership.id, e.bout.b?.membership.id}),
        );
        // Skip all bouts, which already have taken place.
        remainingBouts.removeWhere((remainingBout) {
          final pIdSet = {remainingBout.bout.r?.membership.id, remainingBout.bout.b?.membership.id};
          return pastPairingIds.contains(pIdSet);
        });
        final maxBoutCount = math.min(remainingBouts.length, nonEliminatedPoolParticipants.length ~/ 2);
        final List<CompetitionBout> roundBouts = [];
        for (int i = 0; roundBouts.length <= maxBoutCount && i < remainingBouts.length; i++) {
          // Skip a bout, if one of its participant already has a fight in the upcoming round.
          final boutToAdd = remainingBouts[i];
          final upcomingMembershipIds = roundBouts
              .map((e) => {e.bout.r?.membership.id, e.bout.b?.membership.id})
              .expand((element) => element);
          if (!(upcomingMembershipIds.contains(boutToAdd.bout.r?.membership.id) ||
              upcomingMembershipIds.contains(boutToAdd.bout.b?.membership.id))) {
            roundBouts.add(boutToAdd);
          }
        }
        // TODO: If the max bout count cannot be fulfilled, replace the last added item with the next possible one.
        // TODO: If the max bout count still cannot be fulfilled, recursively remove the last 2[,3,...,n] items and replace with the next possible ones, until the max bout count is matched, or keep the last possible combination.
        return roundBouts;
      default:
        // Nothing to pair
        return [];
    }
  }

  HashSet<Set<int?>> _comparableHashSet(Iterable<Set<int?>> values) =>
      HashSet<Set<int?>>(equals: DeepCollectionEquality().equals)..addAll(values);
}
