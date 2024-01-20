import 'package:wrestling_scoreboard_common/common.dart';
import 'package:postgres/postgres.dart' as psql;
import 'package:shelf/shelf.dart';

import 'entity_controller.dart';
import 'bout_action_controller.dart';

class BoutController extends EntityController<Bout> {
  static final BoutController _singleton = BoutController._internal();

  factory BoutController() {
    return _singleton;
  }

  BoutController._internal() : super(tableName: 'bout');

  Future<Response> requestBoutActions(Request request, String id) async {
    return EntityController.handleRequestManyOfController(BoutActionController(),
        isRaw: isRaw(request), conditions: ['bout_id = @id'], substitutionValues: {'id': id});
  }

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {
      'winner_role': null,
      'bout_result': null,
    };
  }
}
