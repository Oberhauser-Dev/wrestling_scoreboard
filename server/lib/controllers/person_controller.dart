import 'package:common/common.dart';
import 'package:postgres/postgres.dart';

import 'entity_controller.dart';

class PersonController extends EntityController<Person> {
  static final PersonController _singleton = PersonController._internal();

  factory PersonController() {
    return _singleton;
  }

  PersonController._internal() : super(tableName: 'person');

  @override
  Map<String, PostgreSQLDataType?> getPostgresDataTypes() {
    return {
      'gender': null,
    };
  }
}
