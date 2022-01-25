import 'dart:async';

import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wrestling_scoreboard/util/audio/audio.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';

import 'fight_screen.dart';

enum FightScreenActions {
  StartStop,
  Reset,
  AddOneSec,
  RmOneSec,
  Undo,
  NextFight,
  PreviousFight,
  Horn,
  Quit,
  RedOne,
  RedTwo,
  RedThree,
  RedFour,
  RedPassivity,
  RedCaution,
  RedDismissal,
  RedActivityTime,
  RedInjuryTime,
  RedUndo,
  BlueOne,
  BlueTwo,
  BlueThree,
  BlueFour,
  BluePassivity,
  BlueCaution,
  BlueDismissal,
  BlueActivityTime,
  BlueInjuryTime,
  BlueUndo,
}

class FightScreenActionIntent extends Intent {
  const FightScreenActionIntent({required this.type});

  const FightScreenActionIntent.StartStop() : type = FightScreenActions.StartStop;

  const FightScreenActionIntent.Reset() : type = FightScreenActions.Reset;

  const FightScreenActionIntent.AddOneSec() : type = FightScreenActions.AddOneSec;

  const FightScreenActionIntent.RmOneSec() : type = FightScreenActions.RmOneSec;

  const FightScreenActionIntent.Undo() : type = FightScreenActions.Undo;

  const FightScreenActionIntent.NextFight() : type = FightScreenActions.NextFight;

  const FightScreenActionIntent.PreviousFight() : type = FightScreenActions.PreviousFight;

  const FightScreenActionIntent.Horn() : type = FightScreenActions.Horn;

  const FightScreenActionIntent.Quit() : type = FightScreenActions.Quit;

  const FightScreenActionIntent.RedOne() : type = FightScreenActions.RedOne;

  const FightScreenActionIntent.RedTwo() : type = FightScreenActions.RedTwo;

  const FightScreenActionIntent.RedThree() : type = FightScreenActions.RedThree;

  const FightScreenActionIntent.RedFour() : type = FightScreenActions.RedFour;

  const FightScreenActionIntent.RedPassivity() : type = FightScreenActions.RedPassivity;

  const FightScreenActionIntent.RedCaution() : type = FightScreenActions.RedCaution;

  const FightScreenActionIntent.RedDismissal() : type = FightScreenActions.RedDismissal;

  const FightScreenActionIntent.RedActivityTime() : type = FightScreenActions.RedActivityTime;

  const FightScreenActionIntent.RedInjuryTime() : type = FightScreenActions.RedInjuryTime;

  const FightScreenActionIntent.RedUndo() : type = FightScreenActions.RedUndo;

  const FightScreenActionIntent.BlueOne() : type = FightScreenActions.BlueOne;

  const FightScreenActionIntent.BlueTwo() : type = FightScreenActions.BlueTwo;

  const FightScreenActionIntent.BlueThree() : type = FightScreenActions.BlueThree;

  const FightScreenActionIntent.BlueFour() : type = FightScreenActions.BlueFour;

  const FightScreenActionIntent.BluePassivity() : type = FightScreenActions.BluePassivity;

  const FightScreenActionIntent.BlueCaution() : type = FightScreenActions.BlueCaution;

  const FightScreenActionIntent.BlueDismissal() : type = FightScreenActions.BlueDismissal;

  const FightScreenActionIntent.BlueActivityTime() : type = FightScreenActions.BlueActivityTime;

  const FightScreenActionIntent.BlueInjuryTime() : type = FightScreenActions.BlueInjuryTime;

