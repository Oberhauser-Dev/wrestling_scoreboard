import 'package:common/common.dart';

class ParticipantStateModel {
  ParticipantState? pStatus;
  ObservableStopwatch injuryStopwatch = ObservableStopwatch();
  ObservableStopwatch? activityStopwatch;
  bool isInjury = false;

  ParticipantStateModel(this.pStatus);
}
