import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
  redFive,
  redVerbal,
  redPassivity,
  redCaution,
  redDismissal,
  redActivityTime,
  redInjuryTime,
  redBleedingInjuryTime,
  redUndo,
  blueOne,
  blueTwo,
  blueThree,
  blueFour,
  blueFive,
  blueVerbal,
  bluePassivity,
  blueCaution,
  blueDismissal,
  blueActivityTime,
  blueInjuryTime,
  blueBleedingInjuryTime,
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

  const BoutScreenActionIntent.redFive() : type = BoutScreenActions.redFive;

  const BoutScreenActionIntent.redVerbal() : type = BoutScreenActions.redVerbal;

  const BoutScreenActionIntent.redPassivity() : type = BoutScreenActions.redPassivity;

  const BoutScreenActionIntent.redCaution() : type = BoutScreenActions.redCaution;

  const BoutScreenActionIntent.redDismissal() : type = BoutScreenActions.redDismissal;

  const BoutScreenActionIntent.redActivityTime() : type = BoutScreenActions.redActivityTime;

  const BoutScreenActionIntent.redInjuryTime() : type = BoutScreenActions.redInjuryTime;

  const BoutScreenActionIntent.redBleedingInjuryTime() : type = BoutScreenActions.redBleedingInjuryTime;

  const BoutScreenActionIntent.redUndo() : type = BoutScreenActions.redUndo;

  const BoutScreenActionIntent.blueOne() : type = BoutScreenActions.blueOne;

  const BoutScreenActionIntent.blueTwo() : type = BoutScreenActions.blueTwo;

  const BoutScreenActionIntent.blueThree() : type = BoutScreenActions.blueThree;

  const BoutScreenActionIntent.blueFour() : type = BoutScreenActions.blueFour;

  const BoutScreenActionIntent.blueFive() : type = BoutScreenActions.blueFive;

  const BoutScreenActionIntent.blueVerbal() : type = BoutScreenActions.blueVerbal;

  const BoutScreenActionIntent.bluePassivity() : type = BoutScreenActions.bluePassivity;

  const BoutScreenActionIntent.blueCaution() : type = BoutScreenActions.blueCaution;

  const BoutScreenActionIntent.blueDismissal() : type = BoutScreenActions.blueDismissal;

  const BoutScreenActionIntent.blueActivityTime() : type = BoutScreenActions.blueActivityTime;

  const BoutScreenActionIntent.blueInjuryTime() : type = BoutScreenActions.blueInjuryTime;

  const BoutScreenActionIntent.blueBleedingInjuryTime() : type = BoutScreenActions.blueBleedingInjuryTime;

  const BoutScreenActionIntent.blueUndo() : type = BoutScreenActions.blueUndo;
  final BoutScreenActions type;

  Future<void> handle(
    ObservableStopwatch stopwatch,
    List<Bout> bouts,
    Future<List<BoutAction>> Function() getActions,
    int boutIndex,
    Function(BoutScreenActions action) doAction, {
    BuildContext? context,
    required void Function(BuildContext context, int boutIndex) navigateToBoutByIndex,
    required Future<void> Function(BoutAction action) createOrUpdateAction,
    required Future<void> Function(BoutAction action) deleteAction,
  }) async {
    final bout = bouts[boutIndex];
    switch (type) {
      case BoutScreenActions.startStop:
        stopwatch.startStop();
        break;
      case BoutScreenActions.addOneSec:
        stopwatch.add(const Duration(seconds: 1));
        break;
      case BoutScreenActions.rmOneSec:
        if (stopwatch.elapsed > const Duration(seconds: 1)) {
          stopwatch.add(-const Duration(seconds: 1));
        } else {
          stopwatch.add(-stopwatch.elapsed);
        } // Do not reset, as it will may stop the timer
        break;
      case BoutScreenActions.reset:
        stopwatch.reset();
        break;
      case BoutScreenActions.nextBout:
        if (context != null) {
          final int index = boutIndex + 1;
          if (index < bouts.length) {
            navigateToBoutByIndex(context, index);
          }
        }
        break;
      case BoutScreenActions.previousBout:
        if (context != null) {
          final int index = boutIndex - 1;
          if (index >= 0) {
            navigateToBoutByIndex(context, index);
          }
        }
        break;
      case BoutScreenActions.quit:
        if (context != null) context.pop();
        break;
      case BoutScreenActions.redOne:
        // NOTE: Do not used bout.duration as time, as it is not up to date.
        final action = BoutAction(
          bout: bout,
          role: BoutRole.red,
          duration: stopwatch.elapsed,
          actionType: BoutActionType.points,
          pointCount: 1,
        );
        await createOrUpdateAction(action);
        break;
      case BoutScreenActions.redTwo:
        final action = BoutAction(
          bout: bout,
          role: BoutRole.red,
          duration: stopwatch.elapsed,
          actionType: BoutActionType.points,
          pointCount: 2,
        );
        await createOrUpdateAction(action);
        break;
      case BoutScreenActions.redThree:
        final action = BoutAction(
          bout: bout,
          role: BoutRole.red,
          duration: stopwatch.elapsed,
          actionType: BoutActionType.points,
          pointCount: 3,
        );
        await createOrUpdateAction(action);
        break;
      case BoutScreenActions.redFour:
        final action = BoutAction(
          bout: bout,
          role: BoutRole.red,
          duration: stopwatch.elapsed,
          actionType: BoutActionType.points,
          pointCount: 4,
        );
        await createOrUpdateAction(action);
        break;
      case BoutScreenActions.redFive:
        final action = BoutAction(
          bout: bout,
          role: BoutRole.red,
          duration: stopwatch.elapsed,
          actionType: BoutActionType.points,
          pointCount: 5,
        );
        await createOrUpdateAction(action);
        break;
      case BoutScreenActions.redVerbal:
        final action = BoutAction(
          bout: bout,
          role: BoutRole.red,
          duration: stopwatch.elapsed,
          actionType: BoutActionType.verbal,
        );
        await createOrUpdateAction(action);
        break;
      case BoutScreenActions.redPassivity:
        final action = BoutAction(
          bout: bout,
          role: BoutRole.red,
          duration: stopwatch.elapsed,
          actionType: BoutActionType.passivity,
        );
        await createOrUpdateAction(action);
        break;
      case BoutScreenActions.redCaution:
        final action = BoutAction(
          bout: bout,
          role: BoutRole.red,
          duration: stopwatch.elapsed,
          actionType: BoutActionType.caution,
        );
        await createOrUpdateAction(action);
        break;
      case BoutScreenActions.redDismissal:
        final action = BoutAction(
          bout: bout,
          role: BoutRole.red,
          duration: stopwatch.elapsed,
          actionType: BoutActionType.dismissal,
        );
        await createOrUpdateAction(action);
        break;
      case BoutScreenActions.redActivityTime:
        doAction(BoutScreenActions.redActivityTime);
        break;
      case BoutScreenActions.redInjuryTime:
        doAction(BoutScreenActions.redInjuryTime);
        break;
      case BoutScreenActions.redBleedingInjuryTime:
        doAction(BoutScreenActions.redBleedingInjuryTime);
        break;
      case BoutScreenActions.redUndo:
        if (bout.r != null) {
          final actions = await getActions();
          final rActions = actions.where((el) => el.role == BoutRole.red);
          if (rActions.isNotEmpty) {
            final action = rActions.last;
            deleteAction(action);
          }
        }
        break;
      case BoutScreenActions.blueOne:
        final action = BoutAction(
          bout: bout,
          role: BoutRole.blue,
          duration: stopwatch.elapsed,
          actionType: BoutActionType.points,
          pointCount: 1,
        );
        await createOrUpdateAction(action);
        break;
      case BoutScreenActions.blueTwo:
        final action = BoutAction(
          bout: bout,
          role: BoutRole.blue,
          duration: stopwatch.elapsed,
          actionType: BoutActionType.points,
          pointCount: 2,
        );
        await createOrUpdateAction(action);
        break;
      case BoutScreenActions.blueThree:
        final action = BoutAction(
          bout: bout,
          role: BoutRole.blue,
          duration: stopwatch.elapsed,
          actionType: BoutActionType.points,
          pointCount: 3,
        );
        await createOrUpdateAction(action);
        break;
      case BoutScreenActions.blueFour:
        final action = BoutAction(
          bout: bout,
          role: BoutRole.blue,
          duration: stopwatch.elapsed,
          actionType: BoutActionType.points,
          pointCount: 4,
        );
        await createOrUpdateAction(action);
        break;
      case BoutScreenActions.blueFive:
        final action = BoutAction(
          bout: bout,
          role: BoutRole.blue,
          duration: stopwatch.elapsed,
          actionType: BoutActionType.points,
          pointCount: 5,
        );
        await createOrUpdateAction(action);
        break;
      case BoutScreenActions.blueVerbal:
        final action = BoutAction(
          bout: bout,
          role: BoutRole.blue,
          duration: stopwatch.elapsed,
          actionType: BoutActionType.verbal,
        );
        await createOrUpdateAction(action);
        break;
      case BoutScreenActions.bluePassivity:
        final action = BoutAction(
          bout: bout,
          role: BoutRole.blue,
          duration: stopwatch.elapsed,
          actionType: BoutActionType.passivity,
        );
        await createOrUpdateAction(action);
        break;
      case BoutScreenActions.blueCaution:
        final action = BoutAction(
          bout: bout,
          role: BoutRole.blue,
          duration: stopwatch.elapsed,
          actionType: BoutActionType.caution,
        );
        await createOrUpdateAction(action);
        break;
      case BoutScreenActions.blueDismissal:
        final action = BoutAction(
          bout: bout,
          role: BoutRole.blue,
          duration: stopwatch.elapsed,
          actionType: BoutActionType.dismissal,
        );
        await createOrUpdateAction(action);
        break;
      case BoutScreenActions.blueUndo:
        if (bout.b != null) {
          final actions = await getActions();
          final bActions = actions.where((el) => el.role == BoutRole.blue);
          if (bActions.isNotEmpty) {
            final action = bActions.last;
            deleteAction(action);
          }
        }
        break;
      case BoutScreenActions.blueActivityTime:
        doAction(BoutScreenActions.blueActivityTime);
        break;
      case BoutScreenActions.blueInjuryTime:
        doAction(BoutScreenActions.blueInjuryTime);
        break;
      case BoutScreenActions.blueBleedingInjuryTime:
        doAction(BoutScreenActions.blueBleedingInjuryTime);
        break;
      case BoutScreenActions.undo:
        final actions = await getActions();
        if (actions.isNotEmpty) {
          final action = actions.last;
          deleteAction(action);
        }
        break;
      case BoutScreenActions.horn:
        doAction(BoutScreenActions.horn);
        break;
    }
  }
}

