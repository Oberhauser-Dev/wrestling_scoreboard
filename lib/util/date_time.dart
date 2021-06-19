import 'dart:ui';

import 'package:stop_watch_timer/stop_watch_timer.dart';

class MockableDateTime {
  static bool isMocked = false;
  static DateTime mockedDateTime = DateTime(2021, 6, 15);

  static now() => MockableDateTime.isMocked ? mockedDateTime : DateTime.now();
}

class CustomStopWatchTimer {
  final void Function()? onStart;
  final void Function()? onStartStop;
  final void Function()? onStop;
  final void Function(int)? onChangeSecond;
  late final StopWatchTimer instance;
  int _savePresetSeconds = 0;
  int _currentMillis = 0;

  CustomStopWatchTimer({
    bool isLapHours = true,
    mode = StopWatchMode.countUp,
    int presetMillisecond = 0,
    Function(int)? onChange,
    Function(int)? onChangeRawSecond,
    Function(int)? onChangeRawMinute,
    VoidCallback? onEnded,
    this.onStartStop,
    this.onStart,
    this.onStop,
    this.onChangeSecond,
  }) {
    instance = StopWatchTimer(
        isLapHours: isLapHours,
        mode: mode,
        presetMillisecond: presetMillisecond,
        onChange: onChange,
        onChangeRawSecond: (int val) {
          if (onChangeRawSecond != null) onChangeRawSecond(val);
          if (onChangeSecond != null) {
            // Fix preset seconds
            if (!instance.isRunning) {
              _currentMillis = _currentMillis + (val - _savePresetSeconds) * 1000;
              _savePresetSeconds = val;
            } else {
              _currentMillis = val * 1000;
            }
            onChangeSecond!(_currentMillis ~/ 1000);
          }
        },
        onChangeRawMinute: onChangeRawMinute,
        onEnded: onEnded);
  }

  get isRunning => instance.isRunning;

  get currentMillis => _currentMillis;

  addTime({int? millis, int sec = 0}) {
    instance.setPresetTime(mSec: millis ?? sec * 1000);
  }

  start() {
    if (!instance.isRunning) {
      instance.onExecute.add(StopWatchExecute.start);
      this._currentMillis = instance.rawTime.value;
      if (onStart != null) onStart!();
      _onStartStop();
    }
  }

  stop() {
    if (instance.isRunning) {
      if (onStop != null) onStop!();
      _onStartStop();
      this._currentMillis = instance.rawTime.value;
      instance.onExecute.add(StopWatchExecute.stop);
    }
  }

  _onStartStop() {
    if (onStartStop != null) onStartStop!();
  }

  reset() {
    stop();
    instance.onExecute.add(StopWatchExecute.reset);
  }

  dispose() {
    instance.dispose();
  }
}

durationToString(Duration duration) {
  return '${duration.inMinutes.remainder(60)}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
}
