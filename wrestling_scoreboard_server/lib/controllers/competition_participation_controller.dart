import 'package:postgres/postgres.dart' as psql;
import 'package:wrestling_scoreboard_common/common.dart';

import 'entity_controller.dart';

class CompetitionParticipationController extends ShelfController<CompetitionParticipation> {
  static final CompetitionParticipationController _singleton = CompetitionParticipationController._internal();

  factory CompetitionParticipationController() {
    return _singleton;
  }

  CompetitionParticipationController._internal() : super();

  Future<List<CompetitionParticipation>> getByWeightCategory(bool obfuscate, int id) async {
    return await getMany(
      conditions: ['weight_category_id = @id'],
      substitutionValues: {'id': id},
      orderBy: ['pool_group', 'pool_draw_number'],
      obfuscate: obfuscate,
    );
  }

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {
      'weight': psql.Type.numeric,
      'pool_group': psql.Type.smallInteger,
      'pool_draw_number': psql.Type.smallInteger,
    };
  }
}
