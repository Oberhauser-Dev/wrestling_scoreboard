import 'package:postgres/postgres.dart' as psql;
import 'package:wrestling_scoreboard_common/common.dart';

import 'entity_controller.dart';

class PersonController extends EntityController<Person> {
  static final PersonController _singleton = PersonController._internal();

  factory PersonController() {
    return _singleton;
  }

  PersonController._internal() : super(tableName: 'person');

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {
      'gender': null,
    };
  }

  @override
  Set<String> getSearchableAttributes() => {
        'prename',
        'surname',
        // 'gender', // Cannot currently search non-string values
        'nationality',
        // 'birth_date', // Cannot currently search non-string values
      };
}
