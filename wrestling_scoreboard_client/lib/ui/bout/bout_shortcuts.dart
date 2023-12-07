import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/ui/bout/bout_display.dart';
import 'package:wrestling_scoreboard_client/util/audio/audio.dart';
import 'package:wrestling_scoreboard_client/util/network/data_provider.dart';
import 'package:wrestling_scoreboard_common/common.dart';

enum BoutScreenActions {
  startStop,
  reset,
  addOneSec,
  rmOneSec,
  undo,
  nextBout,
  previousBout,
  horn,
  quit,
  redOne,
  redTwo,
  redThree,
  redFour,
  redPassivity,
  redCaution,
  redDismissal,
  redActivityTime,
  redInjuryTime,
  redUndo,
  blueOne,
  blueTwo,
  blueThree,
  blueFour,
  bluePassivity,
  blueCaution,
  blueDismissal,
  blueActivityTime,
  blueInjuryTime,
  blueUndo,
}

class BoutScreenActionIntent extends Intent {
  const BoutScreenActionIntent({required this.type});

  const BoutScreenActionIntent.startStop() : type = BoutScreenActions.startStop;

  const BoutScreenActionIntent.reset() : type = BoutScreenActions.reset;

  const BoutScreenActionIntent.addOneSec() : type = BoutScreenActions.addOneSec;

  const BoutScreenActionIntent.rmOneSec() : type = BoutScreenActions.rmOneSec;

  const BoutScreenActionIntent.undo() : type = BoutScreenActions.undo;

  const BoutScreenActionIntent.nextBout() : type = BoutScreenActions.nextBout;

  const BoutScreenActionIntent.previousBout() : type = BoutScreenActions.previousBout;

  const BoutScreenActionIntent.horn() : type = BoutScreenActions.horn;

  const BoutScreenActionIntent.quit() : type = BoutScreenActions.quit;

  const BoutScreenActionIntent.redOne() : type = BoutScreenActions.redOne;

  const BoutScreenActionIntent.redTwo() : type = BoutScreenActions.redTwo;

  const BoutScreenActionIntent.redThree() : type = BoutScreenActions.redThree;

  const BoutScreenActionIntent.redFour() : type = BoutScreenActions.redFour;

  const BoutScreenActionIntent.redPassivity() : type = BoutScreenActions.redPassivity;

  const BoutScreenActionIntent.redCaution() : type = BoutScreenActions.redCaution;

  const BoutScreenActionIntent.redDismissal() : type = BoutScreenActions.redDismissal;

  const BoutScreenActionIntent.redActivityTime() : type = BoutScreenActions.redActivityTime;

  const BoutScreenActionIntent.redInjuryTime() : type = BoutScreenActions.redInjuryTime;

  const BoutScreenActionIntent.redUndo() : type = BoutScreenActions.redUndo;

  const BoutScreenActionIntent.blueOne() : type = BoutScreenActions.blueOne;

  const BoutScreenActionIntent.blueTwo() : type = BoutScreenActions.blueTwo;

  const BoutScreenActionIntent.blueThree() : type = BoutScreenActions.blueThree;

  const BoutScreenActionIntent.blueFour() : type = BoutScreenActions.blueFour;

  const BoutScreenActionIntent.bluePassivity() : type = BoutScreenActions.bluePassivity;

  const BoutScreenActionIntent.blueCaution() : type = BoutScreenActions.blueCaution;

  const BoutScreenActionIntent.blueDismissal() : type = BoutScreenActions.blueDismissal;

  const BoutScreenActionIntent.blueActivityTime() : type = BoutScreenActions.blueActivityTime;

  const BoutScreenActionIntent.blueInjuryTime() : type = BoutScreenActions.blueInjuryTime;

  const BoutScreenActionIntent.blueUndo() : type = BoutScreenActions.blueUndo;
  final BoutScreenActions type;
}

class BoutActionHandler extends StatelessWidget {
  final Widget child;
  final ObservableStopwatch stopwatch;
  final TeamMatch match;
  final List<Bout> bouts;
  final List<BoutAction> Function() getActions;
  final void Function(List<BoutAction> actions) setActions;
  final int boutIndex;
  final Function(BoutScreenActions action) doAction;

  const BoutActionHandler(
      {required this.child,
      required this.stopwatch,
      required this.match,
      required this.bouts,
      required this.getActions,
      required this.boutIndex,
      required this.doAction,
      required this.setActions,
      super.key});

  Future<void> handleIntent(BoutScreenActionIntent intent, {BuildContext? context}) async {
    await handleIntentStatic(intent, stopwatch, match, bouts, getActions, setActions, boutIndex, doAction,
        context: context);
  }

