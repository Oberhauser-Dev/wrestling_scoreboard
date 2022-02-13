import 'dart:async';

import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wrestling_scoreboard/data/fight_role.dart';
import 'package:wrestling_scoreboard/data/wrestling_style.dart';
import 'package:wrestling_scoreboard/ui/components/consumer.dart';
import 'package:wrestling_scoreboard/ui/fight/fight_action_controls.dart';
import 'package:wrestling_scoreboard/ui/fight/fight_shortcuts.dart';
import 'package:wrestling_scoreboard/ui/fight/technical_points.dart';
import 'package:wrestling_scoreboard/ui/fight/time_display.dart';
import 'package:wrestling_scoreboard/ui/models/participant_state_model.dart';
import 'package:wrestling_scoreboard/util/audio/audio.dart';
import 'package:wrestling_scoreboard/util/colors.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';
import 'package:wrestling_scoreboard/util/units.dart';

import '../components/fitted_text.dart';
import '../match/common_elements.dart';
import 'fight_actions.dart';
import 'fight_main_controls.dart';

void navigateToFightScreen(BuildContext context, TeamMatch match, List<Fight> fights, int index) async {
  final actions = await dataProvider.readMany<FightAction>(filterObject: fights[index]);
  Navigator.push(context, MaterialPageRoute(builder: (context) => FightScreen(match, fights, actions, index)));
}

/// Initialize with default values, but do not synchronize with live data, as during a fight the connection could be interrupted. So the client always sends data, but never should receive any.
/// If closing and reopening screen, data should be updated though.
class FightScreen extends StatefulWidget {
  final TeamMatch match;
  final List<Fight> fights;
  final List<FightAction> actions;
  final int fightIndex;

  const FightScreen(this.match, this.fights, this.actions, this.fightIndex, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => FightState();
}

class FightState extends State<FightScreen> {
  final StreamController<List<FightAction>> _onChangeActions = StreamController.broadcast();
  late TeamMatch match;
  late Fight fight;
  late List<Fight> fights;
  late List<FightAction> actions;
  late int fightIndex;
  late ObservableStopwatch stopwatch;
  late ObservableStopwatch _fightStopwatch;
  late ObservableStopwatch _breakStopwatch;
  late ParticipantStateModel _r;
  late ParticipantStateModel _b;
  late BoutConfig _boutConfig;
  int period = 1;
  late Function(FightScreenActionIntent) handleAction;

  List<FightAction> getActions() => actions;

  setActions(List<FightAction> actions) {
    _onChangeActions.add(List.of(actions));
  }

  @override
  initState() {
    super.initState();
    HornSound();
    match = widget.match;
    fights = widget.fights;
    // TODO may overwrite in settings to be more flexible
    _boutConfig = match.home.team.league?.boutConfig ?? BoutConfig();
    actions = widget.actions;
    fightIndex = widget.fightIndex;
    fight = widget.fights[fightIndex];
    _r = ParticipantStateModel(fight.r);
    _b = ParticipantStateModel(fight.b);
    _r.injuryStopwatch.limit = _boutConfig.injuryDuration;
    _r.injuryStopwatch.onEnd.stream.listen((event) {
      setState(() {
        _r.isInjury = false;
      });
      handleAction(const FightScreenActionIntent.Horn());
    });
    _b.injuryStopwatch.limit = _boutConfig.injuryDuration;
    _b.injuryStopwatch.onEnd.stream.listen((event) {
      setState(() {
        _b.isInjury = false;
      });
      handleAction(const FightScreenActionIntent.Horn());
    });

    stopwatch = _fightStopwatch = ObservableStopwatch(
      limit: _boutConfig.periodDuration * _boutConfig.periodCount,
    );
    _fightStopwatch.onStart.stream.listen((event) {
      _r.activityStopwatch?.start();
      _b.activityStopwatch?.start();
    });
    _fightStopwatch.onStop.stream.listen((event) {
      _r.activityStopwatch?.stop();
      _b.activityStopwatch?.stop();
      
      // Save time to database on each stop
      dataProvider.createOrUpdateSingle(fight);
    });
    _fightStopwatch.onAdd.stream.listen((event) {
      _r.activityStopwatch?.addDuration(event);
      _b.activityStopwatch?.addDuration(event);
    });
    _fightStopwatch.onChangeSecond.stream.listen(
      (event) {
        if (stopwatch == _fightStopwatch) {
          fight.duration = event;

          if (fight.duration.compareTo(_boutConfig.periodDuration * period) >= 0) {
            _fightStopwatch.stop();
            if (_r.activityStopwatch != null) {
              _r.activityStopwatch!.dispose();
              _r.activityStopwatch = null;
            }
            if (_b.activityStopwatch != null) {
              _b.activityStopwatch!.dispose();
              _b.activityStopwatch = null;
            }
            handleAction(const FightScreenActionIntent.Horn());
            if (period < _boutConfig.periodCount) {
              setState(() {
                stopwatch = _breakStopwatch;
              });
              _breakStopwatch.start();
              period++;
            }
          } else if (fight.duration.inSeconds ~/ _boutConfig.periodDuration.inSeconds < (period - 1)) {
            // Fix times below round time: e.g. if subtract time
            period -= 1;
          }
        }
      },
    );
    stopwatch.addDuration(fight.duration);
    _breakStopwatch = ObservableStopwatch(
      limit: _boutConfig.breakDuration,
    );
    _breakStopwatch.onEnd.stream.listen((event) {
      if (stopwatch == _breakStopwatch) {
        _breakStopwatch.reset();
        setState(() {
          stopwatch = _fightStopwatch;
        });
        handleAction(const FightScreenActionIntent.Horn());
      }
    });
    _onChangeActions.stream.listen((actions) {
      this.actions = actions;
    });
    setActions(actions);
    handleAction = (FightScreenActionIntent intent) {
      FightActionHandler.handleIntentStatic(
          intent, stopwatch, match, fights, getActions, setActions, fightIndex, doAction,
          context: context);
    };
  }

