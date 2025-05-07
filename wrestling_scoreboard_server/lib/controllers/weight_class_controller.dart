import 'package:postgres/postgres.dart' as psql;
import 'package:wrestling_scoreboard_common/common.dart';

import 'entity_controller.dart';

class WeightClassController extends ShelfController<WeightClass> {
  static final WeightClassController _singleton = WeightClassController._internal();

  factory WeightClassController() {
    return _singleton;
  }

  WeightClassController._internal() : super();

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {'weight': psql.Type.smallInteger, 'style': null, 'unit': null};
  }
}
