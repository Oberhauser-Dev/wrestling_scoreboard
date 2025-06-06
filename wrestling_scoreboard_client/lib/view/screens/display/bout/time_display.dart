import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/duration.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/utils/duration.dart';
import 'package:wrestling_scoreboard_client/view/utils.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaled_text.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class TimeDisplay extends ConsumerStatefulWidget {
  final Color color;
  final ObservableStopwatch stopwatch;
  final double? fontSize;
  final Duration maxDuration;

  const TimeDisplay(this.stopwatch, this.color, {this.fontSize, super.key, required this.maxDuration});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => TimeDisplayState();
}

class TimeDisplayState extends ConsumerState<TimeDisplay> {
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
    return LoadingBuilder<bool>(
      future: ref.watch(timeCountDownNotifierProvider),
      builder: (context, isTimeCountDown) {
        Duration adjustedTime() => _currentTime.invertIf(isTimeCountDown, max: widget.maxDuration);
        return GestureDetector(
          onTap: () async {
            final val = await showDurationDialog(
              context: context,
              initialDuration: adjustedTime(),
              maxValue: widget.maxDuration,
            );
            if (val != null) {
              widget.stopwatch.elapsed = val.invertIf(isTimeCountDown, max: widget.maxDuration);
            }
          },
          child: ScaledText(
            adjustedTime().formatMinutesAndSeconds(),
            fontSize: widget.fontSize ?? 14,
            color: widget.stopwatch.isRunning ? widget.color : widget.color.disabled(),
            minFontSize: 12,
            softWrap: false,
          ),
        );
      },
    );
  }
}