  displayName(ParticipantState? pStatus, double padding, double cellHeight, double fontSizeDefault) {
    return Expanded(
        child: Column(children: [
      Container(
          padding: EdgeInsets.all(padding),
          height: cellHeight * 2,
          child: Center(
              child: FittedText(
            pStatus?.participation.membership.person.fullName ?? AppLocalizations.of(context)!.participantVacant,
            style: TextStyle(color: pStatus == null ? Colors.white30 : Colors.white),
          ))),
      SizedBox(
          height: cellHeight,
          child: Center(
              child: Text(
                  (pStatus?.participation.weight != null
                      ? '${pStatus?.participation.weight!.toStringAsFixed(1)} $weightUnit'
                      : AppLocalizations.of(context)!.participantUnknownWeight),
                  style: TextStyle(
                      fontSize: fontSizeDefault,
                      color: pStatus?.participation.weight == null ? Colors.white30 : Colors.white)))),
    ]));
  }

  displayClassificationPoints(ParticipantState? pStatus, MaterialColor color, double padding, double cellHeight) {
    return Consumer<ParticipantState?>(
      builder: (context, data, child) => pStatus?.classificationPoints != null
          ? Container(
              color: color.shade800,
              height: cellHeight * 3,
              padding: EdgeInsets.symmetric(vertical: padding * 3, horizontal: padding * 2),
              child: FittedText(
                pStatus!.classificationPoints.toString(),
              ),
            )
          : Container(),
    );
  }

  displayTechnicalPoints(ParticipantStateModel pStatus, FightRole role, double cellHeight) {
    return Expanded(
      flex: 33,
      child: TechnicalPoints(
        pStatusModel: pStatus,
        height: cellHeight,
        role: role,
      ),
    );
  }

  displayParticipant(ParticipantState? pStatus, FightRole role, double padding, double cellHeight, double fontSize) {
    var color = getColorFromFightRole(role);

    return Container(
      color: color,
      child: IntrinsicHeight(
        child: SingleConsumer<ParticipantState>(
          id: pStatus?.id,
          initialData: pStatus,
          builder: (context, pStatus) {
            List<Widget> items = [
              displayName(pStatus, padding, cellHeight, fontSize),
              displayClassificationPoints(pStatus, color, padding, cellHeight),
            ];
            if (role == FightRole.blue) items = List.from(items.reversed);
            return Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: items);
          },
        ),
      ),
    );
  }

