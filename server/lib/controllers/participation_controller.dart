import 'package:common/common.dart';
import 'package:postgres/postgres.dart';

import 'entity_controller.dart';

class ParticipationController extends EntityController<Participation> {
  static final ParticipationController _singleton = ParticipationController._internal();

  factory ParticipationController() {
    return _singleton;
  }

  ParticipationController._internal() : super(tableName: 'participation');

  @override
  Map<String, PostgreSQLDataType> getPostgresDataTypes() {
    return {'weight': PostgreSQLDataType.numeric};
  }
}
