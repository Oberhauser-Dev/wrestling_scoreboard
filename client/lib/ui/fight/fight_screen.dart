import 'package:common/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wrestling_scoreboard/data/fight.dart';
import 'package:wrestling_scoreboard/data/fight_role.dart';
import 'package:wrestling_scoreboard/data/participant_state.dart';
import 'package:wrestling_scoreboard/data/team_match.dart';
import 'package:wrestling_scoreboard/data/wrestling_style.dart';
import 'package:wrestling_scoreboard/ui/fight/fight_action_conrols.dart';
import 'package:wrestling_scoreboard/ui/fight/fight_shortcuts.dart';
import 'package:wrestling_scoreboard/ui/fight/technical_points.dart';
import 'package:wrestling_scoreboard/ui/fight/time_display.dart';
import 'package:wrestling_scoreboard/ui/models/participant_state_model.dart';
import 'package:wrestling_scoreboard/util/colors.dart';
import 'package:wrestling_scoreboard/util/units.dart';

import '../components/fitted_text.dart';
import '../match/common_elements.dart';
import 'fight_actions.dart';
import 'fight_controls.dart';

class FightScreen extends StatefulWidget {
  final ClientTeamMatch match;
  final ClientFight fight;

  FightScreen(this.match, this.fight);

  @override
  State<StatefulWidget> createState() {
    return FightState(match, fight);
  }
}

class FightState extends State<FightScreen> {
  final ClientTeamMatch match;
  final ClientFight fight;
  late ObservableStopwatch stopwatch;
  late ObservableStopwatch _fightStopwatch;
  late ObservableStopwatch _breakStopwatch;
  late ParticipantStateModel _r;
  late ParticipantStateModel _b;
  int round = 1;
  late Function(FightScreenActionIntent) callback;

  FightState(this.match, this.fight) {
    _r = ParticipantStateModel(fight.r);
    _b = ParticipantStateModel(fight.b);
    _r.injuryStopwatch.limit = match.injuryDuration;
    _r.injuryStopwatch.onEnd.stream.listen((event) {
      setState(() {
        _r.isInjury = false;
      });
      callback(FightScreenActionIntent.Horn());
    });
    _b.injuryStopwatch.limit = match.injuryDuration;
    _b.injuryStopwatch.onEnd.stream.listen((event) {
      setState(() {
        _b.isInjury = false;
      });
      callback(FightScreenActionIntent.Horn());
    });

    stopwatch = _fightStopwatch = ObservableStopwatch(
      limit: match.roundDuration * match.maxRounds,
    );
    _fightStopwatch.onStart.stream.listen((event) {
      _r.activityStopwatch?.start();
      _b.activityStopwatch?.start();
    });
    _fightStopwatch.onStop.stream.listen((event) {
      _r.activityStopwatch?.stop();
      _b.activityStopwatch?.stop();
    });
    _fightStopwatch.onAdd.stream.listen((event) {
      _r.activityStopwatch?.addDuration(event);
      _b.activityStopwatch?.addDuration(event);
    });
    _fightStopwatch.onChangeSecond.stream.listen(
      (event) {
        if (stopwatch == _fightStopwatch) {
          fight.duration = event;

          if (fight.duration.compareTo(match.roundDuration * round) >= 0) {
            _fightStopwatch.stop();
            if (_r.activityStopwatch != null) {
              _r.activityStopwatch!.dispose();
              _r.activityStopwatch = null;
            }
            if (_b.activityStopwatch != null) {
              _b.activityStopwatch!.dispose();
              _b.activityStopwatch = null;
            }
            callback(FightScreenActionIntent.Horn());
            if (round < match.maxRounds) {
              setState(() {
                stopwatch = _breakStopwatch;
              });
              _breakStopwatch.start();
              round++;
            }
          } else if (fight.duration.inSeconds ~/ match.roundDuration.inSeconds < (round - 1)) {
            // Fix times below round time: e.g. if subtract time
            round -= 1;
          }
        }
      },
    );
    stopwatch.addDuration(fight.duration);
    _breakStopwatch = ObservableStopwatch(
      limit: match.breakDuration,
    );
    _breakStopwatch.onEnd.stream.listen((event) {
      if (stopwatch == _breakStopwatch) {
        _breakStopwatch.reset();
        setState(() {
          stopwatch = _fightStopwatch;
        });
        callback(FightScreenActionIntent.Horn());
      }
    });
    callback = (FightScreenActionIntent intent) {
      FightActionHandler.handleIntentStatic(intent, stopwatch, match, fight, doAction, context: context);
    };
  }

