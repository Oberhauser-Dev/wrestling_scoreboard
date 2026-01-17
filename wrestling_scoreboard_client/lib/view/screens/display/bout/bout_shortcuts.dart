import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  const RolePointBoutActionIntent.blueFour()
    : points = 4,
      super(boutActionType: BoutActionType.points, role: BoutRole.blue);

  const RolePointBoutActionIntent.blueFive()
    : points = 5,
      super(boutActionType: BoutActionType.points, role: BoutRole.blue);
}

const redOneIntent = RolePointBoutActionIntent.redOne();
const redTwoIntent = RolePointBoutActionIntent.redTwo();
const redFourIntent = RolePointBoutActionIntent.redFour();
const redFiveIntent = RolePointBoutActionIntent.redFive();

const blueOneIntent = RolePointBoutActionIntent.blueOne();
const blueTwoIntent = RolePointBoutActionIntent.blueTwo();
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
  LogicalKeySet(LogicalKeyboardKey.numpad1): blueOneIntent,
  LogicalKeySet(LogicalKeyboardKey.numpad2): blueTwoIntent,
  LogicalKeySet(LogicalKeyboardKey.numpad4): blueFourIntent,
  LogicalKeySet(LogicalKeyboardKey.numpad5): blueFiveIntent,
};

class BoutActionHandler extends StatefulWidget {
  final Widget child;
  final void Function(Intent intent) handleIntent;

  const BoutActionHandler({required this.child, required this.handleIntent, super.key});

  @override
  State<BoutActionHandler> createState() => _BoutActionHandlerState();
}

class _BoutActionHandlerState extends State<BoutActionHandler> {
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: shortcuts,
      child: Actions(
        actions: <Type, Action<Intent>>{
          RolePointBoutActionIntent: CallbackAction<RolePointBoutActionIntent>(onInvoke: widget.handleIntent),
          RoleBoutActionIntent: CallbackAction<RoleBoutActionIntent>(onInvoke: widget.handleIntent),
          RoleScreenActionIntent: CallbackAction<RoleScreenActionIntent>(onInvoke: widget.handleIntent),
          BoutScreenActionIntent: CallbackAction<BoutScreenActionIntent>(onInvoke: widget.handleIntent),
        },
        child: KeyboardListener(
          focusNode: _focusNode,
          autofocus: true,
          child: widget.child,
          onKeyEvent: (KeyEvent event) {
            if (event is KeyDownEvent) {
              if (!HardwareKeyboard.instance.isShiftPressed) {
                if (event.physicalKey == PhysicalKeyboardKey.keyF || event.physicalKey == PhysicalKeyboardKey.digit1) {
                  widget.handleIntent(redOneIntent);
                } else if (event.physicalKey == PhysicalKeyboardKey.keyD ||
                    event.physicalKey == PhysicalKeyboardKey.digit2) {
                  widget.handleIntent(redTwoIntent);
                } else if (event.physicalKey == PhysicalKeyboardKey.keyS ||
                    event.physicalKey == PhysicalKeyboardKey.digit4) {
                  widget.handleIntent(redFourIntent);
                } else if (event.physicalKey == PhysicalKeyboardKey.keyA ||
                    event.physicalKey == PhysicalKeyboardKey.digit5) {
                  widget.handleIntent(redFiveIntent);
                } else if (event.physicalKey == PhysicalKeyboardKey.keyJ) {
                  widget.handleIntent(blueOneIntent);
                } else if (event.physicalKey == PhysicalKeyboardKey.keyK) {
                  widget.handleIntent(blueTwoIntent);
                } else if (event.physicalKey == PhysicalKeyboardKey.keyL) {
                  widget.handleIntent(blueFourIntent);
                } else if (event.physicalKey == PhysicalKeyboardKey.semicolon) {
                  widget.handleIntent(blueFiveIntent);
                }
              } else {
                if (event.physicalKey == PhysicalKeyboardKey.digit1) {
                  widget.handleIntent(blueOneIntent);
                } else if (event.physicalKey == PhysicalKeyboardKey.digit2) {
                  widget.handleIntent(blueTwoIntent);
                } else if (event.physicalKey == PhysicalKeyboardKey.digit4) {
                  widget.handleIntent(blueFourIntent);
                } else if (event.physicalKey == PhysicalKeyboardKey.digit5) {
                  widget.handleIntent(blueFiveIntent);
                }
              }
            }
          },
        ),
      ),
    );
  }
}
