import 'package:flutter/foundation.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class ParticipantStateModel {
  /// Activity stop watch
  final ValueNotifier<ObservableStopwatch?> activityStopwatchNotifier = ValueNotifier(null);

  ObservableStopwatch? get activityStopwatch => activityStopwatchNotifier.value;

  /// Injury stop watch
  ObservableStopwatch injuryStopwatch = ObservableStopwatch();
  bool isInjury = false;

  /// Needed to display & edit injury time, after they have ended.
  final isInjuryDisplayedNotifier = ValueNotifier(false);

  bool get isInjuryDisplayed => isInjuryDisplayedNotifier.value;

  /// Bleeding Injury stop watch
  ObservableStopwatch bleedingInjuryStopwatch = ObservableStopwatch();
  bool isBleedingInjury = false;

  /// Needed to display & edit injury time, after they have ended.
  final isBleedingInjuryDisplayedNotifier = ValueNotifier(false);

  bool get isBleedingInjuryDisplayed => isBleedingInjuryDisplayedNotifier.value;
}
