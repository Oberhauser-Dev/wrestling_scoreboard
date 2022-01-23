import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wrestling_scoreboard/data/fight_role.dart';
import 'package:wrestling_scoreboard/data/wrestling_style.dart';
import 'package:wrestling_scoreboard/ui/components/consumer.dart';
import 'package:wrestling_scoreboard/ui/fight/fight_action_conrols.dart';
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
import 'fight_controls.dart';

void navigateToFightScreen(BuildContext context, TeamMatch match, int index) async {
  final fight = match.ex_fights[index];
  fight.ex_actions = await dataProvider.readMany<FightAction>(filterObject: fight);
  Navigator.push(context, MaterialPageRoute(builder: (context) => FightScreen(match, index)));
}

class FightScreen extends StatefulWidget {
  final TeamMatch match;
  final int fightIndex;

  const FightScreen(this.match, this.fightIndex, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => FightState();
}

class FightState extends State<FightScreen> {
  late TeamMatch match;
  late Fight fight;
  late int fightIndex;
  late ObservableStopwatch stopwatch;
  late ObservableStopwatch _fightStopwatch;
  late ObservableStopwatch _breakStopwatch;
  late ParticipantStateModel _r;
  late ParticipantStateModel _b;
  int round = 1;
  late Function(FightScreenActionIntent) callback;

  @override
  initState() {
    super.initState();
    HornSound();
    match = widget.match;
    fightIndex = widget.fightIndex;
    fight = widget.match.ex_fights[fightIndex];
    _r = ParticipantStateModel(fight.r);
    _b = ParticipantStateModel(fight.b);
    _r.injuryStopwatch.limit = match.injuryDuration;
    _r.injuryStopwatch.onEnd.stream.listen((event) {
      setState(() {
        _r.isInjury = false;
      });
      callback(const FightScreenActionIntent.Horn());
    });
    _b.injuryStopwatch.limit = match.injuryDuration;
    _b.injuryStopwatch.onEnd.stream.listen((event) {
      setState(() {
        _b.isInjury = false;
      });
      callback(const FightScreenActionIntent.Horn());
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
            callback(const FightScreenActionIntent.Horn());
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
        callback(const FightScreenActionIntent.Horn());
      }
    });
    callback = (FightScreenActionIntent intent) {
      FightActionHandler.handleIntentStatic(intent, stopwatch, match, fightIndex, doAction, context: context);
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
    return Expanded(flex: 33, child: TechnicalPoints(pStatusModel: pStatus, height: cellHeight, role: role));
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
              psm.activityStopwatch == null ? ObservableStopwatch(limit: match.activityDuration) : null;
        });
        if (psm.activityStopwatch != null && _fightStopwatch.isRunning) psm.activityStopwatch!.start();
        psm.activityStopwatch?.onEnd.stream.listen((event) {
          callback(const FightScreenActionIntent.Horn());
          psm.activityStopwatch?.dispose();
          setState(() {
            psm.activityStopwatch = null;
          });
          callback(const FightScreenActionIntent.Horn());
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
              psm.activityStopwatch == null ? ObservableStopwatch(limit: match.activityDuration) : null;
        });
        if (psm.activityStopwatch != null && _fightStopwatch.isRunning) psm.activityStopwatch!.start();
        psm.activityStopwatch?.onEnd.stream.listen((event) {
          psm.activityStopwatch?.dispose();
          setState(() {
            psm.activityStopwatch = null;
          });
          callback(const FightScreenActionIntent.Horn());
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
        body: StreamProvider<Fight>(
          create: (context) => dataProvider.streamSingle<Fight>(fight.id!, init: false),
          initialData: fight,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SingleConsumer<TeamMatch>(
                  id: match.id!,
                  initialData: match,
                  builder: (context, match) {
                    return row(padding: bottomPadding, children: CommonElements.getTeamHeader(match!, context));
                  },
                ),
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
                        child: SizedBox(height: cellHeightClock, child: FightActionControls(FightRole.red, callback))),
                    Expanded(
                        flex: 50,
                        child: SizedBox(
                          height: cellHeightClock,
                          child: Center(child: TimeDisplay(stopwatch, stopwatchColor)),
                        )),
                    Expanded(
                        flex: 2,
                        child: SizedBox(height: cellHeightClock, child: FightActionControls(FightRole.blue, callback))),
                    displayTechnicalPoints(_b, FightRole.blue, cellHeightClock),
                  ],
                ),
                Container(
                  padding: bottomPadding,
                  child: Consumer<Fight>(
                    builder: (context, data, child) => ActionsWidget(fight.ex_actions),
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
  void dispose() async {
    super.dispose();
    await HornSound().dispose();
    _fightStopwatch.dispose();
    _breakStopwatch.dispose();
  }
}