  const FightScreenActionIntent.BlueUndo() : type = FightScreenActions.BlueUndo;
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
      case FightScreenActions.StartStop:
        stopwatch.startStop();
        break;
      case FightScreenActions.AddOneSec:
        stopwatch.addDuration(const Duration(seconds: 1));
        break;
      case FightScreenActions.RmOneSec:
        if (stopwatch.elapsed > const Duration(seconds: 1)) {
          stopwatch.addDuration(-const Duration(seconds: 1));
        } else {
          stopwatch.addDuration(-stopwatch.elapsed);
        } // Do not reset, as it will may stop the timer
        break;
      case FightScreenActions.Reset:
        stopwatch.reset();
        break;
      case FightScreenActions.NextFight:
        if (context != null) {
          int index = fightIndex + 1;
          if (index < fights.length) {
            Navigator.pop(context);
            navigateToFightScreen(context, match, fights, index);
          }
        }
        break;
      case FightScreenActions.PreviousFight:
        if (context != null) {
          int index = fightIndex - 1;
          if (index >= 0) {
            Navigator.pop(context);
            navigateToFightScreen(context, match, fights, index);
          }
        }
        break;
      case FightScreenActions.Quit:
        if (context != null) Navigator.pop(context);
        break;
      case FightScreenActions.RedOne:
        final action = FightAction(
            fight: fight,
            role: FightRole.red,
            duration: fight.duration,
            actionType: FightActionType.points,
            pointCount: 1);
        setActions(getActions()..add(action));
        action.id = await dataProvider.createOrUpdateSingle(action);
        break;
      case FightScreenActions.RedTwo:
        final action = FightAction(
            fight: fight,
            role: FightRole.red,
            duration: fight.duration,
            actionType: FightActionType.points,
            pointCount: 2);
        setActions(getActions()..add(action));
        action.id = await dataProvider.createOrUpdateSingle(action);
        break;
      case FightScreenActions.RedThree:
        final action = FightAction(
            fight: fight,
            role: FightRole.red,
            duration: fight.duration,
            actionType: FightActionType.points,
            pointCount: 3);
        setActions(getActions()..add(action));
        action.id = await dataProvider.createOrUpdateSingle(action);
        break;
      case FightScreenActions.RedFour:
        final action = FightAction(
            fight: fight,
            role: FightRole.red,
            duration: fight.duration,
            actionType: FightActionType.points,
            pointCount: 4);
        setActions(getActions()..add(action));
        action.id = await dataProvider.createOrUpdateSingle(action);
        break;
      case FightScreenActions.RedPassivity:
        final action = FightAction(
            fight: fight, role: FightRole.red, duration: fight.duration, actionType: FightActionType.passivity);
        setActions(getActions()..add(action));
        action.id = await dataProvider.createOrUpdateSingle(action);
        break;
      case FightScreenActions.RedCaution:
        final action = FightAction(
            fight: fight, role: FightRole.red, duration: fight.duration, actionType: FightActionType.caution);
        setActions(getActions()..add(action));
        action.id = await dataProvider.createOrUpdateSingle(action);
        break;
      case FightScreenActions.RedDismissal:
        final action = FightAction(
            fight: fight, role: FightRole.red, duration: fight.duration, actionType: FightActionType.dismissal);
        setActions(getActions()..add(action));
        action.id = await dataProvider.createOrUpdateSingle(action);
        break;
      case FightScreenActions.RedActivityTime:
        doAction(FightScreenActions.RedActivityTime);
        break;
      case FightScreenActions.RedInjuryTime:
        doAction(FightScreenActions.RedInjuryTime);
        break;
      case FightScreenActions.RedUndo:
        if (fight.r != null) {
          final actions = getActions();
          final rActions = actions.where((el) => el.role == FightRole.red);
          if (rActions.isNotEmpty) {
            final action = rActions.last;
            setActions(actions..remove(action));
            dataProvider.deleteSingle(action);
          }
        }
        break;
      case FightScreenActions.BlueOne:
        final action = FightAction(
            fight: fight,
            role: FightRole.blue,
            duration: fight.duration,
            actionType: FightActionType.points,
            pointCount: 1);
        setActions(getActions()..add(action));
        action.id = await dataProvider.createOrUpdateSingle(action);
        break;
      case FightScreenActions.BlueTwo:
        final action = FightAction(
            fight: fight,
            role: FightRole.blue,
            duration: fight.duration,
            actionType: FightActionType.points,
            pointCount: 2);
        setActions(getActions()..add(action));
        action.id = await dataProvider.createOrUpdateSingle(action);
        break;
      case FightScreenActions.BlueThree:
        final action = FightAction(
            fight: fight,
            role: FightRole.blue,
            duration: fight.duration,
            actionType: FightActionType.points,
            pointCount: 3);
        setActions(getActions()..add(action));
        action.id = await dataProvider.createOrUpdateSingle(action);
        break;
      case FightScreenActions.BlueFour:
        final action = FightAction(
            fight: fight,
            role: FightRole.blue,
            duration: fight.duration,
            actionType: FightActionType.points,
            pointCount: 4);
        setActions(getActions()..add(action));
        action.id = await dataProvider.createOrUpdateSingle(action);
        break;
      case FightScreenActions.BluePassivity:
        final action = FightAction(
            fight: fight, role: FightRole.blue, duration: fight.duration, actionType: FightActionType.passivity);
        setActions(getActions()..add(action));
        action.id = await dataProvider.createOrUpdateSingle(action);
        break;
      case FightScreenActions.BlueCaution:
        final action = FightAction(
            fight: fight, role: FightRole.blue, duration: fight.duration, actionType: FightActionType.caution);
        setActions(getActions()..add(action));
        action.id = await dataProvider.createOrUpdateSingle(action);
        break;
      case FightScreenActions.BlueDismissal:
        final action = FightAction(
            fight: fight, role: FightRole.blue, duration: fight.duration, actionType: FightActionType.dismissal);
        setActions(getActions()..add(action));
        action.id = await dataProvider.createOrUpdateSingle(action);
        break;
      case FightScreenActions.BlueUndo:
        if (fight.b != null) {
          final actions = getActions();
          final bActions = actions.where((el) => el.role == FightRole.blue);
          if (bActions.isNotEmpty) {
            final action = bActions.last;
            setActions(actions..remove(action));
            dataProvider.deleteSingle(action);
          }
        }
        break;
      case FightScreenActions.BlueActivityTime:
        doAction(FightScreenActions.BlueActivityTime);
        break;
      case FightScreenActions.BlueInjuryTime:
        doAction(FightScreenActions.BlueInjuryTime);
        break;
      case FightScreenActions.Undo:
        final actions = getActions();
        if (actions.isNotEmpty) {
          final action = actions.last;
          setActions(actions..remove(action));
          dataProvider.deleteSingle(action);
        }
        break;
      case FightScreenActions.Horn:
        HornSound().play();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    const redOneIntent = FightScreenActionIntent.RedOne();
    const redTwoIntent = FightScreenActionIntent.RedTwo();
    const redThreeIntent = FightScreenActionIntent.RedThree();
    const redFourIntent = FightScreenActionIntent.RedFour();

    const blueOneIntent = FightScreenActionIntent.BlueOne();
    const blueTwoIntent = FightScreenActionIntent.BlueTwo();
    const blueThreeIntent = FightScreenActionIntent.BlueThree();
    const blueFourIntent = FightScreenActionIntent.BlueFour();
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.space): const FightScreenActionIntent.StartStop(),
        LogicalKeySet(LogicalKeyboardKey.arrowUp): const FightScreenActionIntent.AddOneSec(),
        LogicalKeySet(LogicalKeyboardKey.arrowDown): const FightScreenActionIntent.RmOneSec(),
        LogicalKeySet(LogicalKeyboardKey.backspace): const FightScreenActionIntent.Undo(),
        LogicalKeySet(LogicalKeyboardKey.arrowRight): const FightScreenActionIntent.NextFight(),
        LogicalKeySet(LogicalKeyboardKey.arrowLeft): const FightScreenActionIntent.PreviousFight(),
        LogicalKeySet(LogicalKeyboardKey.escape): const FightScreenActionIntent.Quit(),
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
