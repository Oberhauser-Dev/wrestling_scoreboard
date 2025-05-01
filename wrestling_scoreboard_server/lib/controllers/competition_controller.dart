import 'package:postgres/postgres.dart' as psql;
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_bout_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_system_affiliation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_weight_category_controller.dart';
import 'package:wrestling_scoreboard_server/request.dart';

import 'competition_lineup_controller.dart';
import 'entity_controller.dart';

class CompetitionController extends ShelfController<Competition> with ImportController<Competition> {
  static final CompetitionController _singleton = CompetitionController._internal();

  factory CompetitionController() {
    return _singleton;
  }

  CompetitionController._internal() : super();

  Future<Response> requestCompetitionBouts(Request request, User? user, String id) async {
    return CompetitionBoutController().handleRequestMany(
      isRaw: request.isRaw,
      conditions: ['competition_id = @id'],
      substitutionValues: {'id': id},
      obfuscate: user?.obfuscate ?? true,
    );
  }

  Future<Response> requestLineups(Request request, User? user, String id) async {
    return CompetitionLineupController().handleRequestMany(
      isRaw: request.isRaw,
      conditions: ['competition_id = @id'],
      substitutionValues: {'id': id},
      obfuscate: user?.obfuscate ?? true,
    );
  }

  Future<Response> requestWeightCategories(Request request, User? user, String id) async {
    return CompetitionWeightCategoryController().handleRequestMany(
      isRaw: request.isRaw,
      conditions: ['competition_id = @id'],
      substitutionValues: {'id': id},
      obfuscate: user?.obfuscate ?? true,
    );
  }

  Future<Response> requestCompetitionSystemAffiliations(Request request, User? user, String id) async {
    return CompetitionSystemAffiliationController().handleRequestMany(
      isRaw: request.isRaw,
      conditions: ['competition_id = @id'],
      substitutionValues: {'id': id},
      obfuscate: user?.obfuscate ?? true,
    );
  }

  @override
  Future<void> import({
    required WrestlingApi apiProvider,
    required Competition entity,
    bool obfuscate = true,
    bool includeSubjacent = false,
  }) async {
    updateLastImportUtcDateTime(entity.id!);
    if (includeSubjacent) {
      // Nothing to do
    }
    throw UnimplementedError('This operation is not supported yet!');
  }

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {'comment': psql.Type.text};
  }

  @override
  Organization? getOrganization(Competition entity) {
    return entity.organization;
  }
}
