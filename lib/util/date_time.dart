import 'dart:async';

class MockableDateTime {
  static bool isMocked = false;
  static DateTime mockedDateTime = DateTime(2021, 6, 15);

  static now() => MockableDateTime.isMocked ? mockedDateTime : DateTime.now();
}

class ObservableStopwatch extends Stopwatch {
  final StreamController onStart = StreamController.broadcast();
  final StreamController<bool> onStartStop = StreamController.broadcast();
  final StreamController<Duration> onStop = StreamController.broadcast();
  final StreamController<Duration> onEnd = StreamController.broadcast();
  final StreamController<Duration> onChange = StreamController.broadcast();
  final StreamController<Duration> onChangeSecond = StreamController.broadcast();
  final StreamController<Duration> onChangeMinute = StreamController.broadcast();
  Timer? _timer;
  Duration presetDuration = Duration();
  Duration _prevDuration = Duration();
  Duration? limit;
  final Duration tick;

  ObservableStopwatch({
    this.limit,
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
      onStart.add(null);
      _onStartStop();
    }
  }

  _handleTick() {
    var elapsed = this.elapsed;
    onChange.add(this.elapsed);
    if (elapsed.inSeconds != _prevDuration.inSeconds) {
      onChangeSecond.add(this.elapsed);
      if (elapsed.inMinutes != _prevDuration.inMinutes) onChangeMinute.add(this.elapsed);
    }
    if (limit != null && elapsed >= limit!) {
      this.stop();
      onEnd.add(this.elapsed);
    }
    _prevDuration = elapsed;
  }

  stop() {
    if (isRunning) {
      _timer?.cancel();
      super.stop();
      onStop.add(this.elapsed);
      _onStartStop();
    }
  }

  startStop() {
    this.isRunning ? this.stop() : this.start();
  }

  _onStartStop() {
    onStartStop.add(super.isRunning);
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
