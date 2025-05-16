import 'package:postgres/postgres.dart' as psql;
import 'package:wrestling_scoreboard_common/common.dart';

import 'entity_controller.dart';

class CompetitionSystemAffiliationController extends ShelfController<CompetitionSystemAffiliation> {
  static final CompetitionSystemAffiliationController _singleton = CompetitionSystemAffiliationController._internal();

  factory CompetitionSystemAffiliationController() {
    return _singleton;
  }

  CompetitionSystemAffiliationController._internal() : super();

  Future<List<CompetitionSystemAffiliation>> getByCompetition(bool obfuscate, int id) async {
    return await getMany(
      conditions: ['competition_id = @id'],
      substitutionValues: {'id': id},
      orderBy: ['max_contestants'],
      obfuscate: obfuscate,
    );
  }

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {'pool_group_count': psql.Type.smallInteger};
  }
}
