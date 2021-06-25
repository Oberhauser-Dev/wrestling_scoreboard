import 'package:json_annotation/json_annotation.dart';

import 'fight_role.dart';

part 'fight_action.g.dart';

enum FightActionType {
  points,
  passivity, // P
  verbal, // V admonition
  caution, // yellow card
  dismissal // red card
}

@JsonSerializable()
class FightAction {
  Duration duration;
  FightActionType actionType;
  int? pointCount;
  FightRole role;

  FightAction({required this.actionType, required this.duration, required this.role, this.pointCount});

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
