import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/ui/fight/fight_display.dart';
import 'package:wrestling_scoreboard_client/util/audio/audio.dart';
import 'package:wrestling_scoreboard_client/util/network/data_provider.dart';
import 'package:wrestling_scoreboard_common/common.dart';

enum FightScreenActions {
  startStop,
  reset,
  addOneSec,
  rmOneSec,
  undo,
  nextFight,
  previousFight,
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

class FightScreenActionIntent extends Intent {
  const FightScreenActionIntent({required this.type});

  const FightScreenActionIntent.startStop() : type = FightScreenActions.startStop;

  const FightScreenActionIntent.reset() : type = FightScreenActions.reset;

  const FightScreenActionIntent.addOneSec() : type = FightScreenActions.addOneSec;

  const FightScreenActionIntent.rmOneSec() : type = FightScreenActions.rmOneSec;

  const FightScreenActionIntent.undo() : type = FightScreenActions.undo;

  const FightScreenActionIntent.nextFight() : type = FightScreenActions.nextFight;

  const FightScreenActionIntent.previousFight() : type = FightScreenActions.previousFight;

  const FightScreenActionIntent.horn() : type = FightScreenActions.horn;

  const FightScreenActionIntent.quit() : type = FightScreenActions.quit;

  const FightScreenActionIntent.redOne() : type = FightScreenActions.redOne;

  const FightScreenActionIntent.redTwo() : type = FightScreenActions.redTwo;

  const FightScreenActionIntent.redThree() : type = FightScreenActions.redThree;

  const FightScreenActionIntent.redFour() : type = FightScreenActions.redFour;

  const FightScreenActionIntent.redPassivity() : type = FightScreenActions.redPassivity;

  const FightScreenActionIntent.redCaution() : type = FightScreenActions.redCaution;

  const FightScreenActionIntent.redDismissal() : type = FightScreenActions.redDismissal;

  const FightScreenActionIntent.redActivityTime() : type = FightScreenActions.redActivityTime;

  const FightScreenActionIntent.redInjuryTime() : type = FightScreenActions.redInjuryTime;

  const FightScreenActionIntent.redUndo() : type = FightScreenActions.redUndo;

  const FightScreenActionIntent.blueOne() : type = FightScreenActions.blueOne;

  const FightScreenActionIntent.blueTwo() : type = FightScreenActions.blueTwo;

  const FightScreenActionIntent.blueThree() : type = FightScreenActions.blueThree;

  const FightScreenActionIntent.blueFour() : type = FightScreenActions.blueFour;

  const FightScreenActionIntent.bluePassivity() : type = FightScreenActions.bluePassivity;

  const FightScreenActionIntent.blueCaution() : type = FightScreenActions.blueCaution;

  const FightScreenActionIntent.blueDismissal() : type = FightScreenActions.blueDismissal;

  const FightScreenActionIntent.blueActivityTime() : type = FightScreenActions.blueActivityTime;

  const FightScreenActionIntent.blueInjuryTime() : type = FightScreenActions.blueInjuryTime;

  const FightScreenActionIntent.blueUndo() : type = FightScreenActions.blueUndo;
  final FightScreenActions type;
}

class FightActionHandler extends StatelessWidget {
  final Widget child;
  final ObservableStopwatch stopwatch;
  final TeamMatch match;
  final List<Fight> fights;
  final List<FightAction> Function() getActions;
  final void Function(List<FightAction> actions) setActions;
  final int fightIndex;
  final Function(FightScreenActions action) doAction;

  const FightActionHandler(
      {required this.child,
      required this.stopwatch,
      required this.match,
      required this.fights,
      required this.getActions,
      required this.fightIndex,
      required this.doAction,
      required this.setActions,
      Key? key})
      : super(key: key);

  Future<void> handleIntent(FightScreenActionIntent intent, {BuildContext? context}) async {
    await handleIntentStatic(intent, stopwatch, match, fights, getActions, setActions, fightIndex, doAction,
        context: context);
  }

