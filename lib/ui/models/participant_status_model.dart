import 'package:wrestling_scoreboard/data/participant_status.dart';
import 'package:wrestling_scoreboard/util/date_time.dart';

class ParticipantStatusModel {
  ParticipantStatus? pStatus;
  ObservableStopwatch injuryStopwatch = ObservableStopwatch();
  ObservableStopwatch? activityStopwatch;
  bool isInjury = false;

  ParticipantStatusModel(this.pStatus);
}
