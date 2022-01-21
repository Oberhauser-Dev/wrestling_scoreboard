import 'package:common/common.dart';
import 'package:postgres/postgres.dart';

import 'entity_controller.dart';
import 'participation_controller.dart';

class ParticipantStateController extends EntityController<ParticipantState> {
  static final ParticipantStateController _singleton = ParticipantStateController._internal();

  factory ParticipantStateController() {
    return _singleton;
  }

  ParticipantStateController._internal() : super(tableName: 'participant_state');

  @override
  Future<ParticipantState> parseToClass(Map<String, dynamic> e) async {
    final participation = await ParticipationController().getSingle(e['participation_id'] as int);
    return ParticipantState(
      id: e[primaryKeyName] as int?,
      participation: participation!,
      classificationPoints: e['classification_points'] as int?,
    );
  }

  @override
  Map<String, dynamic> parseFromClass(ParticipantState e) {
    return {
      if (e.id != null) primaryKeyName: e.id,
      'participation_id': e.participation.id,
      'classification_points': e.classificationPoints,
    };
  }

  @override
  Map<String, PostgreSQLDataType> getPostgresDataTypes() {
    return {'classification_points': PostgreSQLDataType.smallInteger};
  }
}