  static Future<void> handleIntentStatic(
      BoutScreenActionIntent intent,
      ObservableStopwatch stopwatch,
      TeamMatch match,
      List<Bout> bouts,
      List<BoutAction> Function() getActions,
      void Function(List<BoutAction> actions) setActions,
      int boutIndex,
      Function(BoutScreenActions action) doAction,
      {BuildContext? context}) async {
    final bout = bouts[boutIndex];
    switch (intent.type) {
      case BoutScreenActions.startStop:
        stopwatch.startStop();
        break;
      case BoutScreenActions.addOneSec:
        stopwatch.addDuration(const Duration(seconds: 1));
        break;
      case BoutScreenActions.rmOneSec:
        if (stopwatch.elapsed > const Duration(seconds: 1)) {
          stopwatch.addDuration(-const Duration(seconds: 1));
        } else {
          stopwatch.addDuration(-stopwatch.elapsed);
        } // Do not reset, as it will may stop the timer
        break;
      case BoutScreenActions.reset:
        stopwatch.reset();
        break;
      case BoutScreenActions.nextBout:
        if (context != null) {
          int index = boutIndex + 1;
          if (index < bouts.length) {
            context.pop();
            navigateToBoutScreen(context, match, bouts[index]);
          }
        }
        break;
      case BoutScreenActions.previousBout:
        if (context != null) {
          int index = boutIndex - 1;
          if (index >= 0) {
            context.pop();
            navigateToBoutScreen(context, match, bouts[index]);
          }
        }
        break;
      case BoutScreenActions.quit:
        if (context != null) context.pop();
        break;
      case BoutScreenActions.redOne:
        var action = BoutAction(
            bout: bout,
            role: BoutRole.red,
            duration: bout.duration,
            actionType: BoutActionType.points,
            pointCount: 1);
        action = action.copyWithId(await dataProvider.createOrUpdateSingle(action));
        setActions(getActions()..add(action));
        break;
      case BoutScreenActions.redTwo:
        var action = BoutAction(
            bout: bout,
            role: BoutRole.red,
            duration: bout.duration,
            actionType: BoutActionType.points,
            pointCount: 2);
        action = action.copyWithId(await dataProvider.createOrUpdateSingle(action));
        setActions(getActions()..add(action));
        break;
      case BoutScreenActions.redThree:
        var action = BoutAction(
            bout: bout,
            role: BoutRole.red,
            duration: bout.duration,
            actionType: BoutActionType.points,
            pointCount: 3);
        action = action.copyWithId(await dataProvider.createOrUpdateSingle(action));
        setActions(getActions()..add(action));
        break;
      case BoutScreenActions.redFour:
        var action = BoutAction(
          bout: bout,
          role: BoutRole.red,
          duration: bout.duration,
          actionType: BoutActionType.points,
          pointCount: 4,
        );
        action = action.copyWithId(await dataProvider.createOrUpdateSingle(action));
        setActions(getActions()..add(action));
        break;
      case BoutScreenActions.redPassivity:
        var action = BoutAction(
            bout: bout, role: BoutRole.red, duration: bout.duration, actionType: BoutActionType.passivity);
        action = action.copyWithId(await dataProvider.createOrUpdateSingle(action));
        setActions(getActions()..add(action));
        break;
      case BoutScreenActions.redCaution:
        var action = BoutAction(
            bout: bout, role: BoutRole.red, duration: bout.duration, actionType: BoutActionType.caution);
        action = action.copyWithId(await dataProvider.createOrUpdateSingle(action));
        setActions(getActions()..add(action));
        break;
      case BoutScreenActions.redDismissal:
        var action = BoutAction(
            bout: bout, role: BoutRole.red, duration: bout.duration, actionType: BoutActionType.dismissal);
        action = action.copyWithId(await dataProvider.createOrUpdateSingle(action));
        setActions(getActions()..add(action));
        break;
      case BoutScreenActions.redActivityTime:
        doAction(BoutScreenActions.redActivityTime);
        break;
      case BoutScreenActions.redInjuryTime:
        doAction(BoutScreenActions.redInjuryTime);
        break;
      case BoutScreenActions.redUndo:
        if (bout.r != null) {
          final actions = getActions();
          final rActions = actions.where((el) => el.role == BoutRole.red);
          if (rActions.isNotEmpty) {
            final action = rActions.last;
            setActions(actions..remove(action));
            dataProvider.deleteSingle<BoutAction>(action);
          }
        }
        break;
      case BoutScreenActions.blueOne:
        var action = BoutAction(
            bout: bout,
            role: BoutRole.blue,
            duration: bout.duration,
            actionType: BoutActionType.points,
            pointCount: 1);
        action = action.copyWithId(await dataProvider.createOrUpdateSingle(action));
        setActions(getActions()..add(action));
        break;
      case BoutScreenActions.blueTwo:
        var action = BoutAction(
            bout: bout,
            role: BoutRole.blue,
            duration: bout.duration,
            actionType: BoutActionType.points,
            pointCount: 2);
        action = action.copyWithId(await dataProvider.createOrUpdateSingle(action));
        setActions(getActions()..add(action));
        break;
      case BoutScreenActions.blueThree:
        var action = BoutAction(
            bout: bout,
            role: BoutRole.blue,
            duration: bout.duration,
            actionType: BoutActionType.points,
            pointCount: 3);
        action = action.copyWithId(await dataProvider.createOrUpdateSingle(action));
        setActions(getActions()..add(action));
        break;
      case BoutScreenActions.blueFour:
        var action = BoutAction(
            bout: bout,
            role: BoutRole.blue,
            duration: bout.duration,
            actionType: BoutActionType.points,
            pointCount: 4);
        action = action.copyWithId(await dataProvider.createOrUpdateSingle(action));
        setActions(getActions()..add(action));
        break;
      case BoutScreenActions.bluePassivity:
        var action = BoutAction(
            bout: bout, role: BoutRole.blue, duration: bout.duration, actionType: BoutActionType.passivity);
        action = action.copyWithId(await dataProvider.createOrUpdateSingle(action));
        setActions(getActions()..add(action));
        break;
      case BoutScreenActions.blueCaution:
        var action = BoutAction(
            bout: bout, role: BoutRole.blue, duration: bout.duration, actionType: BoutActionType.caution);
        action = action.copyWithId(await dataProvider.createOrUpdateSingle(action));
        setActions(getActions()..add(action));
        break;
      case BoutScreenActions.blueDismissal:
        var action = BoutAction(
            bout: bout, role: BoutRole.blue, duration: bout.duration, actionType: BoutActionType.dismissal);
        action = action.copyWithId(await dataProvider.createOrUpdateSingle(action));
        setActions(getActions()..add(action));
        break;
      case BoutScreenActions.blueUndo:
        if (bout.b != null) {
          final actions = getActions();
          final bActions = actions.where((el) => el.role == BoutRole.blue);
          if (bActions.isNotEmpty) {
            final action = bActions.last;
            setActions(actions..remove(action));
            dataProvider.deleteSingle<BoutAction>(action);
          }
        }
        break;
      case BoutScreenActions.blueActivityTime:
        doAction(BoutScreenActions.blueActivityTime);
        break;
      case BoutScreenActions.blueInjuryTime:
        doAction(BoutScreenActions.blueInjuryTime);
        break;
      case BoutScreenActions.undo:
        final actions = getActions();
        if (actions.isNotEmpty) {
          final action = actions.last;
          setActions(actions..remove(action));
          dataProvider.deleteSingle<BoutAction>(action);
        }
        break;
      case BoutScreenActions.horn:
        HornSound().play();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    const redOneIntent = BoutScreenActionIntent.redOne();
    const redTwoIntent = BoutScreenActionIntent.redTwo();
    const redThreeIntent = BoutScreenActionIntent.redThree();
    const redFourIntent = BoutScreenActionIntent.redFour();

    const blueOneIntent = BoutScreenActionIntent.blueOne();
    const blueTwoIntent = BoutScreenActionIntent.blueTwo();
    const blueThreeIntent = BoutScreenActionIntent.blueThree();
    const blueFourIntent = BoutScreenActionIntent.blueFour();
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.space): const BoutScreenActionIntent.startStop(),
        LogicalKeySet(LogicalKeyboardKey.arrowUp): const BoutScreenActionIntent.addOneSec(),
        LogicalKeySet(LogicalKeyboardKey.arrowDown): const BoutScreenActionIntent.rmOneSec(),
        LogicalKeySet(LogicalKeyboardKey.backspace): const BoutScreenActionIntent.undo(),
        LogicalKeySet(LogicalKeyboardKey.arrowRight): const BoutScreenActionIntent.nextBout(),
        LogicalKeySet(LogicalKeyboardKey.arrowLeft): const BoutScreenActionIntent.previousBout(),
        LogicalKeySet(LogicalKeyboardKey.escape): const BoutScreenActionIntent.quit(),
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
          BoutScreenActionIntent: CallbackAction<BoutScreenActionIntent>(
            onInvoke: (BoutScreenActionIntent intent) => handleIntent(intent, context: context),
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
