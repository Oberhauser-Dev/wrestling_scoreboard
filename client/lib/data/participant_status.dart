import 'package:common/common.dart';
import 'package:flutter/cupertino.dart';

import 'participant.dart';

class ClientParticipantStatus extends ParticipantStatus with ChangeNotifier {
  ClientParticipantStatus(
      {int? id, required ClientMembership memebership, required WeightClass weightClass, double? weight})
      : super(id: id, membership: memebership, weightClass: weightClass, weight: weight);

  ClientParticipantStatus.from(ParticipantStatus obj)
      : this(
          memebership: ClientMembership.from(obj.membership),
          weightClass: obj.weightClass,
          weight: obj.weight,
        );

  factory ClientParticipantStatus.fromJson(Map<String, dynamic> json) =>
      ClientParticipantStatus.from(ParticipantStatus.fromJson(json));

  addAction(FightAction action) {
    super.addAction(action);
    notifyListeners();
  }

  removeAction(FightAction action) {
    super.removeAction(action);
    notifyListeners();
  }

  set classificationPoints(int? points) {
    super.classificationPoints = points;
    notifyListeners();
  }
}
