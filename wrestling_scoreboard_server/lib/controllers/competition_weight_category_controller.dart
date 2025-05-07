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
    final isReset = (request.url.queryParameters['isReset'] ?? '').parseBool(); // TODO
    final competitionWeightCategory = (await getSingle(int.parse(id), obfuscate: false));

    final participations =
        await CompetitionParticipationController().getByWeightCategory(false, competitionWeightCategory.id!);
    final competitionSystemAffiliations = await CompetitionSystemAffiliationController()
        .getByCompetition(obfuscate, competitionWeightCategory.competition.id!);
    // Sort DESC
    competitionSystemAffiliations
        .sort((a, b) => (b.maxContestants ?? double.infinity).compareTo(a.maxContestants ?? double.infinity));
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
        createdBouts =
            _bergerTable(updatedParticipations, competitionWeightCategory).expand((element) => element).toList();
      // TODO alter participations
      // TODO alter bouts
      case CompetitionSystem.twoPools:
        // TODO: Handle this case.
        throw UnimplementedError();
      case CompetitionSystem.singleElimination:
        // TODO: Handle this case.
        throw UnimplementedError();
      case CompetitionSystem.doubleElimination:
        // TODO: Handle this case.
        throw UnimplementedError();
    }

    for (var element in createdBouts.indexed) {
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
        competitionBouts =
            await CompetitionBoutController().getByWeightCategory(obfuscate, competitionWeightCategory.id!);
      } else {
        competitionBouts = createdBouts;
      }
      return jsonEncode(manyToJson(competitionBouts, CompetitionBout, CRUD.update,
          isRaw: false, filterType: CompetitionWeightCategory, filterId: competitionWeightCategory.id));
    });

    return Response.ok('{"status": "success"}');
  }

  List<List<CompetitionBout>> _bergerTable(
      List<CompetitionParticipation?> participations, CompetitionWeightCategory weightCategory) {
    participations = [...participations]; // copy array to avoid side effects
    if (participations.length.isOdd) participations.insert(0, null);
    final useDummy = false;

    final n = participations.length;
    final numberOfRounds = n - 1;
    final boutsPerRound = n ~/ 2;

    List<CompetitionParticipation?> columnA = participations.slice(0, boutsPerRound).toList();
    List<CompetitionParticipation?> columnB = participations.slice(boutsPerRound).toList();
    final fixed = participations[0];

    int posCount = 0;
    final gen = Iterable.generate(numberOfRounds).map((roundIndex) {
      final genBoutsPerRound = Iterable.generate(boutsPerRound);
      final boutsArr = <CompetitionBout>[];
      for (final k in genBoutsPerRound) {
        if (useDummy || (columnA[k] != null && columnB[k] != null)) {
          boutsArr.insert(
              0,
              CompetitionBout(
                competition: weightCategory.competition,
                pos: posCount,
                weightCategory: weightCategory,
                round: roundIndex,
                bout: Bout(
                  organization: weightCategory.competition.organization,
                  r: columnA[k] == null ? null : AthleteBoutState(membership: columnA[k]!.membership),
                  b: columnB[k] == null ? null : AthleteBoutState(membership: columnB[k]!.membership),
                ),
              ));
          posCount++;
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
    return {
      'paired_round': psql.Type.smallInteger,
    };
  }
}
