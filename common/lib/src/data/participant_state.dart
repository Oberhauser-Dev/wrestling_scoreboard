import 'package:json_annotation/json_annotation.dart';

import '../enums/fight_action_type.dart';
import '../enums/fight_role.dart';
import 'data_object.dart';
import 'fight_action.dart';
import 'participation.dart';

part 'participant_state.g.dart';

/// The state of one participant during a fight.
@JsonSerializable()
class ParticipantState extends DataObject {
  Participation participation;
  int? classificationPoints;

  ParticipantState({int? id, required this.participation, this.classificationPoints}) : super(id);

  factory ParticipantState.fromJson(Map<String, dynamic> json) => _$ParticipantStateFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ParticipantStateToJson(this);

  static Future<ParticipantState> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final participation = await getSingle<Participation>(e['participation_id'] as int);
    return ParticipantState(
      id: e['id'] as int?,
      participation: participation!,
      classificationPoints: e['classification_points'] as int?,
    );
  }

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'participation_id': participation.id,
      'classification_points': classificationPoints,
    };
  }

  static int getTechnicalPoints(Iterable<FightAction> actions, FightRole role) {
    var res = 0;
    actions.forEach((el) {
      if (el.actionType == FightActionType.points && el.role == role) {
        res += el.pointCount!;
      }
    });
    return res;
  }

  bool equalDuringFight(o) => o is ParticipantState && o.runtimeType == runtimeType && participation == o.participation;
}
