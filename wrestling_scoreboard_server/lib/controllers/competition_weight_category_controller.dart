import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:postgres/postgres.dart' as psql;
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_participation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_system_affiliation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/websocket_handler.dart';

import 'athlete_bout_state_controller.dart';
import 'bout_controller.dart';
import 'competition_bout_controller.dart';
import 'entity_controller.dart';

class CompetitionWeightCategoryController extends ShelfController<CompetitionWeightCategory> {
  static final CompetitionWeightCategoryController _singleton = CompetitionWeightCategoryController._internal();

  factory CompetitionWeightCategoryController() {
    return _singleton;
  }

  CompetitionWeightCategoryController._internal() : super();

  /// isReset: delete all previous Bouts and CompetitionBouts, else reuse the states
  Future<Response> generateBouts(Request request, User? user, String id) async {
    final bool obfuscate = user?.obfuscate ?? true;
    // TODO: option to reset, override existing bouts if present, keep athlete bout state.
    final isReset = (request.url.queryParameters['isReset'] ?? '').parseBool();
    final competitionWeightCategory = (await getSingle(int.parse(id), obfuscate: false));

    final oldCompetitionBouts = await CompetitionBoutController().getByWeightCategory(
      obfuscate,
      competitionWeightCategory.id!,
    );
    if (isReset) {
      await Future.forEach(oldCompetitionBouts, (CompetitionBout competitionBout) async {
        if (competitionBout.id != null) {
          await CompetitionBoutController().deleteSingle(competitionBout.id!);
          await BoutController().deleteSingle(competitionBout.bout.id!);
          // TODO delete athlete bout state (?)
        }
      });
    } else {
      // TODO: just delete those who aren't reused any more
      await Future.forEach(oldCompetitionBouts, (CompetitionBout competitionBout) async {
        if (competitionBout.id != null) {
          await CompetitionBoutController().deleteSingle(competitionBout.id!);
          await BoutController().deleteSingle(competitionBout.bout.id!);
          // TODO delete athlete bout state (?)
        }
      });
    }

    final participations = await CompetitionParticipationController().getByWeightCategory(
      false,
      competitionWeightCategory.id!,
    );
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
    if (competitionSystemAffiliation == null) {
      throw Exception('No matching competition system found for competition ${competitionWeightCategory.competition}');
    }
    final List<CompetitionBout> createdBouts;
    final List<CompetitionParticipation> updatedParticipations = [];
    final CompetitionWeightCategory updatedCompetitionWeightCategory;
    switch (competitionSystemAffiliation.competitionSystem) {
      case CompetitionSystem.nordic:
        // https://en.wikipedia.org/wiki/Round-robin_tournament
        participations.shuffle();
        for (final participationIndexed in participations.indexed) {
          final drawNumber = participationIndexed.$1;
          final participation = participationIndexed.$2;
          final updatedParticipation = participation.copyWith(poolDrawNumber: drawNumber);
          updatedParticipations.add(updatedParticipation);
        }
        final competitionBoutsBergerTable = _generateCompetitionBergerTable(
          updatedParticipations,
          competitionWeightCategory,
        );
        createdBouts = competitionBoutsBergerTable.expand((element) => element).toList();
        updatedCompetitionWeightCategory = competitionWeightCategory.copyWith(
          pairedRound: competitionBoutsBergerTable.length - 1,
        );
      case CompetitionSystem.twoPools:
        createdBouts = [];
        participations.shuffle();
        final splittedParticipations = participations.slices((participations.length / 2).ceil());
        for (final poolParticipationsIndexed in splittedParticipations.indexed) {
          final (poolGroup, poolParticipations) = poolParticipationsIndexed;
          final updatedPoolParticipations = <CompetitionParticipation>[];
          for (final participationIndexed in poolParticipations.indexed) {
            final (drawNumber, poolParticipation) = participationIndexed;
            final updatedParticipation = poolParticipation.copyWith(poolDrawNumber: drawNumber, poolGroup: poolGroup);
            updatedPoolParticipations.add(updatedParticipation);
          }

          updatedParticipations.addAll(updatedPoolParticipations);
          // Only generate first round, as the others are not determined yet.
          createdBouts.addAll(
            _generateCompetitionBoutsOfRound(updatedPoolParticipations, competitionWeightCategory, round: 0),
          );
        }
        updatedCompetitionWeightCategory = competitionWeightCategory.copyWith(pairedRound: 0);
      case CompetitionSystem.singleElimination:
        // TODO: Handle this case.
        throw UnimplementedError();
      case CompetitionSystem.doubleElimination:
        // TODO: Handle this case.
        throw UnimplementedError();
    }

    await updateSingle(updatedCompetitionWeightCategory);

    for (final participation in updatedParticipations) {
      await CompetitionParticipationController().updateSingle(participation);
    }

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

    broadcast((obfuscate) async {
      final List<CompetitionBout> competitionBouts;
      if (obfuscate) {
        competitionBouts = await CompetitionBoutController().getByWeightCategory(
          obfuscate,
          competitionWeightCategory.id!,
        );
      } else {
        competitionBouts = createdBouts;
      }
      return jsonEncode(
        manyToJson(
          competitionBouts,
          CompetitionBout,
          CRUD.update,
          isRaw: false,
          filterType: CompetitionWeightCategory,
          filterId: competitionWeightCategory.id,
        ),
      );
    });

    return Response.ok('{"status": "success"}');
  }

