import 'dart:async';

class MockableDateTime {
  static bool isMocked = false;
  static DateTime mockedDateTime = DateTime(2021, 6, 15);

  static DateTime now() => MockableDateTime.isMocked ? mockedDateTime : DateTime.now();
}

class ObservableStopwatch extends Stopwatch {
  final StreamController onStart = StreamController.broadcast();
  final StreamController<bool> onStartStop = StreamController.broadcast();
  final StreamController<Duration> onStop = StreamController.broadcast();
  final StreamController<Duration> onEnd = StreamController.broadcast();
  final StreamController<Duration> onChange = StreamController.broadcast();
  final StreamController<Duration> onAdd = StreamController.broadcast();
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

  @override
  Duration get elapsed => super.elapsed + presetDuration;

  set elapsed(Duration duration) {
    add(duration - elapsed);
  }

  void add(Duration duration) {
    presetDuration += duration;
    onAdd.add(duration);
    _handleTick();
  }

  @override
  void start() {
    if (!isRunning) {
      _timer = Timer.periodic(tick, (Timer timer) {
        _handleTick();
      });
      super.start();
      onStart.add(null);
      _onStartStop();
    }
  }

  void _handleTick() {
    final elapsed = this.elapsed;
    onChange.add(elapsed);
    if (elapsed.inSeconds != _prevDuration.inSeconds) {
      onChangeSecond.add(this.elapsed);
      if (elapsed.inMinutes != _prevDuration.inMinutes) onChangeMinute.add(this.elapsed);
    }
    if (limit != null && elapsed >= limit!) {
      stop();
      onEnd.add(this.elapsed);
    }
    _prevDuration = elapsed;
  }

  @override
  void stop() {
    if (isRunning) {
      _timer?.cancel();
      super.stop();
      onStop.add(elapsed);
      _onStartStop();
    }
  }

  void startStop() {
    isRunning ? stop() : start();
  }

  void _onStartStop() {
    onStartStop.add(super.isRunning);
  }

  @override
  void reset() {
    stop();
    super.reset();
    _prevDuration = Duration();
    presetDuration = Duration();
  }

  void dispose() {
    stop();
    onStart.close();
    onStartStop.close();
    onStop.close();
    onEnd.close();
    onAdd.close();
    onChange.close();
    onChangeSecond.close();
    onChangeMinute.close();
  }
}

String durationToString(Duration duration) {
  return '${duration.inMinutes.remainder(60)}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
}
