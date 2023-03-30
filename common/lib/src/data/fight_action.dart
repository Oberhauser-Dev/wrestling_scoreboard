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

  FightAction(
      {int? id,
      required this.actionType,
      required this.fight,
      required this.duration,
      required this.role,
      this.pointCount})
      : super(id);

  factory FightAction.fromJson(Map<String, dynamic> json) => _$FightActionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FightActionToJson(this);

  static Future<FightAction> fromRaw(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async => FightAction(
        id: e['id'] as int?,
        actionType: FightActionTypeParser.valueOf(e['action_type']),
        duration: Duration(milliseconds: e['duration_millis']),
        role: FightRoleParser.valueOf(e['fight_role']),
        pointCount: e['point_count'] as int?,
        fight: (await getSingle<Fight>(e['fight_id'] as int))!,
      );

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'action_type': actionType.name,
      'duration_millis': duration.inMilliseconds,
      'fight_role': role.name,
      'point_count': pointCount,
      'fight_id': fight.id,
    };
  }

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
