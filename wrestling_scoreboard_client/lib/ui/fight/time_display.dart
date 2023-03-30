import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard/ui/components/fitted_text.dart';

class TimeDisplay extends StatefulWidget {
  final MaterialColor color;
  final ObservableStopwatch stopwatch;

  const TimeDisplay(this.stopwatch, this.color, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TimeDisplayState();
}

class TimeDisplayState extends State<TimeDisplay> {
  String _currentTime = '0:00';

  update() {
    // Update color
    if (mounted) {
      setState(() {
        _currentTime = _currentTime;
      });
    }
  }

  updateDisplayTime(Duration duration) {
    if (mounted) {
      setState(() {
        _currentTime =
            '${duration.inMinutes.remainder(60)}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.stopwatch.onChangeSecond.stream.listen((event) {
      updateDisplayTime(event);
    });
    widget.stopwatch.onStartStop.stream.listen((event) {
      update();
    });
    updateDisplayTime(widget.stopwatch.elapsed);

    return FittedText(
      _currentTime,
      style: TextStyle(color: widget.stopwatch.isRunning ? widget.color : widget.color.shade200),
    );
  }
}
