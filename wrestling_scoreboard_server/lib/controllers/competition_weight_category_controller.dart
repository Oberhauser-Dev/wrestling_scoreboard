import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:postgres/postgres.dart' as psql;
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/athlete_bout_state_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/orderable_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/websocket_handler.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_bout_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_participation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_system_affiliation_controller.dart';
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
  Future<Response> generateBouts(Request request, User? user, String id) async {
    final bool obfuscate = user?.obfuscate ?? true;
    // TODO: option to reset, override existing bouts if present, keep athlete bout state.
    final isReset = (request.url.queryParameters['isReset'] ?? '').parseBool();
    CompetitionWeightCategory competitionWeightCategory = (await getSingle(int.parse(id), obfuscate: false));

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
      false,
      competitionWeightCategory.id!,
    );
    // Reset elimination
    participations =
        participations
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

    CompetitionSystem? competitionSystem = competitionWeightCategory.competitionSystem;
    int? poolGroupCount = competitionWeightCategory.poolGroupCount;
    if (competitionSystem == null || isReset) {
      final competitionSystemAffiliations = await CompetitionSystemAffiliationController().getByCompetition(
        obfuscate,
        competitionWeightCategory.competition.id!,
      );
      // Sort DESC
      competitionSystemAffiliations.sort(
        (a, b) => (b.maxContestants ?? double.infinity).compareTo(a.maxContestants ?? double.infinity),
      );
      CompetitionSystemAffiliation? competitionSystemAffiliation;
      // Get the competition system affiliation, which matches the max contestants
      for (final csa in competitionSystemAffiliations) {
        if (participations.length > (csa.maxContestants ?? double.infinity)) break;
        competitionSystemAffiliation = csa;
      }
      competitionSystem = competitionSystemAffiliation?.competitionSystem;
      poolGroupCount = competitionSystemAffiliation?.poolGroupCount;
    }
    if (competitionSystem == null || poolGroupCount == null) {
      throw Exception('No matching competition system found for competition ${competitionWeightCategory.competition}');
    }
    final List<CompetitionBout> createdBouts = [];
    final List<CompetitionParticipation> updatedParticipations = [];
    participations.shuffle(MockableRandom.create());
    switch (competitionSystem) {
      case CompetitionSystem.nordic:
        int pairedRounds = 0;
        final splittedParticipations = participations.slices((participations.length / poolGroupCount).ceil());
        for (final poolParticipationsIndexed in splittedParticipations.indexed) {
          final (poolGroup, poolParticipations) = poolParticipationsIndexed;
          final updatedPoolParticipations = _drawNumberAndPool(poolParticipations, pool: poolGroup);
          updatedParticipations.addAll(updatedPoolParticipations);
          final rounds = convertBouts(
            competitionWeightCategory,
            updatedPoolParticipations,
            boutIndexList: generateBergerTable(participations.length),
            roundType: RoundType.elimination,
          );
          pairedRounds = math.max(rounds.length, pairedRounds);
          createdBouts.addAll(rounds.expand((element) => element).toList());
        }
        competitionWeightCategory = competitionWeightCategory.copyWith(pairedRound: pairedRounds);
      case CompetitionSystem.singleElimination:
        final splittedParticipations = participations.slices((participations.length / poolGroupCount).ceil());
        for (final poolParticipationsIndexed in splittedParticipations.indexed) {
          final (poolGroup, poolParticipations) = poolParticipationsIndexed;
          final updatedPoolParticipations = _drawNumberAndPool(poolParticipations, pool: poolGroup);
          updatedParticipations.addAll(updatedPoolParticipations);
          // Only generate first round, as the others are not determined yet.
          createdBouts.addAll(
            convertBoutsOfRound(
              competitionWeightCategory,
              updatedPoolParticipations,
              boutIndexListOfRound: generateSingleEliminationRound(
                Iterable<int>.generate(updatedPoolParticipations.length).toList(),
              ),
              round: 0,
              roundType: RoundType.elimination,
            ),
          );
        }
        competitionWeightCategory = competitionWeightCategory.copyWith(pairedRound: 0);
      case CompetitionSystem.doubleElimination:
        final splittedParticipations = participations.slices((participations.length / poolGroupCount).ceil());
        for (final poolParticipationsIndexed in splittedParticipations.indexed) {
          final (poolGroup, poolParticipations) = poolParticipationsIndexed;
          final updatedPoolParticipations = _drawNumberAndPool(poolParticipations, pool: poolGroup);
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
            ),
          );
        }
        competitionWeightCategory = competitionWeightCategory.copyWith(pairedRound: 0);
      case CompetitionSystem.nordicDoubleElimination:
        final splittedParticipations = participations.slices((participations.length / poolGroupCount).ceil());
        for (final poolParticipationsIndexed in splittedParticipations.indexed) {
          final (poolGroup, poolParticipations) = poolParticipationsIndexed;
          final updatedPoolParticipations = _drawNumberAndPool(poolParticipations, pool: poolGroup);
          updatedParticipations.addAll(updatedPoolParticipations);
          // Generate the first two rounds, as they can be determined.
          final rounds = convertBouts(
            competitionWeightCategory,
            updatedPoolParticipations,
            boutIndexList: generateBergerTable(updatedPoolParticipations.length, maxRounds: 2),
            roundType: RoundType.elimination,
          );
          createdBouts.addAll(rounds.expand((element) => element));
        }
        competitionWeightCategory = competitionWeightCategory.copyWith(pairedRound: 1);
    }

    competitionWeightCategory = competitionWeightCategory.copyWith(
      competitionSystem: competitionSystem,
      poolGroupCount: poolGroupCount,
    );
    await updateSingle(competitionWeightCategory);

    for (final participation in updatedParticipations) {
      await CompetitionParticipationController().updateSingle(participation);
    }

    await createAndBroadcastBouts(createdBouts, competitionWeightCategory);

    return Response.ok('{"status": "success"}');
  }

  static Future<void> createAndBroadcastBouts(
    List<CompetitionBout> createdBouts,
    CompetitionWeightCategory competitionWeightCategory,
  ) async {
    for (final element in createdBouts.indexed) {
      final (index, competitionBout) = element;
      Bout bout = competitionBout.bout;
      if (bout.r != null) {
        bout = bout.copyWith(r: bout.r!.copyWithId(await AthleteBoutStateController().createSingle(bout.r!)));
      }
      if (bout.b != null) {
        bout = bout.copyWith(b: bout.b!.copyWithId(await AthleteBoutStateController().createSingle(bout.b!)));
      }
      bout = await BoutController().createSingleReturn(bout);
      createdBouts[index] = await CompetitionBoutController().createSingleReturn(competitionBout.copyWith(bout: bout));
    }

    broadcastUpdateMany<CompetitionBout>(
      (obfuscate) async {
        final List<CompetitionBout> competitionBouts;
        if (obfuscate) {
          competitionBouts = await CompetitionBoutController().getByWeightCategory(
            competitionWeightCategory.id!,
            obfuscate: obfuscate,
          );
        } else {
          competitionBouts = createdBouts;
        }
        return competitionBouts;
      },
      filterType: CompetitionWeightCategory,
      filterId: competitionWeightCategory.id,
    );
  }

  static List<List<CompetitionBout>> convertBouts(
    CompetitionWeightCategory weightCategory,
    List<CompetitionParticipation> participations, {
    required List<List<(int?, int?)>> boutIndexList,
    required RoundType roundType,
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
          );
        })
        .nonNulls
        .toList();
  }

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {
      'paired_round': psql.Type.smallInteger,
      'pool_group_count': psql.Type.smallInteger,
      'skipped_cycles': psql.Type.smallIntegerArray,
    };
  }

  List<CompetitionParticipation> _drawNumberAndPool(List<CompetitionParticipation> participations, {int? pool}) {
    final List<CompetitionParticipation> updatedParticipations = [];
    for (final participationIndexed in participations.indexed) {
      final (drawNumber, participation) = participationIndexed;
      final updatedParticipation = participation.copyWith(poolDrawNumber: drawNumber, poolGroup: pool);
      updatedParticipations.add(updatedParticipation);
    }
    return updatedParticipations;
  }
}