const redOneIntent = BoutScreenActionIntent.redOne();
const redTwoIntent = BoutScreenActionIntent.redTwo();
const redThreeIntent = BoutScreenActionIntent.redThree();
const redFourIntent = BoutScreenActionIntent.redFour();
const redFiveIntent = BoutScreenActionIntent.redFive();

const blueOneIntent = BoutScreenActionIntent.blueOne();
const blueTwoIntent = BoutScreenActionIntent.blueTwo();
const blueThreeIntent = BoutScreenActionIntent.blueThree();
const blueFourIntent = BoutScreenActionIntent.blueFour();
const blueFiveIntent = BoutScreenActionIntent.blueFive();

final shortcuts = <LogicalKeySet, Intent>{
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
  LogicalKeySet(LogicalKeyboardKey.digit5): redFiveIntent,
  LogicalKeySet(LogicalKeyboardKey.numpad1): blueOneIntent,
  LogicalKeySet(LogicalKeyboardKey.numpad2): blueTwoIntent,
  LogicalKeySet(LogicalKeyboardKey.numpad3): blueThreeIntent,
  LogicalKeySet(LogicalKeyboardKey.numpad4): blueFourIntent,
  LogicalKeySet(LogicalKeyboardKey.numpad5): blueFiveIntent,
};

