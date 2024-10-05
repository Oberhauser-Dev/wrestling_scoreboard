import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/bout_result.dart';
import 'package:wrestling_scoreboard_client/localization/bout_utils.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/bout_display.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/bout_shortcuts.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/themed.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class BoutMainControls extends ConsumerStatefulWidget {
  final Function(BoutScreenActionIntent) callback;
  final BoutState boutState;

  const BoutMainControls(this.callback, this.boutState, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => BoutMainControlsState();
}

class BoutMainControlsState extends ConsumerState<BoutMainControls> {
  IconData _pausePlayButton = Icons.play_arrow;

  @override
  Widget build(BuildContext context) {
    widget.boutState.stopwatch.onStartStop.stream.listen((isRunning) {
      if (mounted) {
        setState(() {
          _pausePlayButton = isRunning ? Icons.pause : Icons.play_arrow;
        });
      }
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(flex: 35, child: displayDropDown(BoutRole.red)),
        Expanded(
            flex: 50,
            child: Row(
              children: [
                Expanded(
                    child: widget.boutState.widget.bouts.first == widget.boutState.bout
                        ? IconButton(
                            color: Theme.of(context).disabledColor,
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              widget.callback(const BoutScreenActionIntent.quit());
                            },
                          )
                        : IconButton(
                            color: Theme.of(context).disabledColor,
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              widget.callback(const BoutScreenActionIntent.previousBout());
                            },
                          )),
                Expanded(
                    child: IconButton(
                        onPressed: () => widget.callback(const BoutScreenActionIntent.startStop()),
                        icon: Icon(_pausePlayButton))),
                Expanded(
                    child: IconButton(
                        onPressed: () => widget.callback(const BoutScreenActionIntent.horn()),
                        icon: const Icon(Icons.campaign))),
                Expanded(
                    child: widget.boutState.widget.bouts.last == widget.boutState.bout
                        ? IconButton(
                            color: Theme.of(context).disabledColor,
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              widget.callback(const BoutScreenActionIntent.quit());
                            },
                          )
                        : IconButton(
                            color: Theme.of(context).disabledColor,
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: () {
                              widget.callback(const BoutScreenActionIntent.nextBout());
                            },
                          )),
              ],
            )),
        Expanded(flex: 35, child: displayDropDown(BoutRole.blue)),
      ],
    );
  }

  displayDropDown(BoutRole role) {
    ParticipantState? pStatus = role == BoutRole.red ? widget.boutState.bout.r : widget.boutState.bout.b;
    ParticipantState? pStatusOpponent = role == BoutRole.blue ? widget.boutState.bout.r : widget.boutState.bout.b;
    // Empty List, if pStatus is empty
    final List<MapEntry<BoutResult, Widget>> boutResultOptions = [];
    if (pStatus != null) {
      final boutResultValues = List.of(BoutResult.values);
      if (pStatusOpponent == null) {
        // Cannot select this option, as there is no opponent
        boutResultValues.remove(BoutResult.dsq2);
      }
      boutResultOptions.addAll(boutResultValues.map(
        (BoutResult boutResult) => MapEntry(
          boutResult,
          Tooltip(
            message: boutResult.description(context),
            child: Text(boutResult.abbreviation(context)),
          ),
        ),
      ));
    }
    return ThemedContainer(
      color: role == widget.boutState.bout.winnerRole ? role.color() : null,
      child: ButtonTheme(
          alignedDropdown: true,
          child: ManyConsumer<BoutAction, Bout>(
            filterObject: widget.boutState.bout,
            builder: (context, actions) {
              return SimpleDropdown<BoutResult>(
                isNullable: true,
                selected: role == widget.boutState.bout.winnerRole || widget.boutState.bout.result == BoutResult.dsq2
                    ? widget.boutState.bout.result
                    : null,
                options: boutResultOptions,
                onChange: (BoutResult? val) async {
                  final dataManager = await ref.read(dataManagerNotifierProvider);
                  var bout = widget.boutState.bout.copyWith(
                    winnerRole: val != null && val != BoutResult.dsq2 ? role : null,
                    result: val,
                  );
                  bout = bout.updateClassificationPoints(actions, rules: widget.boutState.boutRules);
                  dataManager.createOrUpdateSingle(bout);
                  if (bout.r != null) dataManager.createOrUpdateSingle(bout.r!);
                  if (bout.b != null) dataManager.createOrUpdateSingle(bout.b!);

                  setState(() {
                    widget.boutState.bout = bout;
                  });
                },
              );
            },
          )),
    );
  }
}
