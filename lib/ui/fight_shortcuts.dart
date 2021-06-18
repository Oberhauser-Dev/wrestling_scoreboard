import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:wrestling_scoreboard/data/fight.dart';
import 'package:wrestling_scoreboard/data/fight_action.dart';
import 'package:wrestling_scoreboard/data/fight_role.dart';

enum FightScreenActions {
  StartStop,
  Reset,
  AddOneSec,
  RmOneSec,
  Undo,
  RedOne,
  RedTwo,
  RedThree,
  RedFour,
  RedPassivity,
  RedCaution,
  RedDismissal,
  RedUndo,
  BlueOne,
  BlueTwo,
  BlueThree,
  BlueFour,
  BluePassivity,
  BlueCaution,
  BlueDismissal,
  BlueUndo,
}

class FightScreenActionIntent extends Intent {
  const FightScreenActionIntent({required this.type});

  const FightScreenActionIntent.StartStop() : type = FightScreenActions.StartStop;

  const FightScreenActionIntent.Reset() : type = FightScreenActions.Reset;

  const FightScreenActionIntent.AddOneSec() : type = FightScreenActions.AddOneSec;

  const FightScreenActionIntent.RmOneSec() : type = FightScreenActions.RmOneSec;

  const FightScreenActionIntent.Undo() : type = FightScreenActions.Undo;

  const FightScreenActionIntent.RedOne() : type = FightScreenActions.RedOne;

  const FightScreenActionIntent.RedTwo() : type = FightScreenActions.RedTwo;

  const FightScreenActionIntent.RedThree() : type = FightScreenActions.RedThree;

  const FightScreenActionIntent.RedFour() : type = FightScreenActions.RedFour;

  const FightScreenActionIntent.RedPassivity() : type = FightScreenActions.RedPassivity;

  const FightScreenActionIntent.RedCaution() : type = FightScreenActions.RedCaution;

  const FightScreenActionIntent.RedDismissal() : type = FightScreenActions.RedDismissal;

  const FightScreenActionIntent.RedUndo() : type = FightScreenActions.RedUndo;

  const FightScreenActionIntent.BlueOne() : type = FightScreenActions.BlueOne;

  const FightScreenActionIntent.BlueTwo() : type = FightScreenActions.BlueTwo;

  const FightScreenActionIntent.BlueThree() : type = FightScreenActions.BlueThree;

  const FightScreenActionIntent.BlueFour() : type = FightScreenActions.BlueFour;

  const FightScreenActionIntent.BluePassivity() : type = FightScreenActions.BluePassivity;

  const FightScreenActionIntent.BlueCaution() : type = FightScreenActions.BlueCaution;

  const FightScreenActionIntent.BlueDismissal() : type = FightScreenActions.BlueDismissal;

  const FightScreenActionIntent.BlueUndo() : type = FightScreenActions.BlueUndo;
  final FightScreenActions type;
}

class FightActionHandler extends StatelessWidget {
  final Widget child;
  final StopWatchTimer stopwatch;
  final Fight fight;

  FightActionHandler({required this.child, required this.stopwatch, required this.fight});

  handleIntent(FightScreenActionIntent intent) {
    handleIntentStatic(intent, this.stopwatch, this.fight);
  }

