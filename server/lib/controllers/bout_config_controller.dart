import 'package:common/common.dart';
import 'package:postgres/postgres.dart';
import 'package:server/controllers/entity_controller.dart';

class BoutConfigController extends EntityController<BoutConfig> {
  static final BoutConfigController _singleton = BoutConfigController._internal();

  factory BoutConfigController() {
    return _singleton;
  }

  BoutConfigController._internal() : super(tableName: 'bout_config');

  @override
  Map<String, PostgreSQLDataType?> getPostgresDataTypes() {
    return {
      'period_count': PostgreSQLDataType.smallInteger,
    };
  }
}