  static Future<void> handleIntentStatic(
      FightScreenActionIntent intent,
      ObservableStopwatch stopwatch,
      TeamMatch match,
      List<Fight> fights,
      List<FightAction> Function() getActions,
      void Function(List<FightAction> actions) setActions,
      int fightIndex,
      Function(FightScreenActions action) doAction,
      {BuildContext? context}) async {
    final fight = fights[fightIndex];
    switch (intent.type) {
      case FightScreenActions.startStop:
        stopwatch.startStop();
        break;
      case FightScreenActions.addOneSec:
        stopwatch.addDuration(const Duration(seconds: 1));
        break;
      case FightScreenActions.rmOneSec:
        if (stopwatch.elapsed > const Duration(seconds: 1)) {
          stopwatch.addDuration(-const Duration(seconds: 1));
        } else {
          stopwatch.addDuration(-stopwatch.elapsed);
        } // Do not reset, as it will may stop the timer
        break;
      case FightScreenActions.reset:
        stopwatch.reset();
        break;
      case FightScreenActions.nextFight:
        if (context != null) {
          int index = fightIndex + 1;
          if (index < fights.length) {
            context.pop();
            navigateToFightScreen(context, match, fights[index]);
          }
        }
        break;
      case FightScreenActions.previousFight:
        if (context != null) {
          int index = fightIndex - 1;
          if (index >= 0) {
            context.pop();
            navigateToFightScreen(context, match, fights[index]);
          }
        }
        break;
      case FightScreenActions.quit:
        if (context != null) context.pop();
        break;
      case FightScreenActions.redOne:
        var action = FightAction(
            fight: fight,
            role: FightRole.red,
            duration: fight.duration,
            actionType: FightActionType.points,
            pointCount: 1);
        action = action.copyWithId(await dataProvider.createOrUpdateSingle(action));
        setActions(getActions()..add(action));
        break;
      case FightScreenActions.redTwo:
        var action = FightAction(
            fight: fight,
            role: FightRole.red,
            duration: fight.duration,
            actionType: FightActionType.points,
            pointCount: 2);
        action = action.copyWithId(await dataProvider.createOrUpdateSingle(action));
        setActions(getActions()..add(action));
        break;
      case FightScreenActions.redThree:
        var action = FightAction(
            fight: fight,
            role: FightRole.red,
            duration: fight.duration,
            actionType: FightActionType.points,
            pointCount: 3);
        action = action.copyWithId(await dataProvider.createOrUpdateSingle(action));
        setActions(getActions()..add(action));
        break;
      case FightScreenActions.redFour:
        var action = FightAction(
          fight: fight,
          role: FightRole.red,
          duration: fight.duration,
          actionType: FightActionType.points,
          pointCount: 4,
        );
        action = action.copyWithId(await dataProvider.createOrUpdateSingle(action));
        setActions(getActions()..add(action));
        break;
      case FightScreenActions.redPassivity:
        var action = FightAction(
            fight: fight, role: FightRole.red, duration: fight.duration, actionType: FightActionType.passivity);
        action = action.copyWithId(await dataProvider.createOrUpdateSingle(action));
        setActions(getActions()..add(action));
        break;
      case FightScreenActions.redCaution:
        var action = FightAction(
            fight: fight, role: FightRole.red, duration: fight.duration, actionType: FightActionType.caution);
        action = action.copyWithId(await dataProvider.createOrUpdateSingle(action));
        setActions(getActions()..add(action));
        break;
      case FightScreenActions.redDismissal:
        var action = FightAction(
            fight: fight, role: FightRole.red, duration: fight.duration, actionType: FightActionType.dismissal);
        action = action.copyWithId(await dataProvider.createOrUpdateSingle(action));
        setActions(getActions()..add(action));
        break;
      case FightScreenActions.redActivityTime:
        doAction(FightScreenActions.redActivityTime);
        break;
      case FightScreenActions.redInjuryTime:
        doAction(FightScreenActions.redInjuryTime);
        break;
      case FightScreenActions.redUndo:
        if (fight.r != null) {
          final actions = getActions();
          final rActions = actions.where((el) => el.role == FightRole.red);
          if (rActions.isNotEmpty) {
            final action = rActions.last;
            setActions(actions..remove(action));
            dataProvider.deleteSingle<FightAction>(action);
          }
        }
        break;
      case FightScreenActions.blueOne:
        var action = FightAction(
            fight: fight,
            role: FightRole.blue,
            duration: fight.duration,
            actionType: FightActionType.points,
            pointCount: 1);
        action = action.copyWithId(await dataProvider.createOrUpdateSingle(action));
        setActions(getActions()..add(action));
        break;
      case FightScreenActions.blueTwo:
        var action = FightAction(
            fight: fight,
            role: FightRole.blue,
            duration: fight.duration,
            actionType: FightActionType.points,
            pointCount: 2);
        action = action.copyWithId(await dataProvider.createOrUpdateSingle(action));
        setActions(getActions()..add(action));
        break;
      case FightScreenActions.blueThree:
        var action = FightAction(
            fight: fight,
            role: FightRole.blue,
            duration: fight.duration,
            actionType: FightActionType.points,
            pointCount: 3);
        action = action.copyWithId(await dataProvider.createOrUpdateSingle(action));
        setActions(getActions()..add(action));
        break;
      case FightScreenActions.blueFour:
        var action = FightAction(
            fight: fight,
            role: FightRole.blue,
            duration: fight.duration,
            actionType: FightActionType.points,
            pointCount: 4);
        action = action.copyWithId(await dataProvider.createOrUpdateSingle(action));
        setActions(getActions()..add(action));
        break;
      case FightScreenActions.bluePassivity:
        var action = FightAction(
            fight: fight, role: FightRole.blue, duration: fight.duration, actionType: FightActionType.passivity);
        action = action.copyWithId(await dataProvider.createOrUpdateSingle(action));
        setActions(getActions()..add(action));
        break;
      case FightScreenActions.blueCaution:
        var action = FightAction(
            fight: fight, role: FightRole.blue, duration: fight.duration, actionType: FightActionType.caution);
        action = action.copyWithId(await dataProvider.createOrUpdateSingle(action));
        setActions(getActions()..add(action));
        break;
      case FightScreenActions.blueDismissal:
        var action = FightAction(
            fight: fight, role: FightRole.blue, duration: fight.duration, actionType: FightActionType.dismissal);
        action = action.copyWithId(await dataProvider.createOrUpdateSingle(action));
        setActions(getActions()..add(action));
        break;
      case FightScreenActions.blueUndo:
        if (fight.b != null) {
          final actions = getActions();
          final bActions = actions.where((el) => el.role == FightRole.blue);
          if (bActions.isNotEmpty) {
            final action = bActions.last;
            setActions(actions..remove(action));
            dataProvider.deleteSingle<FightAction>(action);
          }
        }
        break;
      case FightScreenActions.blueActivityTime:
        doAction(FightScreenActions.blueActivityTime);
        break;
      case FightScreenActions.blueInjuryTime:
        doAction(FightScreenActions.blueInjuryTime);
        break;
      case FightScreenActions.undo:
        final actions = getActions();
        if (actions.isNotEmpty) {
          final action = actions.last;
          setActions(actions..remove(action));
          dataProvider.deleteSingle<FightAction>(action);
        }
        break;
      case FightScreenActions.horn:
        HornSound().play();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    const redOneIntent = FightScreenActionIntent.redOne();
    const redTwoIntent = FightScreenActionIntent.redTwo();
    const redThreeIntent = FightScreenActionIntent.redThree();
    const redFourIntent = FightScreenActionIntent.redFour();

    const blueOneIntent = FightScreenActionIntent.blueOne();
    const blueTwoIntent = FightScreenActionIntent.blueTwo();
    const blueThreeIntent = FightScreenActionIntent.blueThree();
    const blueFourIntent = FightScreenActionIntent.blueFour();
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.space): const FightScreenActionIntent.startStop(),
        LogicalKeySet(LogicalKeyboardKey.arrowUp): const FightScreenActionIntent.addOneSec(),
        LogicalKeySet(LogicalKeyboardKey.arrowDown): const FightScreenActionIntent.rmOneSec(),
        LogicalKeySet(LogicalKeyboardKey.backspace): const FightScreenActionIntent.undo(),
        LogicalKeySet(LogicalKeyboardKey.arrowRight): const FightScreenActionIntent.nextFight(),
        LogicalKeySet(LogicalKeyboardKey.arrowLeft): const FightScreenActionIntent.previousFight(),
        LogicalKeySet(LogicalKeyboardKey.escape): const FightScreenActionIntent.quit(),
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
            onInvoke: (FightScreenActionIntent intent) => handleIntent(intent, context: context),
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
