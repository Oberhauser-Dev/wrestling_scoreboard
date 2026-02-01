import 'package:postgres/postgres.dart' as psql;
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';

class CompetitionParticipationController extends ShelfController<CompetitionParticipation> {
  static final CompetitionParticipationController _singleton = CompetitionParticipationController._internal();

  factory CompetitionParticipationController() {
    return _singleton;
  }

  CompetitionParticipationController._internal() : super();

  Future<List<CompetitionParticipation>> getByWeightCategory(int id, {required bool obfuscate}) async {
    return await getMany(
      conditions: ['weight_category_id = @id'],
      substitutionValues: {'id': id},
      orderBy: ['pool_groups', 'pool_draw_numbers'],
      obfuscate: obfuscate,
    );
  }

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {
      'weight': psql.Type.numeric,
      'pool_groups': psql.Type.smallIntegerArray,
      'pool_draw_numbers': psql.Type.smallIntegerArray,
    };
  }
}
