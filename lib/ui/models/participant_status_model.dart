import 'package:wrestling_scoreboard/data/participant_status.dart';
import 'package:wrestling_scoreboard/util/date_time.dart';

class ParticipantStatusModel {
  ParticipantStatus? pStatus;
  ObservableStopwatch? injuryStopwatch;
  ObservableStopwatch? activityStopwatch;

  ParticipantStatusModel(this.pStatus);
}
