import 'package:common/src/data/data_object.dart';
import 'package:json_annotation/json_annotation.dart';

import 'fight_action.dart';
import 'membership.dart';
import 'weight_class.dart';

part 'participant_status.g.dart';
@JsonSerializable()
class ParticipantStatus extends DataObject {
  final Membership membership;
  final WeightClass weightClass;
  final List<FightAction> _actions = [];
  double? weight;
  int? _classificationPoints;

  ParticipantStatus({int? id, required this.membership, required this.weightClass, this.weight}) : super(id);

  factory ParticipantStatus.fromJson(Map<String, dynamic> json) => _$ParticipantStatusFromJson(json);

  Map<String, dynamic> toJson() => _$ParticipantStatusToJson(this);

  get actions => this._actions;

  addAction(FightAction action) {
    _actions.add(action);
  }

  removeAction(FightAction action) {
    _actions.remove(action);
  }

  set classificationPoints(int? points) {
    _classificationPoints = points;
  }

  int? get classificationPoints => _classificationPoints;

  int get technicalPoints {
    int res = 0;
    _actions.forEach((el) {
      if (el.actionType == FightActionType.points) {
        res += el.pointCount!;
      }
    });
    return res;
  }
}
