import 'package:postgres/postgres.dart' as psql;
import 'package:wrestling_scoreboard_common/common.dart';

import 'entity_controller.dart';

class CompetitionBoutController extends ShelfController<CompetitionBout> {
  static final CompetitionBoutController _singleton = CompetitionBoutController._internal();

  factory CompetitionBoutController() {
    return _singleton;
  }

  CompetitionBoutController._internal() : super();

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {
      'mat': psql.Type.smallInteger,
      'round': psql.Type.smallInteger,
    };
  }

  Future<List<CompetitionBout>> getByWeightCategory(bool obfuscate, int id) async {
    return await getMany(
      conditions: ['weight_category_id = @id'],
      substitutionValues: {'id': id},
      obfuscate: obfuscate,
    );
  }
}
