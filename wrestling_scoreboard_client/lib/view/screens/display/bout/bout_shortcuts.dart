import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_common/common.dart';

enum BoutScreenActionType { startStop, reset, addOneSec, rmOneSec, undo, nextBout, previousBout, horn, quit }

enum RoleScreenActionType { roleAction, activityTime, injuryTime, bleedingInjuryTime, undo }

class BoutScreenActionIntent extends Intent {
  const BoutScreenActionIntent({required this.type});

  const BoutScreenActionIntent.startStop() : type = BoutScreenActionType.startStop;

  const BoutScreenActionIntent.reset() : type = BoutScreenActionType.reset;

  const BoutScreenActionIntent.addOneSec() : type = BoutScreenActionType.addOneSec;

  const BoutScreenActionIntent.rmOneSec() : type = BoutScreenActionType.rmOneSec;

  const BoutScreenActionIntent.undo() : type = BoutScreenActionType.undo;

  const BoutScreenActionIntent.nextBout() : type = BoutScreenActionType.nextBout;

  const BoutScreenActionIntent.previousBout() : type = BoutScreenActionType.previousBout;

  const BoutScreenActionIntent.horn() : type = BoutScreenActionType.horn;

  const BoutScreenActionIntent.quit() : type = BoutScreenActionType.quit;

  final BoutScreenActionType type;
}

class RoleScreenActionIntent extends Intent {
  final BoutRole role;
  final RoleScreenActionType type;

  const RoleScreenActionIntent({required this.role, required this.type});

  const RoleScreenActionIntent.redActivityTime() : role = BoutRole.red, type = RoleScreenActionType.activityTime;

  const RoleScreenActionIntent.redInjuryTime() : role = BoutRole.red, type = RoleScreenActionType.injuryTime;

  const RoleScreenActionIntent.redBleedingInjuryTime()
    : role = BoutRole.red,
      type = RoleScreenActionType.bleedingInjuryTime;

  const RoleScreenActionIntent.redUndo() : role = BoutRole.red, type = RoleScreenActionType.undo;

  const RoleScreenActionIntent.blueActivityTime() : role = BoutRole.blue, type = RoleScreenActionType.activityTime;

  const RoleScreenActionIntent.blueInjuryTime() : role = BoutRole.blue, type = RoleScreenActionType.injuryTime;

  const RoleScreenActionIntent.blueBleedingInjuryTime()
    : role = BoutRole.blue,
      type = RoleScreenActionType.bleedingInjuryTime;

  const RoleScreenActionIntent.blueUndo() : role = BoutRole.blue, type = RoleScreenActionType.undo;
}

class RoleBoutActionIntent extends RoleScreenActionIntent {
  final BoutActionType boutActionType;

  const RoleBoutActionIntent({required this.boutActionType, required super.role})
    : super(type: RoleScreenActionType.roleAction);

  factory RoleBoutActionIntent.verbal({required BoutRole role}) =>
      RoleBoutActionIntent(boutActionType: BoutActionType.verbal, role: role);

  factory RoleBoutActionIntent.redVerbal() => RoleBoutActionIntent.verbal(role: BoutRole.red);

  factory RoleBoutActionIntent.blueVerbal() => RoleBoutActionIntent.verbal(role: BoutRole.blue);

  factory RoleBoutActionIntent.passivity({required BoutRole role}) =>
      RoleBoutActionIntent(boutActionType: BoutActionType.passivity, role: role);

  factory RoleBoutActionIntent.redPassivity() => RoleBoutActionIntent.passivity(role: BoutRole.red);

  factory RoleBoutActionIntent.bluePassivity() => RoleBoutActionIntent.passivity(role: BoutRole.blue);

  factory RoleBoutActionIntent.caution({required BoutRole role}) =>
      RoleBoutActionIntent(boutActionType: BoutActionType.caution, role: role);

  factory RoleBoutActionIntent.redCaution() => RoleBoutActionIntent.caution(role: BoutRole.red);

  factory RoleBoutActionIntent.blueCaution() => RoleBoutActionIntent.caution(role: BoutRole.blue);

  factory RoleBoutActionIntent.dismissal({required BoutRole role}) =>
      RoleBoutActionIntent(boutActionType: BoutActionType.dismissal, role: role);

  factory RoleBoutActionIntent.redDismissal() => RoleBoutActionIntent.dismissal(role: BoutRole.red);

  factory RoleBoutActionIntent.blueDismissal() => RoleBoutActionIntent.dismissal(role: BoutRole.blue);
}

class RolePointBoutActionIntent extends RoleBoutActionIntent {
  final int points;

