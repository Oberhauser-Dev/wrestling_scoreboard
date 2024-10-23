import 'package:wrestling_scoreboard_common/common.dart';

class ParticipantStateModel {
  ParticipantState? pStatus;
  ObservableStopwatch injuryStopwatch = ObservableStopwatch();
  ObservableStopwatch bleedingInjuryStopwatch = ObservableStopwatch();
  ObservableStopwatch? activityStopwatch;
  bool isInjury = false;
  bool isInjuryDisplayed = false;
  bool isBleedingInjury = false;
  bool isBleedingInjuryDisplayed = false;

  ParticipantStateModel(this.pStatus);
}
