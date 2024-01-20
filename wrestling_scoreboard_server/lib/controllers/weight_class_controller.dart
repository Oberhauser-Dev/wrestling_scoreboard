import 'package:wrestling_scoreboard_common/common.dart';
import 'package:postgres/postgres.dart' as psql;

import 'entity_controller.dart';

class WeightClassController extends EntityController<WeightClass> {
  static final WeightClassController _singleton = WeightClassController._internal();

  factory WeightClassController() {
    return _singleton;
  }

  WeightClassController._internal() : super(tableName: 'weight_class');

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {
      'weight': psql.Type.smallInteger,
      'style': null,
      'unit': null,
    };
  }
}
