import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/duration.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/utils/duration.dart';
import 'package:wrestling_scoreboard_client/view/utils.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaled_container.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaled_text.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class TimeDisplay extends ConsumerStatefulWidget {
  /// The color of the time, which is the color of the surrounding text by default.
  final Color? color;
  final ObservableStopwatch stopwatch;
  final double? fontSize;
  final double? minFontSize;
  final Duration maxDuration;
  final bool showDeciSecond;

  const TimeDisplay(
    this.stopwatch, {
    this.color,
    this.fontSize,
    this.minFontSize,
    super.key,
    required this.maxDuration,
    this.showDeciSecond = false,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => TimeDisplayState();
}

class TimeDisplayState extends ConsumerState<TimeDisplay> {
  late Duration _currentTime;
  late ObservableStopwatch _stopwatch;
  StreamSubscription<Duration>? _deciSecondStopwatchSubscription;
  StreamSubscription<bool>? _startStopStopwatchSubscription;

  @override
  void initState() {
    super.initState();
    _updateStopwatch();
  }

  @override
  void didUpdateWidget(covariant TimeDisplay oldWidget) {
    if (oldWidget.stopwatch != widget.stopwatch) {
      _updateStopwatch();
      setState(() {});
    }
    if (oldWidget.color != widget.color) {
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _deciSecondStopwatchSubscription?.cancel();
    _startStopStopwatchSubscription?.cancel();
    super.dispose();
  }

  void _updateStopwatch() {
    _stopwatch = widget.stopwatch;
    _deciSecondStopwatchSubscription?.cancel();
    _startStopStopwatchSubscription?.cancel();
    _deciSecondStopwatchSubscription = _stopwatch.onChangeDeciSecond.stream.listen((duration) {
      if (mounted) {
        setState(() {
          _currentTime = duration;
        });
      }
    });
    _startStopStopwatchSubscription = _stopwatch.onStartStop.stream.listen((event) {
      // Update color
      if (mounted) {
        setState(() {});
      }
    });
    _currentTime = _stopwatch.elapsed;
  }

  @override
  Widget build(BuildContext context) {
    return LoadingBuilder<bool>(
      future: ref.watch(timeCountDownProvider),
      builder: (context, isTimeCountDown) {
        Duration adjustedTime() => _currentTime.invertIf(isTimeCountDown, max: widget.maxDuration);
        final color = widget.color ?? DefaultTextStyle.of(context).style.color!;
        // In high contrast mode, outline the paused time instead of lowering its contrast.
        final outlined = !_stopwatch.isRunning && MediaQuery.highContrastOf(context);
        final textColor = _stopwatch.isRunning || outlined ? color : color.onSurfaceVariant();
        return GestureDetector(
          onTap: () async {
            final val = await showDurationDialog(
              context: context,
              initialDuration: adjustedTime(),
              maxValue: widget.maxDuration,
            );
            if (val != null) {
              _stopwatch.elapsed = val.invertIf(isTimeCountDown, max: widget.maxDuration);
            }
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaledText(
                adjustedTime().formatMinutesAndSeconds(),
                fontSize: widget.fontSize ?? 14,
                color: textColor,
                outlined: outlined,
                minFontSize: widget.minFontSize ?? 12,
                softWrap: false,
                fontWeight: FontWeight.w600,
              ),
              if (widget.showDeciSecond)
                Padding(
                  // Align deci seconds to the text baseline
                  padding: EdgeInsets.symmetric(
                    vertical: ((widget.fontSize ?? 14) / 4) * MediaQuery.of(context).size.width / 1000,
                  ),
                  // Avoid jumping of the deci seconds by using a fixed width container, e.g. see font "Albert Sans".
                  child: ScaledContainer(
                    width: 0.02,
                    child: ScaledText(
                      adjustedTime().formatDeciSeconds(),
                      fontSize: (widget.fontSize ?? 14) / 4,
                      color: textColor,
                      outlined: outlined,
                      minFontSize: 8,
                      softWrap: false,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