  List<CompetitionBout> _generateCompetitionBoutsOfRound(
    List<CompetitionParticipation> participations,
    CompetitionWeightCategory weightCategory, {
    required int round,
  }) {
    final bergerTable = _bergerTable(participations.length, weightCategory);
    final boutsOfRound = bergerTable[round];
    return _convertBoutsOfRound(boutsOfRound, round, weightCategory, participations);
  }

  List<List<CompetitionBout>> _generateCompetitionBergerTable(
    List<CompetitionParticipation> participations,
    CompetitionWeightCategory weightCategory,
  ) {
    final bergerTable = _bergerTable(participations.length, weightCategory);
    return bergerTable.indexed.map((indexedRoundBouts) {
      final (round, boutsOfRound) = indexedRoundBouts;
      return _convertBoutsOfRound(boutsOfRound, round, weightCategory, participations);
    }).toList();
  }

  List<CompetitionBout> _convertBoutsOfRound(
    List<(int?, int?)> boutsOfRound,
    int round,
    CompetitionWeightCategory weightCategory,
    List<CompetitionParticipation> participations,
  ) {
    return boutsOfRound.indexed.map((indexedBoutTuple) {
      final (boutIndex, boutTuple) = indexedBoutTuple;
      final (rIndex, bIndex) = boutTuple;
      return CompetitionBout(
        competition: weightCategory.competition,
        pos: (round * participations.length) + boutIndex,
        weightCategory: weightCategory,
        round: round,
        bout: Bout(
          organization: weightCategory.competition.organization,
          r: rIndex == null ? null : AthleteBoutState(membership: participations[rIndex].membership),
          b: bIndex == null ? null : AthleteBoutState(membership: participations[bIndex].membership),
        ),
      );
    }).toList();
  }

  List<List<(int?, int?)>> _bergerTable(int participationSize, CompetitionWeightCategory weightCategory) {
    final List<int?> participations = Iterable<int>.generate(participationSize).toList();
    if (participations.length.isOdd) participations.insert(0, null);
    final useDummy = false;

    final n = participations.length;
    final numberOfRounds = n - 1;
    final boutsPerRound = n ~/ 2;

    List<int?> columnA = participations.slice(0, boutsPerRound).toList();
    List<int?> columnB = participations.slice(boutsPerRound).toList();
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

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {'paired_round': psql.Type.smallInteger};
  }
}
