import 'dart:async';

class MockableDateTime {
  static bool isMocked = false;
  static DateTime mockedDateTime = DateTime(2021, 6, 15);

  static now() => MockableDateTime.isMocked ? mockedDateTime : DateTime.now();
}

class ObservableStopwatch extends Stopwatch {
  final void Function()? onStart;
  final void Function()? onStartStop;
  final void Function()? onStop;
  final void Function()? onEnd;
  final void Function(Duration)? onChange;
  final void Function(Duration)? onChangeSecond;
  final void Function(Duration)? onChangeMinute;
  Timer? _timer;
  Duration presetDuration = Duration();
  Duration _prevDuration = Duration();
  Duration? limit;
  final Duration tick;

  ObservableStopwatch({
    this.onStartStop,
    this.onStart,
    this.onStop,
    this.onChange,
    this.onChangeSecond,
    this.onChangeMinute,
    this.limit,
    this.onEnd,
    this.tick = const Duration(milliseconds: 30),
  });

  get elapsed => super.elapsed + presetDuration;

  addDuration(Duration duration) {
    presetDuration += duration;
    _handleTick();
  }

  start() {
    if (!isRunning) {
      _timer = Timer.periodic(tick, (Timer timer) {
        _handleTick();
      });
      super.start();
      if (onStart != null) onStart!();
      _onStartStop();
    }
  }

  _handleTick() {
    var elapsed = this.elapsed;
    if (onChange != null) onChange!(this.elapsed);
    if (elapsed.inSeconds != _prevDuration.inSeconds) {
      if (onChangeSecond != null) onChangeSecond!(this.elapsed);
      if (onChangeMinute != null && elapsed.inMinutes != _prevDuration.inMinutes) onChangeMinute!(this.elapsed);
    }
    if (limit != null && elapsed >= limit!) {
      this.stop();
      if (onEnd != null) onEnd!();
    }
    _prevDuration = elapsed;
  }

  stop() {
    if (isRunning) {
      _timer?.cancel();
      super.stop();
      if (onStop != null) onStop!();
      _onStartStop();
    }
  }

  startStop() {
    this.isRunning ? this.stop() : this.start();
  }

  _onStartStop() {
    if (onStartStop != null) onStartStop!();
  }

  reset() {
    stop();
    super.reset();
    _prevDuration = Duration();
    presetDuration = Duration();
  }
}

durationToString(Duration duration) {
  return '${duration.inMinutes.remainder(60)}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
}
