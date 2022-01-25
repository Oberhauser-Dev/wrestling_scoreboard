import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wrestling_scoreboard/data/fight_result.dart';
import 'package:wrestling_scoreboard/data/fight_role.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';

import 'fight_screen.dart';
import 'fight_shortcuts.dart';

class FightMainControls extends StatefulWidget {
  final Function(FightScreenActionIntent) callback;
  final FightState fightState;

  const FightMainControls(this.callback, this.fightState, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => FightMainControlsState();
}

class FightMainControlsState extends State<FightMainControls> {
  IconData _pausePlayButton = Icons.play_arrow;

  @override
  Widget build(BuildContext context) {
    widget.fightState.stopwatch.onStartStop.stream.listen((isRunning) {
      if (mounted) {
        setState(() {
          _pausePlayButton = isRunning ? Icons.pause : Icons.play_arrow;
        });
      }
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(flex: 35, child: displayDropDown(FightRole.red)),
        Expanded(
            flex: 50,
            child: Row(
              children: [
                Expanded(
                    child: widget.fightState.fights.first == widget.fightState.fight
                        ? IconButton(
                            color: Colors.white24,
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              widget.callback(const FightScreenActionIntent.Quit());
                            },
                          )
                        : IconButton(
                            color: Colors.white24,
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              widget.callback(const FightScreenActionIntent.PreviousFight());
                            },
                          )),
                Expanded(
                    child: IconButton(
                        onPressed: () => widget.callback(const FightScreenActionIntent.StartStop()),
                        icon: Icon(_pausePlayButton))),
                Expanded(
                    child: IconButton(
                        onPressed: () => widget.callback(const FightScreenActionIntent.Horn()),
                        icon: const Icon(Icons.campaign))),
                Expanded(
                    child: widget.fightState.fights.last == widget.fightState.fight
                        ? IconButton(
                            color: Colors.white24,
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              widget.callback(const FightScreenActionIntent.Quit());
                            },
                          )
                        : IconButton(
                            color: Colors.white24,
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: () {
                              widget.callback(const FightScreenActionIntent.NextFight());
                            },
                          )),
              ],
            )),
        Expanded(flex: 35, child: displayDropDown(FightRole.blue)),
      ],
    );
  }

  displayDropDown(FightRole role) {
    ParticipantState? pStatus = role == FightRole.red ? widget.fightState.fight.r : widget.fightState.fight.b;
    // Empty List, if pStatus is empty
    List<DropdownMenuItem<FightResult?>> items = pStatus != null
        ? FightResult.values.map((FightResult? value) {
            return DropdownMenuItem<FightResult?>(
              value: value,
              child: Tooltip(
                  message: getDescriptionFromFightResult(value, context),
                  child: Text(getAbbreviationFromFightResult(value, context))),
            );
          }).toList()
        : [];
    items.add(DropdownMenuItem<FightResult?>(
      value: null,
      child: Text(AppLocalizations.of(context)!.optionSelect, style: TextStyle(color: Theme.of(context).disabledColor)),
    ));
    return Container(
      color: role == widget.fightState.fight.winner ? getColorFromFightRole(role) : null,
      child: ButtonTheme(
          alignedDropdown: true,
          child: Consumer<List<FightAction>>(
            builder: (context, actions, child) => DropdownButton<FightResult?>(
              isExpanded: true,
              value: role == widget.fightState.fight.winner || widget.fightState.fight.result == FightResult.DSQ2
                  ? widget.fightState.fight.result
                  : null,
              items: items,
              onChanged: (val) {
                setState(() {
                  widget.fightState.fight.winner = val != null && val != FightResult.DSQ2 ? role : null;
                  widget.fightState.fight.result = val;
                  widget.fightState.fight.updateClassificationPoints(actions);
                  dataProvider.createOrUpdateSingle(widget.fightState.fight);
                  if(widget.fightState.fight.r != null) dataProvider.createOrUpdateSingle(widget.fightState.fight.r!);
                  if(widget.fightState.fight.b != null) dataProvider.createOrUpdateSingle(widget.fightState.fight.b!);
                });
              },
            ),
          )),
    );
  }
}