class BoutActionHandler extends ConsumerWidget {
  final Widget child;
  final ObservableStopwatch stopwatch;
  final List<Bout> bouts;
  final Future<List<BoutAction>> Function() getActions;
  final int boutIndex;
  final Function(BoutScreenActions action) doAction;
  final void Function(BuildContext context, int boutIndex) navigateToBoutByIndex;
  final Future<void> Function(BoutAction action) createOrUpdateAction;
  final Future<void> Function(BoutAction action) deleteAction;

  const BoutActionHandler({
    required this.child,
    required this.stopwatch,
    required this.bouts,
    required this.getActions,
    required this.boutIndex,
    required this.doAction,
    super.key,
    required this.navigateToBoutByIndex,
    required this.createOrUpdateAction,
    required this.deleteAction,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Shortcuts(
      shortcuts: shortcuts,
      child: Actions(
        actions: <Type, Action<Intent>>{
          BoutScreenActionIntent: CallbackAction<BoutScreenActionIntent>(
            onInvoke: (BoutScreenActionIntent intent) => handleIntent(intent, context: context),
          ),
        },
        child: KeyboardListener(
          focusNode: FocusNode(),
          child: Focus(autofocus: true, child: child),
          onKeyEvent: (KeyEvent event) {
            if (event is KeyDownEvent) {
              if (event.physicalKey == PhysicalKeyboardKey.keyF) {
                handleIntent(redOneIntent, context: context);
              } else if (event.physicalKey == PhysicalKeyboardKey.keyD) {
                handleIntent(redTwoIntent, context: context);
              } else if (event.physicalKey == PhysicalKeyboardKey.keyS) {
                handleIntent(redFourIntent, context: context);
              } else if (event.physicalKey == PhysicalKeyboardKey.keyA) {
                handleIntent(redFiveIntent, context: context);
              } else if (event.physicalKey == PhysicalKeyboardKey.keyJ ||
                  (HardwareKeyboard.instance.isShiftPressed && event.physicalKey == PhysicalKeyboardKey.digit1)) {
                handleIntent(blueOneIntent, context: context);
              } else if (event.physicalKey == PhysicalKeyboardKey.keyK ||
                  (HardwareKeyboard.instance.isShiftPressed && event.physicalKey == PhysicalKeyboardKey.digit2)) {
                handleIntent(blueTwoIntent, context: context);
              } else if (HardwareKeyboard.instance.isShiftPressed && event.physicalKey == PhysicalKeyboardKey.digit3) {
                handleIntent(blueThreeIntent, context: context);
              } else if (event.physicalKey == PhysicalKeyboardKey.keyL ||
                  (HardwareKeyboard.instance.isShiftPressed && event.physicalKey == PhysicalKeyboardKey.digit4)) {
                handleIntent(blueFourIntent, context: context);
              } else if (event.physicalKey == PhysicalKeyboardKey.semicolon ||
                  (HardwareKeyboard.instance.isShiftPressed && event.physicalKey == PhysicalKeyboardKey.digit5)) {
                handleIntent(blueFiveIntent, context: context);
              }
            }
          },
        ),
      ),
    );
  }

  Future<void> handleIntent(BoutScreenActionIntent intent, {required BuildContext context}) async {
    if (context.mounted) {
      await catchAsync(context, () async {
        await intent.handle(
          stopwatch,
          bouts,
          getActions,
          boutIndex,
          doAction,
          context: context,
          navigateToBoutByIndex: navigateToBoutByIndex,
          createOrUpdateAction: createOrUpdateAction,
          deleteAction: deleteAction,
        );
      });
    }
  }
}
