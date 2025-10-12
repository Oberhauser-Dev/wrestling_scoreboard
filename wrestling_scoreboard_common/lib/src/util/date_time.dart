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
  final StreamController<Duration> onChangeDeciSecond = StreamController.broadcast();
  final StreamController<Duration> onChangeMinute = StreamController.broadcast();
  Timer? _timer;
  Duration presetDuration = Duration();
  Duration _prevDuration = Duration();
  Duration? limit;
  final Duration tick;
  final bool roundToUnit;
  bool isDisposed = false;

  ObservableStopwatch({this.limit, this.tick = const Duration(milliseconds: 30), this.roundToUnit = true});

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
    final inDeciSeconds = _toDeciSeconds(elapsed);
    if (inDeciSeconds != _toDeciSeconds(_prevDuration)) {
      onChangeDeciSecond.add(roundToUnit ? Duration(milliseconds: inDeciSeconds * 100) : elapsed);
      final inSeconds = elapsed.inSeconds;
      if (inSeconds != _prevDuration.inSeconds) {
        onChangeSecond.add(roundToUnit ? Duration(seconds: inSeconds) : elapsed);
        final inMinutes = elapsed.inMinutes;
        if (inMinutes != _prevDuration.inMinutes) {
          onChangeMinute.add(roundToUnit ? Duration(minutes: inMinutes) : elapsed);
        }
      }
    }
    if (hasEnded) {
      stopAt(limit!);
      onEnd.add(elapsed);
    }
    _prevDuration = elapsed;
  }

  int _toDeciSeconds(Duration duration) {
    return duration.inMilliseconds ~/ 100;
  }

  bool get hasEnded => limit != null && elapsed >= limit!;

  @override
  void stop() {
    if (isRunning) {
      _timer?.cancel();
      super.stop();
      onStop.add(elapsed);
      _onStartStop();
    }
  }

  /// Stop precisely at the given [elapsed] duration.
  void stopAt(Duration elapsed) {
    if (isRunning) {
      _timer?.cancel();
      super.stop();
      this.elapsed = elapsed;
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
    if (isDisposed) return;
    isDisposed = true;
    stop();
    onStart.close();
    onStartStop.close();
    onStop.close();
    onEnd.close();
    onAdd.close();
    onChange.close();
    onChangeDeciSecond.close();
    onChangeSecond.close();
    onChangeMinute.close();
  }
}
