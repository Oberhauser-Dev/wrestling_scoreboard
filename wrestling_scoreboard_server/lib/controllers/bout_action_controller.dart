import 'package:postgres/postgres.dart' as psql;
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';

class BoutActionController extends ShelfController<BoutAction> {
  static final BoutActionController _singleton = BoutActionController._internal();

  factory BoutActionController() {
    return _singleton;
  }

  BoutActionController._internal() : super();

  Future<List<BoutAction>> getByBout(int id, {required bool obfuscate}) async {
    return await getMany(conditions: ['bout_id = @id'], substitutionValues: {'id': id}, obfuscate: obfuscate);
  }

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {'point_count': psql.Type.smallInteger, 'bout_role': null, 'action_type': null};
  }
}
