import 'package:common/common.dart';
import 'package:flutter/cupertino.dart';

import 'participant.dart';

class ClientParticipantStatus extends ParticipantStatus with ChangeNotifier {
  ClientParticipantStatus({required ClientParticipant participant, required WeightClass weightClass, double? weight})
      : super(participant: participant, weightClass: weightClass, weight: weight);

  ClientParticipantStatus.from(ParticipantStatus obj) : this(participant: ClientParticipant.from(obj.participant), weightClass: obj.weightClass, weight: obj.weight);

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
