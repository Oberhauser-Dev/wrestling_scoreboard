import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wrestling_scoreboard/data/fight.dart';
import 'package:wrestling_scoreboard/data/fight_role.dart';
import 'package:wrestling_scoreboard/data/participant_status.dart';
import 'package:wrestling_scoreboard/data/team_match.dart';
import 'package:wrestling_scoreboard/data/wrestling_style.dart';
import 'package:wrestling_scoreboard/ui/fight/fight_action_conrols.dart';
import 'package:wrestling_scoreboard/ui/fight/fight_shortcuts.dart';
import 'package:wrestling_scoreboard/ui/fight/technical_points.dart';
import 'package:wrestling_scoreboard/ui/fight/time_display.dart';
import 'package:wrestling_scoreboard/ui/models/participant_status_model.dart';
import 'package:wrestling_scoreboard/util/colors.dart';
import 'package:wrestling_scoreboard/util/date_time.dart';
import 'package:wrestling_scoreboard/util/units.dart';

import '../common_elements.dart';
import '../components/FittedText.dart';
import 'fight_actions.dart';

class FightScreen extends StatefulWidget {
  final TeamMatch match;
  final Fight fight;

  FightScreen(this.match, this.fight);

  @override
  State<StatefulWidget> createState() {
    return FightState(match, fight);
  }
}

class FightState extends State<FightScreen> {
  final TeamMatch match;
  final Fight fight;
  late ObservableStopwatch _stopwatch;
  late ObservableStopwatch _fightStopwatch;
  late ObservableStopwatch _breakStopwatch;
  late ParticipantStatusModel _r;
  late ParticipantStatusModel _b;
  int round = 1;
  late Function(FightScreenActionIntent) callback;

