import 'package:common/common.dart';
import 'package:postgres/postgres.dart';

import 'entity_controller.dart';

class ParticipantStateController extends EntityController<ParticipantState> {
  static final ParticipantStateController _singleton = ParticipantStateController._internal();

  factory ParticipantStateController() {
    return _singleton;
  }

  ParticipantStateController._internal() : super(tableName: 'participant_state');

  @override
  Map<String, PostgreSQLDataType> getPostgresDataTypes() {
    return {'classification_points': PostgreSQLDataType.smallInteger};
  }
}
