import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:wrestling_scoreboard/data/action.dart';
import 'package:wrestling_scoreboard/data/fight.dart';
import 'package:wrestling_scoreboard/data/participant_status.dart';

class FightShortCuts extends StatelessWidget {
  final Widget child;
  final StopWatchTimer stopwatch;
  final Fight fight;

  FightShortCuts({required this.child, required this.stopwatch, required this.fight});

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.space): const StopwatchIntent(),
        LogicalKeySet(LogicalKeyboardKey.arrowUp): const IncrementStopWatchIntent(),
        LogicalKeySet(LogicalKeyboardKey.arrowDown): const DecrementStopwatchIntent(),
        LogicalKeySet(LogicalKeyboardKey.keyF): WrestlingActionIntent(
            WrestlingAction(duration: fight.duration, actionType: ActionType.points, pointCount: 1)),
        LogicalKeySet(LogicalKeyboardKey.digit1): WrestlingActionIntent(
            WrestlingAction(duration: fight.duration, actionType: ActionType.points, pointCount: 1)),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          StopwatchIntent: ToggleStopwatchAction(stopwatch),
          IncrementStopWatchIntent: IncrementStopwatchAction(stopwatch),
          DecrementStopwatchIntent: DecrementStopwatchAction(stopwatch),
        },
        child: Focus(
          autofocus: true,
          child: child,
        ),
      ),
    );
  }
}

// Stopwatch

class StopwatchIntent extends Intent {
  const StopwatchIntent();
}

class ToggleStopwatchAction extends Action<StopwatchIntent> {
  final StopWatchTimer stopwatch;

  ToggleStopwatchAction(this.stopwatch);

  @override
  void invoke(covariant StopwatchIntent intent) {
    stopwatch.isRunning
        ? stopwatch.onExecute.add(StopWatchExecute.stop)
        : stopwatch.onExecute.add(StopWatchExecute.start);
  }
}

class IncrementStopWatchIntent extends Intent {
  const IncrementStopWatchIntent();
}

class DecrementStopwatchIntent extends Intent {
  const DecrementStopwatchIntent();
}

class IncrementStopwatchAction extends Action<IncrementStopWatchIntent> {
  IncrementStopwatchAction(this.stopwatch);

  final StopWatchTimer stopwatch;

  @override
  void invoke(covariant IncrementStopWatchIntent intent) {
    stopwatch.setPresetSecondTime(1);
  }
}

class DecrementStopwatchAction extends Action<DecrementStopwatchIntent> {
  DecrementStopwatchAction(this.stopwatch);

  final StopWatchTimer stopwatch;

  @override
  void invoke(covariant DecrementStopwatchIntent intent) {
    stopwatch.setPresetSecondTime(-1);
  }
}

// Points
class WrestlingActionIntent extends Intent {
  const WrestlingActionIntent(this.action);

  final WrestlingAction action;
}

class WrestlingActionAction extends Action<WrestlingActionIntent> {
  WrestlingActionAction(this.pStatus);

  final ParticipantStatus pStatus;

  @override
  void invoke(covariant WrestlingActionIntent intent) {
    pStatus.actions.add(intent.action);
  }
}

class RemoveWrestlingActionIntent extends Intent {
  const RemoveWrestlingActionIntent(this.action);

  final WrestlingAction action;
}

class RemoveWrestlingActionAction extends Action<WrestlingActionIntent> {
  RemoveWrestlingActionAction(this.pStatus);

  final ParticipantStatus pStatus;

  @override
  void invoke(covariant WrestlingActionIntent intent) {
    pStatus.actions.remove(intent.action);
  }
}