  const RolePointBoutActionIntent({required this.points, required super.role})
    : super(boutActionType: BoutActionType.points);

  const RolePointBoutActionIntent.redOne()
    : points = 1,
      super(boutActionType: BoutActionType.points, role: BoutRole.red);

  const RolePointBoutActionIntent.redTwo()
    : points = 2,
      super(boutActionType: BoutActionType.points, role: BoutRole.red);

  const RolePointBoutActionIntent.redThree()
    : points = 3,
      super(boutActionType: BoutActionType.points, role: BoutRole.red);

  const RolePointBoutActionIntent.redFour()
    : points = 4,
      super(boutActionType: BoutActionType.points, role: BoutRole.red);

  const RolePointBoutActionIntent.redFive()
    : points = 5,
      super(boutActionType: BoutActionType.points, role: BoutRole.red);

  const RolePointBoutActionIntent.blueOne()
    : points = 1,
      super(boutActionType: BoutActionType.points, role: BoutRole.blue);

  const RolePointBoutActionIntent.blueTwo()
    : points = 2,
      super(boutActionType: BoutActionType.points, role: BoutRole.blue);

  const RolePointBoutActionIntent.blueThree()
    : points = 3,
      super(boutActionType: BoutActionType.points, role: BoutRole.blue);

  const RolePointBoutActionIntent.blueFour()
    : points = 4,
      super(boutActionType: BoutActionType.points, role: BoutRole.blue);

  const RolePointBoutActionIntent.blueFive()
    : points = 5,
      super(boutActionType: BoutActionType.points, role: BoutRole.blue);
}

const redOneIntent = RolePointBoutActionIntent.redOne();
const redTwoIntent = RolePointBoutActionIntent.redTwo();
const redThreeIntent = RolePointBoutActionIntent.redThree();
const redFourIntent = RolePointBoutActionIntent.redFour();
const redFiveIntent = RolePointBoutActionIntent.redFive();

const blueOneIntent = RolePointBoutActionIntent.blueOne();
const blueTwoIntent = RolePointBoutActionIntent.blueTwo();
const blueThreeIntent = RolePointBoutActionIntent.blueThree();
const blueFourIntent = RolePointBoutActionIntent.blueFour();
const blueFiveIntent = RolePointBoutActionIntent.blueFive();

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
  final void Function(Intent intent) handleIntent;

  const BoutActionHandler({required this.child, required this.handleIntent, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Shortcuts(
      shortcuts: shortcuts,
      child: Actions(
        actions: <Type, Action<Intent>>{
          RoleScreenActionIntent: CallbackAction<RolePointBoutActionIntent>(onInvoke: handleIntent),
          BoutScreenActionIntent: CallbackAction<BoutScreenActionIntent>(onInvoke: handleIntent),
        },
        child: KeyboardListener(
          focusNode: FocusNode(),
          child: Focus(autofocus: true, child: child),
          onKeyEvent: (KeyEvent event) {
            if (event is KeyDownEvent) {
              if (event.physicalKey == PhysicalKeyboardKey.keyF) {
                handleIntent(redOneIntent);
              } else if (event.physicalKey == PhysicalKeyboardKey.keyD) {
                handleIntent(redTwoIntent);
              } else if (event.physicalKey == PhysicalKeyboardKey.keyS) {
                handleIntent(redFourIntent);
              } else if (event.physicalKey == PhysicalKeyboardKey.keyA) {
                handleIntent(redFiveIntent);
              } else if (event.physicalKey == PhysicalKeyboardKey.keyJ ||
                  (HardwareKeyboard.instance.isShiftPressed && event.physicalKey == PhysicalKeyboardKey.digit1)) {
                handleIntent(blueOneIntent);
              } else if (event.physicalKey == PhysicalKeyboardKey.keyK ||
                  (HardwareKeyboard.instance.isShiftPressed && event.physicalKey == PhysicalKeyboardKey.digit2)) {
                handleIntent(blueTwoIntent);
              } else if (HardwareKeyboard.instance.isShiftPressed && event.physicalKey == PhysicalKeyboardKey.digit3) {
                handleIntent(blueThreeIntent);
              } else if (event.physicalKey == PhysicalKeyboardKey.keyL ||
                  (HardwareKeyboard.instance.isShiftPressed && event.physicalKey == PhysicalKeyboardKey.digit4)) {
                handleIntent(blueFourIntent);
              } else if (event.physicalKey == PhysicalKeyboardKey.semicolon ||
                  (HardwareKeyboard.instance.isShiftPressed && event.physicalKey == PhysicalKeyboardKey.digit5)) {
                handleIntent(blueFiveIntent);
              }
            }
          },
        ),
      ),
    );
  }
}
