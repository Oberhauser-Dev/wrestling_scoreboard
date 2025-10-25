import 'package:flutter/foundation.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class MainStopwatch {
  // Use value notifier to not need to reload the whole widget.
  final isBreak = ValueNotifier(false);
  final ObservableStopwatch boutStopwatch;
  final ObservableStopwatch breakStopwatch;

  ObservableStopwatch get stopwatch => isBreak.value ? breakStopwatch : boutStopwatch;

  MainStopwatch({required this.boutStopwatch, required this.breakStopwatch});
}
