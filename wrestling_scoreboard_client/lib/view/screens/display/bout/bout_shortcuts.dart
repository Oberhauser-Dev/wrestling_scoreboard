import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/services/audio/audio.dart';
import 'package:wrestling_scoreboard_client/services/network/data_manager.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
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

  Future<void> handle(
    DataManager dataManager,
    ObservableStopwatch stopwatch,
    List<Bout> bouts,
    Future<List<BoutAction>> Function() getActions,
    int boutIndex,
    Function(BoutScreenActions action) doAction, {
    BuildContext? context,
    required void Function(BuildContext context, int boutIndex) navigateToBoutByIndex,
  }) async {
    final bout = bouts[boutIndex];
    switch (type) {
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
            navigateToBoutByIndex(context, index);
          }
        }
        break;
      case BoutScreenActions.previousBout:
        if (context != null) {
          int index = boutIndex - 1;
          if (index >= 0) {
            navigateToBoutByIndex(context, index);
          }
        }
        break;
      case BoutScreenActions.quit:
        if (context != null) context.pop();
        break;
      case BoutScreenActions.redOne:
        var action = BoutAction(
            bout: bout, role: BoutRole.red, duration: bout.duration, actionType: BoutActionType.points, pointCount: 1);
        await dataManager.createOrUpdateSingle(action);
        break;
      case BoutScreenActions.redTwo:
        var action = BoutAction(
            bout: bout, role: BoutRole.red, duration: bout.duration, actionType: BoutActionType.points, pointCount: 2);
        await dataManager.createOrUpdateSingle(action);
        break;
      case BoutScreenActions.redThree:
        var action = BoutAction(
            bout: bout, role: BoutRole.red, duration: bout.duration, actionType: BoutActionType.points, pointCount: 3);
        await dataManager.createOrUpdateSingle(action);
        break;
      case BoutScreenActions.redFour:
        var action = BoutAction(
          bout: bout,
          role: BoutRole.red,
          duration: bout.duration,
          actionType: BoutActionType.points,
          pointCount: 4,
        );
        await dataManager.createOrUpdateSingle(action);
        break;
      case BoutScreenActions.redPassivity:
        var action =
            BoutAction(bout: bout, role: BoutRole.red, duration: bout.duration, actionType: BoutActionType.passivity);
        await dataManager.createOrUpdateSingle(action);
        break;
      case BoutScreenActions.redCaution:
        var action =
            BoutAction(bout: bout, role: BoutRole.red, duration: bout.duration, actionType: BoutActionType.caution);
        await dataManager.createOrUpdateSingle(action);
        break;
      case BoutScreenActions.redDismissal:
        var action =
            BoutAction(bout: bout, role: BoutRole.red, duration: bout.duration, actionType: BoutActionType.dismissal);
        await dataManager.createOrUpdateSingle(action);
        break;
      case BoutScreenActions.redActivityTime:
        doAction(BoutScreenActions.redActivityTime);
        break;
      case BoutScreenActions.redInjuryTime:
        doAction(BoutScreenActions.redInjuryTime);
        break;
      case BoutScreenActions.redUndo:
        if (bout.r != null) {
          final actions = await getActions();
          final rActions = actions.where((el) => el.role == BoutRole.red);
          if (rActions.isNotEmpty) {
            final action = rActions.last;
            dataManager.deleteSingle<BoutAction>(action);
          }
        }
        break;
      case BoutScreenActions.blueOne:
        var action = BoutAction(
            bout: bout, role: BoutRole.blue, duration: bout.duration, actionType: BoutActionType.points, pointCount: 1);
        await dataManager.createOrUpdateSingle(action);
        break;
      case BoutScreenActions.blueTwo:
        var action = BoutAction(
            bout: bout, role: BoutRole.blue, duration: bout.duration, actionType: BoutActionType.points, pointCount: 2);
        await dataManager.createOrUpdateSingle(action);
        break;
      case BoutScreenActions.blueThree:
        var action = BoutAction(
            bout: bout, role: BoutRole.blue, duration: bout.duration, actionType: BoutActionType.points, pointCount: 3);
        await dataManager.createOrUpdateSingle(action);
        break;
      case BoutScreenActions.blueFour:
        var action = BoutAction(
            bout: bout, role: BoutRole.blue, duration: bout.duration, actionType: BoutActionType.points, pointCount: 4);
        await dataManager.createOrUpdateSingle(action);
        break;
      case BoutScreenActions.bluePassivity:
        var action =
            BoutAction(bout: bout, role: BoutRole.blue, duration: bout.duration, actionType: BoutActionType.passivity);
        await dataManager.createOrUpdateSingle(action);
        break;
      case BoutScreenActions.blueCaution:
        var action =
            BoutAction(bout: bout, role: BoutRole.blue, duration: bout.duration, actionType: BoutActionType.caution);
        await dataManager.createOrUpdateSingle(action);
        break;
      case BoutScreenActions.blueDismissal:
        var action =
            BoutAction(bout: bout, role: BoutRole.blue, duration: bout.duration, actionType: BoutActionType.dismissal);
        await dataManager.createOrUpdateSingle(action);
        break;
      case BoutScreenActions.blueUndo:
        if (bout.b != null) {
          final actions = await getActions();
          final bActions = actions.where((el) => el.role == BoutRole.blue);
          if (bActions.isNotEmpty) {
            final action = bActions.last;
            dataManager.deleteSingle<BoutAction>(action);
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
        final actions = await getActions();
        if (actions.isNotEmpty) {
          final action = actions.last;
          dataManager.deleteSingle<BoutAction>(action);
        }
        break;
      case BoutScreenActions.horn:
        HornSound.play();
        break;
    }
  }
}

class BoutActionHandler extends ConsumerWidget {
  final Widget child;
  final ObservableStopwatch stopwatch;
  final List<Bout> bouts;
  final Future<List<BoutAction>> Function() getActions;
  final int boutIndex;
  final Function(BoutScreenActions action) doAction;
  final void Function(BuildContext context, int boutIndex) navigateToBoutByIndex;

  const BoutActionHandler(
      {required this.child,
      required this.stopwatch,
      required this.bouts,
      required this.getActions,
      required this.boutIndex,
      required this.doAction,
      super.key,
      required this.navigateToBoutByIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> handleIntent(BoutScreenActionIntent intent, {BuildContext? context}) async {
      final dataManager = await ref.read(dataManagerNotifierProvider);
      if (context != null && context.mounted) {
        try {
          await intent.handle(dataManager, stopwatch, bouts, getActions, boutIndex, doAction,
              context: context, navigateToBoutByIndex: navigateToBoutByIndex);
        } on Exception catch (e) {
          if (context.mounted) {
            await showExceptionDialog(context: context, exception: e);
          }
        }
      }
    }

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
        LogicalKeySet(LogicalKeyboardKey.keyQ, LogicalKeyboardKey.control): const BoutScreenActionIntent.quit(),
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
