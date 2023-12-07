import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wrestling_scoreboard_client/data/bout_result.dart';
import 'package:wrestling_scoreboard_client/data/bout_role.dart';
import 'package:wrestling_scoreboard_client/ui/bout/bout_display.dart';
import 'package:wrestling_scoreboard_client/ui/bout/bout_shortcuts.dart';
import 'package:wrestling_scoreboard_client/util/network/data_provider.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class BoutMainControls extends StatefulWidget {
  final Function(BoutScreenActionIntent) callback;
  final BoutState boutState;

  const BoutMainControls(this.callback, this.boutState, {super.key});

  @override
  State<StatefulWidget> createState() => BoutMainControlsState();
}

class BoutMainControlsState extends State<BoutMainControls> {
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
                    child: widget.boutState.bouts.first == widget.boutState.bout
                        ? IconButton(
                            color: Colors.white24,
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              widget.callback(const BoutScreenActionIntent.quit());
                            },
                          )
                        : IconButton(
                            color: Colors.white24,
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
                    child: widget.boutState.bouts.last == widget.boutState.bout
                        ? IconButton(
                            color: Colors.white24,
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              widget.callback(const BoutScreenActionIntent.quit());
                            },
                          )
                        : IconButton(
                            color: Colors.white24,
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
    List<DropdownMenuItem<BoutResult?>> items = [];
    if (pStatus != null) {
      final boutResultValues = BoutResult.values.toList();
      if (pStatusOpponent == null) {
        // Cannot select this option, as there is no opponent
        boutResultValues.remove(BoutResult.dsq2);
      }
      items.addAll(boutResultValues.map((BoutResult? value) {
        return DropdownMenuItem<BoutResult?>(
          value: value,
          child: Tooltip(
              message: getDescriptionFromBoutResult(value, context),
              child: Text(getAbbreviationFromBoutResult(value, context))),
        );
      }).toList());
    }
    items.add(DropdownMenuItem<BoutResult?>(
      value: null,
      child: Text(AppLocalizations.of(context)!.optionSelect, style: TextStyle(color: Theme.of(context).disabledColor)),
    ));
    return Container(
      color: role == widget.boutState.bout.winnerRole ? getColorFromBoutRole(role) : null,
      child: ButtonTheme(
          alignedDropdown: true,
          child: Consumer<List<BoutAction>>(
            builder: (context, actions, child) => DropdownButton<BoutResult?>(
              isExpanded: true,
              value: role == widget.boutState.bout.winnerRole || widget.boutState.bout.result == BoutResult.dsq2
                  ? widget.boutState.bout.result
                  : null,
              items: items,
              onChanged: (val) {
                setState(() {
                  var bout = widget.boutState.bout.copyWith(
                    winnerRole: val != null && val != BoutResult.dsq2 ? role : null,
                    result: val,
                  );
                  bout = bout.updateClassificationPoints(actions);
                  dataProvider.createOrUpdateSingle(bout);
                  if (bout.r != null) dataProvider.createOrUpdateSingle(bout.r!);
                  if (bout.b != null) dataProvider.createOrUpdateSingle(bout.b!);
                  widget.boutState.bout = bout;
                });
              },
            ),
          )),
    );
  }
}
