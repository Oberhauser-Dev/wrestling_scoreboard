import 'package:postgres/postgres.dart' as psql;
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/orderable_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_weight_category_controller.dart';

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

  static String get _currentCompetitionBoutOfMatQuery =>
      '''
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
    }
    return super.handlePostRequestSingle(json);
  }

  Future<void> processOnResult(CompetitionBout competitionBout) async {
    if (competitionBout.bout.result != null && competitionBout.weightCategory?.id != null) {
      // If bout has a result, check if can pair a new round
      final weightCategory = await CompetitionWeightCategoryController().getSingle(
        competitionBout.weightCategory!.id!,
        obfuscate: false,
      );

      if (competitionBout.phasePos < weightCategory.pairedRoundByPhase.length &&
          competitionBout.round != null &&
          competitionBout.round! >= weightCategory.pairedRoundByPhase[competitionBout.phasePos]) {
        // Only compute if pairedRound is equal to round of updated bout
        if (competitionBout.round! > weightCategory.pairedRoundByPhase[competitionBout.phasePos]) {
          throw Exception(
            'Round of bout $competitionBout must be smaller or equal to paired round ${weightCategory.pairedRoundByPhase}',
          );
        }
        await CompetitionWeightCategoryController().generateSubsequence(
          weightCategory,
          round: competitionBout.round!,
          phasePos: competitionBout.phasePos,
        );
      }
    }
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

  Future<List<CompetitionBout>> getByBout(int id, {required bool obfuscate}) async {
    return await getMany(conditions: ['bout_id = @id'], substitutionValues: {'id': id}, obfuscate: obfuscate);
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
