import 'package:postgres/postgres.dart' as psql;
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_result_rule_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/entity_controller.dart';
import 'package:wrestling_scoreboard_server/request.dart';

class BoutConfigController extends ShelfController<BoutConfig> {
  static final BoutConfigController _singleton = BoutConfigController._internal();

  factory BoutConfigController() {
    return _singleton;
  }

  BoutConfigController._internal() : super(tableName: 'bout_config');

  Future<Response> requestBoutResultRules(Request request, User? user, String id) async {
    return BoutResultRuleController().handleRequestMany(
      isRaw: request.isRaw,
      conditions: ['bout_config_id = @id'],
      substitutionValues: {'id': id},
      obfuscate: user?.obfuscate ?? true,
    );
  }

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {
      'period_count': psql.Type.smallInteger,
    };
  }
}
