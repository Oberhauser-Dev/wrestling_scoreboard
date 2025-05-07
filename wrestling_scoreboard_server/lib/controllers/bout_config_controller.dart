import 'package:postgres/postgres.dart' as psql;
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/entity_controller.dart';

class BoutConfigController extends ShelfController<BoutConfig> {
  static final BoutConfigController _singleton = BoutConfigController._internal();

  factory BoutConfigController() {
    return _singleton;
  }

  BoutConfigController._internal() : super();

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {'period_count': psql.Type.smallInteger};
  }
}
