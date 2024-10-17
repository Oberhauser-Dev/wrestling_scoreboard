import 'package:wrestling_scoreboard_common/common.dart';

class ParticipantStateModel {
  ParticipantState? pStatus;
  ObservableStopwatch injuryStopwatch = ObservableStopwatch();
  ObservableStopwatch bleedingInjuryStopwatch = ObservableStopwatch();
  ObservableStopwatch? activityStopwatch;
  bool isInjury = false;
  bool isBleedingInjury = false;

  ParticipantStateModel(this.pStatus);
}
