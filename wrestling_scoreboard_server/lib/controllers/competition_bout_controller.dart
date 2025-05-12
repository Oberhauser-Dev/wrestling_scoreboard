import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:postgres/postgres.dart' as psql;
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';

import 'competition_participation_controller.dart';
import 'competition_weight_category_controller.dart';
import 'entity_controller.dart';

class CompetitionBoutController extends ShelfController<CompetitionBout> {
  static final CompetitionBoutController _singleton = CompetitionBoutController._internal();

  factory CompetitionBoutController() {
    return _singleton;
  }

  CompetitionBoutController._internal() : super();

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
          // Prohibit from adding a bout to an already occupied mat
          final curCompetitionBoutsOfMat = await getManyFromQuery(
            _currentCompetitionBoutOfMatQuery,
            obfuscate: obfuscate,
            substitutionValues: {'mat': updatedCompetitionBout.mat},
          );
          // final operation = CRUD.values.byName(json['operation']);
          if (curCompetitionBoutsOfMat.isNotEmpty) {
            final curCompetitionBout = curCompetitionBoutsOfMat.first;
            // Always let update itself
            if (curCompetitionBout.id != json['id']) {
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
          if (updatedCompetitionBout.round! > weightCategory.pairedRound!) {
            throw Exception(
              'Round of bout $updatedCompetitionBout must be smaller or equal to paired round ${weightCategory.pairedRound}',
            );
          }

          final competitionBouts = await getByWeightCategory(obfuscate, updatedCompetitionBout.weightCategory!.id!);
          final competitionBoutsOfRound = competitionBouts.where((cb) => cb.round == updatedCompetitionBout.round);

          if (competitionBoutsOfRound.every((cb) => cb.bout.result != null)) {
            // Every bout has a bout result, so can pair a new round
            switch (weightCategory.competitionSystem) {
              case CompetitionSystem.nordic:
              // Do nothing, or update list of bouts
              case CompetitionSystem.twoPools:
                final participations = await CompetitionParticipationController().getByWeightCategory(
                  false,
                  weightCategory.id!,
                );
                for (final (index, participation) in participations.indexed) {
                  // Skip already excluded participants.
                  if (participation.isExcluded) continue;
                  // Eliminate participants with 2 or more losses.
                  final participantLosses = competitionBouts.where((cb) {
                    return (cb.bout.r?.membership == participation.membership && cb.bout.winnerRole != BoutRole.red) ||
                        (cb.bout.b?.membership == participation.membership && cb.bout.winnerRole != BoutRole.blue);
                  });
                  if (participantLosses.length >= 2) {
                    participations[index] = participation.copyWith(eliminated: true);
                    await CompetitionParticipationController().updateSingle(participations[index]);
                  }
                }

                final pairedRound = weightCategory.pairedRound! + 1;
                final poolParticipationGroups = participations.groupListsBy((participation) => participation.poolGroup);
                final List<CompetitionBout> createdCompetitionBouts = [];
                for (final poolParticipations in poolParticipationGroups.values) {
                  createdCompetitionBouts.addAll(
                    CompetitionWeightCategoryController.generateCompetitionBoutsOfRound(
                      poolParticipations,
                      weightCategory,
                      round: pairedRound,
                    ),
                  );
                }
                await CompetitionWeightCategoryController.createAndBroadcastBouts(
                  createdCompetitionBouts,
                  weightCategory,
                );

                await CompetitionWeightCategoryController().updateSingle(
                  weightCategory.copyWith(pairedRound: pairedRound),
                );

              case CompetitionSystem.singleElimination:
                // TODO: Handle this case.
                throw UnimplementedError();
              case CompetitionSystem.doubleElimination:
                // TODO: Handle this case.
                throw UnimplementedError();
              default:
            }
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

  Future<List<CompetitionBout>> getByWeightCategory(bool obfuscate, int id) async {
    return await getMany(
      conditions: ['weight_category_id = @id'],
      substitutionValues: {'id': id},
      obfuscate: obfuscate,
    );
  }
}
