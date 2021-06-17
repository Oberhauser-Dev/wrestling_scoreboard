import 'action.dart';
import 'participant.dart';
import 'weight_class.dart';

class ParticipantStatus {
  final Participant participant;
  final WeightClass weightClass;
  double? weight;
  List<WrestlingAction> actions = [];
  int? classificationPoints;

  ParticipantStatus({required this.participant, required this.weightClass, this.weight});

  get technicalPoints {
    int res = 0;
    actions.forEach((el) {
      if (el.actionType == ActionType.points) {
        res += el.pointCount!;
      }
    });
    return res;
  }
}
