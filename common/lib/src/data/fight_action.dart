import 'package:json_annotation/json_annotation.dart';

import '../enums/fight_action_type.dart';
import '../enums/fight_role.dart';
import 'data_object.dart';
import 'fight.dart';

part 'fight_action.g.dart';

/// An action and its value that is fulfilled by the participant during a fight, e.g. points or caution
@JsonSerializable()
class FightAction extends DataObject {
  Duration duration;
  FightActionType actionType;
  int? pointCount;
  FightRole role;
  Fight fight;

  FightAction({int? id, required this.actionType, required this.fight, required this.duration, required this.role, this.pointCount})
      : super(id);

  factory FightAction.fromJson(Map<String, dynamic> json) => _$FightActionFromJson(json);

  Map<String, dynamic> toJson() => _$FightActionToJson(this);

  @override
  String toString() {
    switch (actionType) {
      case FightActionType.points:
        return pointCount?.toString() ?? '0';
      case FightActionType.passivity:
        return 'P';
      case FightActionType.verbal:
        return 'V';
      case FightActionType.caution:
        return 'O';
      case FightActionType.dismissal:
        return 'D';
      default:
        return '';
    }
  }
}
