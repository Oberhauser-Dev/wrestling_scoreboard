import 'package:common/common.dart';
import 'package:flutter/cupertino.dart';

class ClientParticipantState extends ParticipantState with ChangeNotifier {
  ClientParticipantState({
    int? id,
    required Participation participation,
  }) : super(id: id, participation: participation);

  ClientParticipantState.from(ParticipantState obj) : this(id: obj.id, participation: obj.participation);

  factory ClientParticipantState.fromJson(Map<String, dynamic> json) =>
      ClientParticipantState.from(ParticipantState.fromJson(json));

  @override
  addAction(FightAction action) {
    super.addAction(action);
    notifyListeners();
  }

  @override
  removeAction(FightAction action) {
    super.removeAction(action);
    notifyListeners();
  }

  @override
  set classificationPoints(int? points) {
    super.classificationPoints = points;
    notifyListeners();
  }
}
