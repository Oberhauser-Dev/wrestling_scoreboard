import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class FightShortCuts extends StatelessWidget {
  final Widget child;
  final Function toggleStopwatch;

  FightShortCuts({required this.child, required this.toggleStopwatch});

  @override
  Widget build(BuildContext context) {
    Model model = Model();
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.space): const StopwatchIntent(),
        LogicalKeySet(LogicalKeyboardKey.arrowUp): const IncrementIntent(2),
        LogicalKeySet(LogicalKeyboardKey.arrowDown): const DecrementIntent(2),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          StopwatchIntent: StopwatchAction(toggleStopwatch),
          IncrementIntent: IncrementAction(model),
          DecrementIntent: DecrementAction(model),
        },
        child: Focus(
          autofocus: true,
          child: child,
        ),
      ),
    );
  }
}

class Model with ChangeNotifier {
  int count = 0;

  void incrementBy(int amount) {
    count += amount;
    notifyListeners();
  }

  void decrementBy(int amount) {
    count -= amount;
    notifyListeners();
  }
}

class StopwatchIntent extends Intent {
  const StopwatchIntent();
}

class StopwatchAction extends Action<StopwatchIntent> {
  final Function toggleStopwatch;

  StopwatchAction(this.toggleStopwatch);

  @override
  void invoke(covariant StopwatchIntent intent) {
    toggleStopwatch();
  }
}

class IncrementIntent extends Intent {
  const IncrementIntent(this.amount);

  final int amount;
}

class DecrementIntent extends Intent {
  const DecrementIntent(this.amount);

  final int amount;
}

class IncrementAction extends Action<IncrementIntent> {
  IncrementAction(this.model);

  final Model model;

  @override
  void invoke(covariant IncrementIntent intent) {
    model.incrementBy(intent.amount);
  }
}

class DecrementAction extends Action<DecrementIntent> {
  DecrementAction(this.model);

  final Model model;

  @override
  void invoke(covariant DecrementIntent intent) {
    model.decrementBy(intent.amount);
  }
}
