import 'package:postgres/postgres.dart' as psql;
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/common/import_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';
import 'package:wrestling_scoreboard_server/services/api.dart';

class CompetitionController extends ShelfController<Competition> with ImportController<Competition> {
  static final CompetitionController _singleton = CompetitionController._internal();

  factory CompetitionController() {
    return _singleton;
  }

  CompetitionController._internal() : super();

  @override
  Stream<double> import({
    required WrestlingApi apiProvider,
    required Competition entity,
    bool obfuscate = true,
    bool includeSubjacent = false,
  }) async* {
    final totalSteps = 1 + (includeSubjacent ? 1 : 0);
    int step = 0;
    yield (++step) / totalSteps;

    updateLastImportUtcDateTime(entity.id!);
    if (includeSubjacent) {
      // Nothing to do
      yield (++step) / totalSteps;
    }
    throw UnimplementedError('This operation is not supported yet!');
  }

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {
      'date': psql.Type.timestampTz,
      'end_date': psql.Type.timestampTz,
      'mat_count': psql.Type.smallInteger,
      'max_ranking': psql.Type.smallInteger,
      'mat': psql.Type.smallInteger,
      'round': psql.Type.smallInteger,
      'comment': psql.Type.text,
    };
  }

  @override
  Organization? getOrganization(Competition entity) {
    return entity.organization;
  }
}
