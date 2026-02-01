import 'package:postgres/postgres.dart' as psql;
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';

class CompetitionSystemPhaseController extends ShelfController<CompetitionSystemPhase> {
  static final CompetitionSystemPhaseController _singleton = CompetitionSystemPhaseController._internal();

  factory CompetitionSystemPhaseController() {
    return _singleton;
  }

  CompetitionSystemPhaseController._internal() : super();

  Future<List<CompetitionSystemPhase>> getByCompetitionSystemAffiliation(int id, {required bool obfuscate}) async {
    return await getMany(
      conditions: ['competition_system_affiliation_id = @id'],
      substitutionValues: {'id': id},
      obfuscate: obfuscate,
    );
  }

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {'pool_group_count': psql.Type.smallInteger};
  }
}