  doAction(FightScreenActions action) {
    switch (action) {
      case FightScreenActions.RedActivityTime:
        ParticipantStateModel psm = _r;
        psm.activityStopwatch?.dispose();
        setState(() {
          psm.activityStopwatch =
              psm.activityStopwatch == null ? ObservableStopwatch(limit: _boutConfig.activityDuration) : null;
        });
        if (psm.activityStopwatch != null && _fightStopwatch.isRunning) psm.activityStopwatch!.start();
        psm.activityStopwatch?.onEnd.stream.listen((event) {
          handleAction(const FightScreenActionIntent.Horn());
          psm.activityStopwatch?.dispose();
          setState(() {
            psm.activityStopwatch = null;
          });
          handleAction(const FightScreenActionIntent.Horn());
        });
        break;
      case FightScreenActions.RedInjuryTime:
        ParticipantStateModel psm = _r;
        setState(() {
          psm.isInjury = !psm.isInjury;
        });
        if (psm.isInjury) {
          psm.injuryStopwatch.start();
        } else {
          psm.injuryStopwatch.stop();
        }
        break;
      case FightScreenActions.BlueActivityTime:
        ParticipantStateModel psm = _b;
        psm.activityStopwatch?.dispose();
        setState(() {
          psm.activityStopwatch =
              psm.activityStopwatch == null ? ObservableStopwatch(limit: _boutConfig.activityDuration) : null;
        });
        if (psm.activityStopwatch != null && _fightStopwatch.isRunning) psm.activityStopwatch!.start();
        psm.activityStopwatch?.onEnd.stream.listen((event) {
          psm.activityStopwatch?.dispose();
          setState(() {
            psm.activityStopwatch = null;
          });
          handleAction(const FightScreenActionIntent.Horn());
        });
        break;
      case FightScreenActions.BlueInjuryTime:
        ParticipantStateModel psm = _b;
        setState(() {
          psm.isInjury = !psm.isInjury;
        });
        if (psm.isInjury) {
          psm.injuryStopwatch.start();
        } else {
          psm.injuryStopwatch.stop();
        }
        break;
      default:
        break;
    }
  }

  row({required List<Widget> children, EdgeInsets? padding}) {
    return Container(
        padding: padding,
        child: IntrinsicHeight(child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: children)));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double padding = width / 100;
    TextStyle fontStyleInfo = TextStyle(fontSize: width / 60);
    double cellHeight = width / 30;
    double fontSizeDefault = width / 90;
    double cellHeightClock = width / 6;
    final bottomPadding = EdgeInsets.only(bottom: padding);

    MaterialColor stopwatchColor = stopwatch == _breakStopwatch ? Colors.orange : white;

    return FightActionHandler(
      stopwatch: stopwatch,
      match: match,
      getActions: getActions,
      setActions: setActions,
      fights: fights,
      fightIndex: fightIndex,
      doAction: doAction,
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          child: Row(children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ]),
        ),
        body: StreamProvider<List<FightAction>>(
          initialData: actions,
          create: (context) => _onChangeActions.stream,
          child: SingleChildScrollView(
            child: Column(
              children: [
                row(padding: bottomPadding, children: CommonElements.getTeamHeader(match, fights, context)),
                row(padding: bottomPadding, children: [
                  Expanded(
                    flex: 50,
                    child: displayParticipant(fight.r, FightRole.red, padding, cellHeight, fontSizeDefault),
                  ),
                  Expanded(
                      flex: 20,
                      child: Column(children: [
                        Row(children: [
                          Expanded(
                              child: Container(
                                  padding: EdgeInsets.all(padding),
                                  child: Center(
                                      child: Text(
                                    '${AppLocalizations.of(context)!.fight} ${fightIndex + 1}',
                                    style: fontStyleInfo,
                                  )))),
                        ]),
                        Container(
                            padding: EdgeInsets.all(padding),
                            child: Center(
                                child: Text(
                              '${styleToString(fight.weightClass.style, context)}',
                              style: fontStyleInfo,
                            ))),
                        Container(
                            padding: EdgeInsets.all(padding),
                            child: Center(
                                child: Text(
                              fight.weightClass.name,
                              style: fontStyleInfo,
                            ))),
                      ])),
                  Expanded(
                    flex: 50,
                    child: displayParticipant(fight.b, FightRole.blue, padding, cellHeight, fontSizeDefault),
                  ),
                ]),
                row(
                  padding: bottomPadding,
                  children: [
                    displayTechnicalPoints(_r, FightRole.red, cellHeightClock),
                    Expanded(
                        flex: 2,
                        child:
                            SizedBox(height: cellHeightClock, child: FightActionControls(FightRole.red, fight.r == null ? null : handleAction))),
                    Expanded(
                        flex: 50,
                        child: SizedBox(
                          height: cellHeightClock,
                          child: Center(child: TimeDisplay(stopwatch, stopwatchColor)),
                        )),
                    Expanded(
                        flex: 2,
                        child: SizedBox(
                            height: cellHeightClock, child: FightActionControls(FightRole.blue, fight.b == null ? null : handleAction))),
                    displayTechnicalPoints(_b, FightRole.blue, cellHeightClock),
                  ],
                ),
                Container(
                  padding: bottomPadding,
                  child: Consumer<List<FightAction>>(
                    builder: (context, actions, child) => ActionsWidget(actions),
                  ),
                ),
                Container(padding: bottomPadding, child: FightMainControls(handleAction, this)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    await HornSound().dispose();
    _fightStopwatch.dispose();
    _breakStopwatch.dispose();
  }
}