  displayName(ClientParticipantState? pStatus, double padding, double cellHeight, double fontSizeDefault) {
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
      Container(
          height: cellHeight,
          child: Center(
              child: Text(
                  (pStatus?.participation.weight != null
                      ? '${pStatus?.participation.weight!.toStringAsFixed(1)} $weightUnit'
                      : AppLocalizations.of(context)!.participantUnknownWeight),
                  style: TextStyle(
                      fontSize: fontSizeDefault, color: pStatus?.participation.weight == null ? Colors.white30 : Colors.white)))),
    ]));
  }

  displayClassificationPoints(ClientParticipantState? pStatus, MaterialColor color, double padding, double cellHeight) {
    return Consumer<ClientParticipantState?>(
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
    return Expanded(flex: 33, child: TechnicalPoints(pStatusModel: pStatus, height: cellHeight, role: role));
  }

  displayParticipant(ClientParticipantState? pStatus, FightRole role, double padding, double cellHeight, double fontSize) {
    var color = getColorFromFightRole(role);
    List<Widget> items = [
      displayName(pStatus, padding, cellHeight, fontSize),
      displayClassificationPoints(pStatus, color, padding, cellHeight),
    ];
    if (role == FightRole.blue) items = List.from(items.reversed);
    return ChangeNotifierProvider.value(
      value: pStatus,
      child: Container(
        color: color,
        child: IntrinsicHeight(
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: items),
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
              psm.activityStopwatch == null ? ObservableStopwatch(limit: match.activityDuration) : null;
        });
        if (psm.activityStopwatch != null && _fightStopwatch.isRunning) psm.activityStopwatch!.start();
        psm.activityStopwatch?.onEnd.stream.listen((event) {
          callback(FightScreenActionIntent.Horn());
          psm.activityStopwatch?.dispose();
          setState(() {
            psm.activityStopwatch = null;
          });
          callback(FightScreenActionIntent.Horn());
        });
        break;
      case FightScreenActions.RedInjuryTime:
        ParticipantStateModel psm = _r;
        setState(() {
          psm.isInjury = !psm.isInjury;
        });
        if (psm.isInjury)
          psm.injuryStopwatch.start();
        else {
          psm.injuryStopwatch.stop();
        }
        break;
      case FightScreenActions.BlueActivityTime:
        ParticipantStateModel psm = _b;
        psm.activityStopwatch?.dispose();
        setState(() {
          psm.activityStopwatch =
              psm.activityStopwatch == null ? ObservableStopwatch(limit: match.activityDuration) : null;
        });
        if (psm.activityStopwatch != null && _fightStopwatch.isRunning) psm.activityStopwatch!.start();
        psm.activityStopwatch?.onEnd.stream.listen((event) {
          psm.activityStopwatch?.dispose();
          setState(() {
            psm.activityStopwatch = null;
          });
          callback(FightScreenActionIntent.Horn());
        });
        break;
      case FightScreenActions.BlueInjuryTime:
        ParticipantStateModel psm = _b;
        setState(() {
          psm.isInjury = !psm.isInjury;
        });
        if (psm.isInjury)
          psm.injuryStopwatch.start();
        else {
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
      fight: fight,
      doAction: doAction,
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          child: Row(children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ]),
        ),
        body: MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: match),
            ChangeNotifierProvider.value(value: fight),
          ],
          child: SingleChildScrollView(
            child: Column(
              children: [
                row(padding: bottomPadding, children: CommonElements.getTeamHeader(match, context)),
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
                                        '${AppLocalizations.of(context)!.fight} ${match.fights.indexOf(this.fight) + 1}',
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
                        child: Container(height: cellHeightClock, child: FightActionControls(FightRole.red, callback))),
                    Expanded(
                        flex: 50,
                        child: Container(
                          height: cellHeightClock,
                          child: Center(child: TimeDisplay(stopwatch, stopwatchColor)),
                        )),
                    Expanded(
                        flex: 2,
                        child:
                        Container(height: cellHeightClock, child: FightActionControls(FightRole.blue, callback))),
                    displayTechnicalPoints(_b, FightRole.blue, cellHeightClock),
                  ],
                ),
                Container(
                  padding: bottomPadding,
                  child: Consumer<ClientFight>(
                    builder: (context, data, child) => ActionsWidget(fight.actions),
                  ),
                ),
                Container(padding: bottomPadding, child: FightMainControls(callback, this)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _fightStopwatch.dispose();
    _breakStopwatch.dispose();
  }
}
