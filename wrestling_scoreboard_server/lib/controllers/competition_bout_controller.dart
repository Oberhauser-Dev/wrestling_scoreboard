import 'dart:convert';

import 'package:postgres/postgres.dart' as psql;
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';

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
            updatedCompetitionBout.round! >= weightCategory.pairedRound!) {}
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
