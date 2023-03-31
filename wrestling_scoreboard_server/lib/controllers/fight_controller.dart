import 'package:wrestling_scoreboard_common/common.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';

import 'entity_controller.dart';
import 'fight_action_controller.dart';

class FightController extends EntityController<Fight> {
  static final FightController _singleton = FightController._internal();

  factory FightController() {
    return _singleton;
  }

  FightController._internal() : super(tableName: 'fight');

  Future<Response> requestFightActions(Request request, String id) async {
    return EntityController.handleRequestManyOfController(FightActionController(),
        isRaw: isRaw(request), conditions: ['fight_id = @id'], substitutionValues: {'id': id});
  }

  @override
  Map<String, PostgreSQLDataType?> getPostgresDataTypes() {
    return {
      'winner_role': null,
      'fight_result': null,
    };
  }
}