  FightState(this.match, this.fight) {
    _r = ParticipantStatusModel(fight.r);
    _b = ParticipantStatusModel(fight.b);
    _stopwatch = _fightStopwatch = ObservableStopwatch(
      limit: match.roundDuration * match.maxRounds,
    );
    _fightStopwatch.onStart.stream.listen((event) {
      if (_r.activityStopwatch != null) _r.activityStopwatch!.start();
      if (_b.activityStopwatch != null) _b.activityStopwatch!.start();
    });
    _fightStopwatch.onStop.stream.listen((event) {
      if (_r.activityStopwatch != null) _r.activityStopwatch!.stop();
      if (_b.activityStopwatch != null) _b.activityStopwatch!.stop();
    });
    _fightStopwatch.onChangeSecond.stream.listen(
      (event) {
        if (_stopwatch == _fightStopwatch) {
          fight.duration = event;

          if (fight.duration.compareTo(match.roundDuration * round) >= 0) {
            _fightStopwatch.stop();
            if (_r.activityStopwatch != null) {
              _r.activityStopwatch!.stop();
              _r.activityStopwatch = null;
            }
            if (_b.activityStopwatch != null) {
              _b.activityStopwatch!.stop();
              _b.activityStopwatch = null;
            }
            if (round < match.maxRounds) {
              setState(() {
                _stopwatch = _breakStopwatch;
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
    _stopwatch.addDuration(fight.duration);
    _breakStopwatch = ObservableStopwatch(
      limit: match.breakDuration,
    );
    _breakStopwatch.onEnd.stream.listen((event) {
      if (_stopwatch == _breakStopwatch) {
        _breakStopwatch.reset();
        setState(() {
          _stopwatch = _fightStopwatch;
        });
      }
    });
    callback = (FightScreenActionIntent intent) {
      FightActionHandler.handleIntentStatic(intent, _stopwatch, match, fight, doAction, context: context);
    };
  }

  displayName(ParticipantStatus? pStatus, double padding, double cellHeight, double fontSizeDefault) {
    return Expanded(
        child: Column(children: [
      Container(
          padding: EdgeInsets.all(padding),
          height: cellHeight * 2,
          child: Center(
              child: FittedText(
            pStatus?.participant.fullName ?? 'Unbesetzt',
            style: TextStyle(color: pStatus == null ? Colors.white30 : Colors.white),
          ))),
      Container(
          height: cellHeight,
          child: Center(
              child: Text((pStatus?.weight != null ? '${pStatus?.weight} $weightUnit' : 'Unknown weight'),
                  // + ' | ' +
                  // (pStatus?.participant.age != null
                  //     ? '${pStatus?.participant.age} years'
                  //     : 'Unknown age'),
                  style: TextStyle(
                      fontSize: fontSizeDefault, color: pStatus?.weight == null ? Colors.white30 : Colors.white)))),
    ]));
  }

  displayTechnicalPoints(ParticipantStatusModel pStatus, FightRole role, double cellHeight) {
    return Expanded(flex: 30, child: TechnicalPoints(pStatusModel: pStatus, height: cellHeight, role: role));
  }

  displayClassificationPoints(ParticipantStatus? pStatus, MaterialColor color, double padding, double cellHeight) {
    return pStatus?.classificationPoints != null
        ? Container(
            color: color.shade800,
            height: cellHeight * 3,
            padding: EdgeInsets.symmetric(vertical: padding * 4, horizontal: padding),
            child: FittedText(
              pStatus!.classificationPoints.toString(),
            ),
          )
        : Container();
  }

  doAction(FightScreenActions action) {
    switch (action) {
      case FightScreenActions.RedActivityTime:
        _r.activityStopwatch = _r.activityStopwatch == null ? ObservableStopwatch() : null;
        break;
      case FightScreenActions.RedInjuryTime:
        _r.injuryStopwatch = _r.injuryStopwatch == null ? ObservableStopwatch() : null;
        break;
      case FightScreenActions.RedActivityTime:
        _b.activityStopwatch = _b.activityStopwatch == null ? ObservableStopwatch() : null;
        break;
      case FightScreenActions.RedInjuryTime:
        _b.injuryStopwatch = _b.injuryStopwatch == null ? ObservableStopwatch() : null;
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double padding = width / 100;
    TextStyle fontStyleInfo = TextStyle(fontSize: width / 60);
    double cellHeight = width / 30;
    double fontSizeDefault = width / 90;
    double cellHeightClock = width / 6;

    MaterialColor stopwatchColor = _stopwatch == _breakStopwatch ? Colors.orange : white;

    return FightActionHandler(
      stopwatch: _stopwatch,
      match: match,
      fight: fight,
      doAction: doAction,
      child: Scaffold(
        body: ChangeNotifierProvider.value(
          value: fight,
          child: Column(
            children: [
              IntrinsicHeight(
                  child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...CommonElements.getTeamHeader(match, context),
                ],
              )),
              IntrinsicHeight(
                  child: Container(
                padding: EdgeInsets.symmetric(vertical: padding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                        flex: 50,
                        child: Container(
                            color: Colors.red,
                            child: IntrinsicHeight(
                                child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                              displayName(fight.r, padding, cellHeight, fontSizeDefault),
                              displayClassificationPoints(fight.r, Colors.red, padding, cellHeight),
                            ])))),
                    Expanded(
                        flex: 20,
                        child: Column(children: [
                          Row(children: [
                            match.fights.first == fight
                                ? IconButton(
                                    color: Colors.white24,
                                    icon: Icon(Icons.close),
                                    onPressed: () {
                                      callback(FightScreenActionIntent.Quit());
                                    },
                                  )
                                : IconButton(
                                    color: Colors.white24,
                                    icon: Icon(Icons.arrow_back),
                                    onPressed: () {
                                      callback(FightScreenActionIntent.PreviousFight());
                                    },
                                  ),
                            Expanded(
                                child: Container(
                                    padding: EdgeInsets.all(padding),
                                    child: Center(
                                        child: Text(
                                      'Kampf ${match.fights.indexOf(this.fight) + 1}',
                                      style: fontStyleInfo,
                                    )))),
                            match.fights.last == fight
                                ? IconButton(
                                    color: Colors.white24,
                                    icon: Icon(Icons.close),
                                    onPressed: () {
                                      callback(FightScreenActionIntent.Quit());
                                    },
                                  )
                                : IconButton(
                                    color: Colors.white24,
                                    icon: Icon(Icons.arrow_forward),
                                    onPressed: () {
                                      callback(FightScreenActionIntent.NextFight());
                                    },
                                  ),
                          ]),
                          Container(
                              padding: EdgeInsets.all(padding),
                              child: Center(
                                  child: Text(
                                '${styleToString(fight.weightClass.style)}',
                                style: fontStyleInfo,
                              ))),
                          Container(
                              padding: EdgeInsets.all(padding),
                              child: Center(
                                  child: Text(
                                fight.weightClass.name ?? 'Unknown',
                                style: fontStyleInfo,
                              ))),
                        ])),
                    Expanded(
                        flex: 50,
                        child: Container(
                            color: Colors.blue,
                            child: IntrinsicHeight(
                                child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                              if (fight.b?.classificationPoints != null)
                                Container(
                                  color: Colors.blue.shade800,
                                  height: cellHeight * 3,
                                  padding: EdgeInsets.symmetric(vertical: padding * 4, horizontal: padding),
                                  child: FittedText(
                                    fight.b!.classificationPoints.toString(),
                                  ),
                                ),
                              displayName(fight.b, padding, cellHeight, fontSizeDefault),
                            ])))),
                  ],
                ),
              )),
              Row(
                children: [
                  displayTechnicalPoints(_r, FightRole.red, cellHeightClock),
                  Expanded(
                      flex: 2,
                      child: Container(height: cellHeightClock, child: FightActionControls(FightRole.red, callback))),
                  Expanded(
                      flex: 60,
                      child: Container(
                        height: cellHeightClock,
                        child: Center(child: TimeDisplay(_stopwatch, stopwatchColor)),
                      )),
                  Expanded(
                      flex: 2,
                      child: Container(height: cellHeightClock, child: FightActionControls(FightRole.blue, callback))),
                  displayTechnicalPoints(_b, FightRole.blue, cellHeightClock),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: padding),
                child: Consumer<Fight>(
                  builder: (context, cart, child) => ActionsWidget(fight.actions),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
