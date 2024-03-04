import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/duration.dart';
import 'package:wrestling_scoreboard_client/view/utils.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaled_text.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class TimeDisplay extends StatefulWidget {
  final Color color;
  final ObservableStopwatch stopwatch;
  final double? fontSize;
  final Duration maxDuration;

  const TimeDisplay(this.stopwatch, this.color, {this.fontSize, super.key, required this.maxDuration});

  @override
  State<StatefulWidget> createState() => TimeDisplayState();
}

class TimeDisplayState extends State<TimeDisplay> {
  late Duration _currentTime;

  @override
  void initState() {
    super.initState();
    widget.stopwatch.onChangeSecond.stream.listen((duration) {
      if (mounted) {
        setState(() {
          _currentTime = duration;
        });
      }
    });
    widget.stopwatch.onStartStop.stream.listen((event) {
      // Update color
      if (mounted) {
        setState(() {});
      }
    });
    _currentTime = widget.stopwatch.elapsed;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final val = await showDialog<Duration>(
          builder: (context) => DurationDialog(initialValue: _currentTime, maxValue: widget.maxDuration),
          context: context,
        );
        if (val != null) {
          widget.stopwatch.elapsed = val;
        }
      },
      child: ScaledText(
        _currentTime.formatMinutesAndSeconds(),
        fontSize: widget.fontSize ?? 14,
        color: widget.stopwatch.isRunning ? widget.color : widget.color.disabled(),
        minFontSize: 12,
        softWrap: false,
      ),
    );
  }
}
