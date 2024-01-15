import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/data/time.dart';
import 'package:wrestling_scoreboard_client/ui/components/scaled_text.dart';
import 'package:wrestling_scoreboard_client/ui/utils.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class TimeDisplay extends StatefulWidget {
  final Color color;
  final ObservableStopwatch stopwatch;
  final double? fontSize;

  const TimeDisplay(this.stopwatch, this.color, {this.fontSize, super.key});

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
        _currentTime = formatTime(duration);
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

    return ScaledText(
      _currentTime,
      fontSize: widget.fontSize ?? 14,
      color: widget.stopwatch.isRunning ? widget.color : widget.color.disabled(),
      minFontSize: 12,
      softWrap: false,
    );
  }
}
