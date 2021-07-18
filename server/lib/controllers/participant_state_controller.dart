import 'package:common/common.dart';

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
      id: e['id'] as int?,
      participation: participation!,
      classificationPoints: e['classification_points'] as int?,
    );
  }
}
