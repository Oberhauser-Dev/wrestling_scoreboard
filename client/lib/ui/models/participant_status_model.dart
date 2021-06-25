import 'package:common/common.dart';
import 'package:common/src/util/date_time.dart';

class ParticipantStatusModel {
  ParticipantStatus? pStatus;
  ObservableStopwatch injuryStopwatch = ObservableStopwatch();
  ObservableStopwatch? activityStopwatch;
  bool isInjury = false;

  ParticipantStatusModel(this.pStatus);
}
