import 'package:common/common.dart';
import 'package:postgres/postgres.dart';

import 'entity_controller.dart';

class WeightClassController extends EntityController<WeightClass> {
  static final WeightClassController _singleton = WeightClassController._internal();

  factory WeightClassController() {
    return _singleton;
  }

  WeightClassController._internal() : super(tableName: 'weight_class');

  @override
  Map<String, PostgreSQLDataType?> getPostgresDataTypes() {
    return {
      'weight': PostgreSQLDataType.smallInteger,
      'style': null,
    };
  }
}
