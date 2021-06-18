import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:wrestling_scoreboard/data/fight.dart';
import 'package:wrestling_scoreboard/data/fight_action.dart';
import 'package:wrestling_scoreboard/data/fight_role.dart';

class FightShortCuts extends StatelessWidget {
  final Widget child;
  final StopWatchTimer stopwatch;
  final Fight fight;

  FightShortCuts({required this.child, required this.stopwatch, required this.fight});

  @override
  Widget build(BuildContext context) {
    final redOneIntent = RedOneFightActionIntent(
        FightAction(actor: FightRole.red, duration: fight.duration, actionType: FightActionType.points, pointCount: 1));
    final blueOneIntent = BlueOneFightActionIntent(FightAction(
        actor: FightRole.blue, duration: fight.duration, actionType: FightActionType.points, pointCount: 1));
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.space): const StopwatchIntent(),
        LogicalKeySet(LogicalKeyboardKey.arrowUp): const IncrementStopWatchIntent(),
        LogicalKeySet(LogicalKeyboardKey.arrowDown): const DecrementStopwatchIntent(),
        LogicalKeySet(LogicalKeyboardKey.keyF): redOneIntent,
        LogicalKeySet(LogicalKeyboardKey.digit1): redOneIntent,
        LogicalKeySet(LogicalKeyboardKey.keyJ): blueOneIntent,
        LogicalKeySet(LogicalKeyboardKey.numpad1): blueOneIntent,
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          StopwatchIntent: ToggleStopwatchAction(stopwatch),
          IncrementStopWatchIntent: IncrementStopwatchAction(stopwatch),
          DecrementStopwatchIntent: DecrementStopwatchAction(stopwatch),
          RedOneFightActionIntent: AddFightActionAction(fight),
          BlueOneFightActionIntent: AddFightActionAction(fight),
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
abstract class FightActionIntent extends Intent {
  final FightAction action;

  const FightActionIntent(this.action);
}

class RedOneFightActionIntent extends FightActionIntent {
  RedOneFightActionIntent(FightAction action) : super(action);
}

class BlueOneFightActionIntent extends FightActionIntent {
  BlueOneFightActionIntent(FightAction action) : super(action);
}

class AddFightActionAction extends Action<FightActionIntent> {
  final Fight fight;

  AddFightActionAction(this.fight);

  @override
  void invoke(covariant FightActionIntent intent) {
    fight.addAction(intent.action);
  }
}

class RemoveFightActionAction extends Action<FightActionIntent> {
  final Fight fight;

  RemoveFightActionAction(this.fight);

  @override
  void invoke(covariant FightActionIntent intent) {
    fight.removeAction(intent.action);
  }
}
