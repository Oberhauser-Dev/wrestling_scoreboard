import 'package:collection/collection.dart';
import 'package:postgres/postgres.dart' as psql;
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/common/orderable_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/websocket_handler.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_bout_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_weight_category_controller.dart';
import 'package:wrestling_scoreboard_server/request.dart';

class CompetitionAgeCategoryController extends ShelfController<CompetitionAgeCategory>
    with OrderableController<CompetitionAgeCategory> {
  static final CompetitionAgeCategoryController _singleton = CompetitionAgeCategoryController._internal();

  factory CompetitionAgeCategoryController() {
    return _singleton;
  }

  CompetitionAgeCategoryController._internal() : super();

  @override
  Future<Response> handlePostRequestSingle(Map<String, Object?> json) async {
    // If updating the skipped_cycles, then also update the competition_age_categories and the competition_bout order.
    final updatedCompetitionAgeCategory = parseSingleJson<CompetitionAgeCategory>(json);

    CompetitionAgeCategory? oldCompetitionAgeCategory;
    final operation = CRUD.values.byName(json['operation'] as String);
    if (operation == CRUD.update) {
      oldCompetitionAgeCategory = await getSingle(updatedCompetitionAgeCategory.id!, obfuscate: false);
    }

    // Need to update before further sorting calculations
    final response = await super.handlePostRequestSingle(json);

    // There are probably no bouts to sort, if no competition_age_category was present
    if (oldCompetitionAgeCategory != null &&
        !SetEquality().equals(
          oldCompetitionAgeCategory.skippedCycles.toSet(),
          updatedCompetitionAgeCategory.skippedCycles.toSet(),
        )) {
      final weightCategoryController = CompetitionWeightCategoryController();
      final query = '''
UPDATE ${weightCategoryController.tableName}
SET skipped_cycles = @skippedCycles
WHERE competition_age_category_id = @cacId
RETURNING $primaryKeyName;
      ''';
      final ids = (await weightCategoryController.getManyRawFromQuery(
        query,
        substitutionValues: {
          'skippedCycles': updatedCompetitionAgeCategory.skippedCycles,
          'cacId': updatedCompetitionAgeCategory.id,
        },
      )).map((row) => row['id'] as int);

      // Need to broadcast the update of the competition_weight_categories for each single item.
      for (final competitionWeightCategoryId in ids) {
        broadcastUpdateSingle<CompetitionWeightCategory>(
          (obfuscate) async =>
              await weightCategoryController.getSingle(competitionWeightCategoryId, obfuscate: obfuscate),
        );
      }

      await CompetitionBoutController().reorderBlocks(
        orderType: CompetitionWeightCategory,
        filterType: Competition,
        filterId: updatedCompetitionAgeCategory.competition.id!,
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
      await CompetitionWeightCategoryController().reorderBlocks(
        orderType: CompetitionAgeCategory,
        filterType: filterTypes[i],
        filterId: filterIds[i],
      );

      await CompetitionBoutController().reorderBlocks(
        orderType: CompetitionWeightCategory,
        filterType: filterTypes[i],
        filterId: filterIds[i],
      );
    }
    return response;
  }

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {'skipped_cycles': psql.Type.smallIntegerArray};
  }
}