  static handleIntentStatic(FightScreenActionIntent intent, StopWatchTimer stopwatch, Fight fight) {
    switch (intent.type) {
      case FightScreenActions.StartStop:
        stopwatch.isRunning
            ? stopwatch.onExecute.add(StopWatchExecute.stop)
            : stopwatch.onExecute.add(StopWatchExecute.start);
        break;
      case FightScreenActions.AddOneSec:
        stopwatch.setPresetSecondTime(1);
        break;
      case FightScreenActions.RmOneSec:
        stopwatch.setPresetSecondTime(-1);
        break;
      case FightScreenActions.Reset:
        stopwatch.onExecute.add(StopWatchExecute.reset);
        break;
      case FightScreenActions.RedOne:
        fight.addAction(FightAction(
            role: FightRole.red, duration: fight.duration, actionType: FightActionType.points, pointCount: 1));
        break;
      case FightScreenActions.RedTwo:
        fight.addAction(FightAction(
            role: FightRole.red, duration: fight.duration, actionType: FightActionType.points, pointCount: 2));
        break;
      case FightScreenActions.RedThree:
        fight.addAction(FightAction(
            role: FightRole.red, duration: fight.duration, actionType: FightActionType.points, pointCount: 3));
        break;
      case FightScreenActions.RedFour:
        fight.addAction(FightAction(
            role: FightRole.red, duration: fight.duration, actionType: FightActionType.points, pointCount: 4));
        break;
      case FightScreenActions.RedPassivity:
        fight.addAction(
            FightAction(role: FightRole.red, duration: fight.duration, actionType: FightActionType.passivity));
        break;
      case FightScreenActions.RedCaution:
        fight
            .addAction(FightAction(role: FightRole.red, duration: fight.duration, actionType: FightActionType.caution));
        break;
      case FightScreenActions.RedDismissal:
        fight.addAction(
            FightAction(role: FightRole.red, duration: fight.duration, actionType: FightActionType.dismissal));
        break;
      case FightScreenActions.RedUndo:
        if (fight.r != null && fight.r!.actions.isNotEmpty) fight.removeAction(fight.r!.actions.last);
        break;
      case FightScreenActions.BlueOne:
        fight.addAction(FightAction(
            role: FightRole.blue, duration: fight.duration, actionType: FightActionType.points, pointCount: 1));
        break;
      case FightScreenActions.BlueTwo:
        fight.addAction(FightAction(
            role: FightRole.blue, duration: fight.duration, actionType: FightActionType.points, pointCount: 2));
        break;
      case FightScreenActions.BlueThree:
        fight.addAction(FightAction(
            role: FightRole.blue, duration: fight.duration, actionType: FightActionType.points, pointCount: 3));
        break;
      case FightScreenActions.BlueFour:
        fight.addAction(FightAction(
            role: FightRole.blue, duration: fight.duration, actionType: FightActionType.points, pointCount: 4));
        break;
      case FightScreenActions.BluePassivity:
        fight.addAction(
            FightAction(role: FightRole.blue, duration: fight.duration, actionType: FightActionType.passivity));
        break;
      case FightScreenActions.BlueCaution:
        fight.addAction(
            FightAction(role: FightRole.blue, duration: fight.duration, actionType: FightActionType.caution));
        break;
      case FightScreenActions.BlueDismissal:
        fight.addAction(
            FightAction(role: FightRole.blue, duration: fight.duration, actionType: FightActionType.dismissal));
        break;
      case FightScreenActions.BlueUndo:
        if (fight.b != null && fight.b!.actions.isNotEmpty) fight.removeAction(fight.b!.actions.last);
        break;
      case FightScreenActions.Undo:
        if (fight.actions.isNotEmpty) fight.removeAction(fight.actions.last);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final redOneIntent = const FightScreenActionIntent.RedOne();
    final redTwoIntent = const FightScreenActionIntent.RedTwo();
    final redThreeIntent = const FightScreenActionIntent.RedThree();
    final redFourIntent = const FightScreenActionIntent.RedFour();

    final blueOneIntent = const FightScreenActionIntent.BlueOne();
    final blueTwoIntent = const FightScreenActionIntent.BlueTwo();
    final blueThreeIntent = const FightScreenActionIntent.BlueThree();
    final blueFourIntent = const FightScreenActionIntent.BlueFour();
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.space): const FightScreenActionIntent.StartStop(),
        LogicalKeySet(LogicalKeyboardKey.arrowUp): const FightScreenActionIntent.AddOneSec(),
        LogicalKeySet(LogicalKeyboardKey.arrowDown): const FightScreenActionIntent.RmOneSec(),
        LogicalKeySet(LogicalKeyboardKey.backspace): const FightScreenActionIntent.Undo(),
        LogicalKeySet(LogicalKeyboardKey.digit1): redOneIntent,
        LogicalKeySet(LogicalKeyboardKey.digit2): redTwoIntent,
        LogicalKeySet(LogicalKeyboardKey.digit3): redThreeIntent,
        LogicalKeySet(LogicalKeyboardKey.digit4): redFourIntent,
        LogicalKeySet(LogicalKeyboardKey.numpad1): blueOneIntent,
        LogicalKeySet(LogicalKeyboardKey.numpad2): blueTwoIntent,
        LogicalKeySet(LogicalKeyboardKey.numpad3): blueThreeIntent,
        LogicalKeySet(LogicalKeyboardKey.numpad4): blueFourIntent,
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          FightScreenActionIntent: CallbackAction<FightScreenActionIntent>(
            onInvoke: handleIntent,
          )
        },
        child: RawKeyboardListener(
          focusNode: FocusNode(),
          child: Focus(autofocus: true, child: child),
          onKey: (RawKeyEvent event) {
            if (event.runtimeType.toString() == 'RawKeyDownEvent') {
              if (event.physicalKey == PhysicalKeyboardKey.keyF) {
                handleIntent(redOneIntent);
              } else if (event.physicalKey == PhysicalKeyboardKey.keyD) {
                handleIntent(redTwoIntent);
              } else if (event.physicalKey == PhysicalKeyboardKey.keyS) {
                handleIntent(redThreeIntent);
              } else if (event.physicalKey == PhysicalKeyboardKey.keyA) {
                handleIntent(redFourIntent);
              } else if (event.physicalKey == PhysicalKeyboardKey.keyJ ||
                  (event.isShiftPressed && event.physicalKey == PhysicalKeyboardKey.digit1)) {
                handleIntent(blueOneIntent);
              } else if (event.physicalKey == PhysicalKeyboardKey.keyK ||
                  (event.isShiftPressed && event.physicalKey == PhysicalKeyboardKey.digit2)) {
                handleIntent(blueTwoIntent);
              } else if (event.physicalKey == PhysicalKeyboardKey.keyL ||
                  (event.isShiftPressed && event.physicalKey == PhysicalKeyboardKey.digit3)) {
                handleIntent(blueThreeIntent);
              } else if (event.physicalKey == PhysicalKeyboardKey.semicolon ||
                  (event.isShiftPressed && event.physicalKey == PhysicalKeyboardKey.digit4)) {
                handleIntent(blueFourIntent);
              }
            }
          },
        ),
      ),
    );
  }
}
