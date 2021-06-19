import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:wrestling_scoreboard/data/fight.dart';
import 'package:wrestling_scoreboard/data/fight_action.dart';
import 'package:wrestling_scoreboard/data/fight_role.dart';
import 'package:wrestling_scoreboard/data/participant_status.dart';
import 'package:wrestling_scoreboard/data/team_match.dart';
import 'package:wrestling_scoreboard/data/wrestling_style.dart';
import 'package:wrestling_scoreboard/ui/fight_shortcuts.dart';
import 'package:wrestling_scoreboard/util/colors.dart';
import 'package:wrestling_scoreboard/util/date_time.dart';
import 'package:wrestling_scoreboard/util/units.dart';

import 'common_elements.dart';
import 'components/FittedText.dart';

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
  late CustomStopWatchTimer _stopwatch;
  late CustomStopWatchTimer _fightStopwatch;
  late CustomStopWatchTimer _breakStopwatch;
  late CustomStopWatchTimer _injuryRedStopwatch;
  late CustomStopWatchTimer _injuryBlueStopwatch;
  int passivityRedSeconds = 0;
  int passivityBlueSeconds = 0;
  String _currentTime = '0:00';
  int round = 1;
  late Function(FightScreenActionIntent) callback;

  FightState(this.match, this.fight) {
    _stopwatch = _fightStopwatch = CustomStopWatchTimer(
      mode: StopWatchMode.countUp,
      onChangeSecond: (val) {
        if (_stopwatch == _fightStopwatch) {
          // Only display if active
          fight.duration = updateDisplayTime(val * 1000);

          if (fight.duration.compareTo(match.roundDuration * round) >= 0) {
            _fightStopwatch.stop();
            if (round < match.maxRounds) {
              _stopwatch = _breakStopwatch;
              _breakStopwatch.start();
              round++;
            }
          } else if (fight.duration.inSeconds ~/ match.roundDuration.inSeconds < (round - 1)) {
            // Fix times below round time: e.g. if subtract time
            round -= 1;
          }
        }
      },
      onStartStop: onStartStop,
    );
    _stopwatch.addTime(millis: fight.duration.inMilliseconds);
    _breakStopwatch = CustomStopWatchTimer(
      mode: StopWatchMode.countUp,
      onChangeSecond: (val) {
        if (_stopwatch == _breakStopwatch) {
          // Only display if active
          var dur = updateDisplayTime(val * 1000);
          if (dur.compareTo(match.breakDuration) >= 0) {
            _breakStopwatch.reset();
            _stopwatch = _fightStopwatch;
            updateDisplayTime(_fightStopwatch.currentMillis); // Refresh old display
          }
        }
      },
      onStartStop: onStartStop,
    );
    callback = (FightScreenActionIntent intent) {
      FightActionHandler.handleIntentStatic(intent, _stopwatch, match, fight, context: context);
    };
  }

  onStartStop() {
    // Update color
    setState(() {
      _currentTime = _currentTime;
    });
  }

  Duration updateDisplayTime(int millis) {
    setState(() {
      _currentTime = StopWatchTimer.getDisplayTime(millis, minute: true, second: true, milliSecond: false, hours: false)
          .replaceFirst(RegExp(r'^0'), '');
    });

    return Duration(milliseconds: millis);
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

  displayTechnicalPoints(ParticipantStatus? pStatus, MaterialColor color, double cellHeight, double fontSize) {
    return Expanded(
        flex: 30,
        child: Container(
            color: color,
            height: cellHeight,
            child: Center(
              child: Consumer<Fight>(
                builder: (context, cart, child) =>
                    Text((pStatus?.technicalPoints ?? 0).toString(), style: TextStyle(fontSize: fontSize)),
              ),
            )));
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

  displayActionControls(FightRole role, double padding, double cellHeight, double fontSizeDefault) {
    bool isRed = role == FightRole.red;
    MaterialColor color = isRed ? Colors.red : Colors.blue;
    var actions = <Widget>[
      displayActionControl(
          '1',
          () => callback(isRed ? const FightScreenActionIntent.RedOne() : FightScreenActionIntent.BlueOne()),
          color,
          padding),
      displayActionControl(
          '2',
          () => callback(isRed ? const FightScreenActionIntent.RedTwo() : FightScreenActionIntent.BlueTwo()),
          color,
          padding),
      displayActionControl(
          '4',
          () => callback(isRed ? const FightScreenActionIntent.RedFour() : FightScreenActionIntent.BlueFour()),
          color,
          padding),
      displayActionControl(
          'P',
          () =>
              callback(isRed ? const FightScreenActionIntent.RedPassivity() : FightScreenActionIntent.BluePassivity()),
          color,
          padding),
      displayActionControl(
          'O',
          () => callback(isRed ? const FightScreenActionIntent.RedCaution() : FightScreenActionIntent.BlueCaution()),
          color,
          padding),
      /*displayActionControl(
          'D',
              () =>
              callback(isRed ? const FightScreenActionIntent.RedDismissal() : FightScreenActionIntent.BlueDismissal()),
          color,
          padding),*/
      displayActionControl(
          'AT', // AZ Activity Time, Aktivitätszeit
          () => callback(isRed ? const FightScreenActionIntent.RedCaution() : FightScreenActionIntent.BlueCaution()),
          color,
          padding),
      displayActionControl(
          'IT', // VZ Injury Time, Verletzungszeit
          () => callback(isRed ? const FightScreenActionIntent.RedCaution() : FightScreenActionIntent.BlueCaution()),
          color,
          padding),
      displayActionControl(
          '⎌',
          () => callback(isRed ? const FightScreenActionIntent.RedUndo() : FightScreenActionIntent.BlueUndo()),
          color,
          padding),
    ];
    return Expanded(
      flex: 2,
      child: Container(
          height: cellHeight,
          child: IntrinsicWidth(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: actions,
          ))),
    );
  }

  displayActionControl(String text, void Function() callback, MaterialColor color, double padding) {
    return Expanded(
        child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              primary: Colors.white,
              backgroundColor: color,
              side: BorderSide(color: color.shade900, width: 1),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
            ),
            onPressed: () => callback(),
            child: FittedText(text)));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double padding = width / 100;
    TextStyle fontStyleInfo = TextStyle(fontSize: width / 60);
    double cellHeight = width / 30;
    double fontSizeDefault = width / 90;
    double cellHeightClock = width / 6;
    double fontSizeClock = width / 9;

    MaterialColor stopwatchColor = _stopwatch == _breakStopwatch ? Colors.orange : white;

    return FightActionHandler(
      stopwatch: _stopwatch,
      match: match,
      fight: fight,
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
                  displayTechnicalPoints(fight.r, Colors.red, cellHeightClock, fontSizeClock),
                  displayActionControls(FightRole.red, padding, cellHeightClock, fontSizeDefault),
                  Expanded(
                      flex: 60,
                      child: Container(
                          height: cellHeightClock,
                          child: Center(
                              child: Text(
                                _currentTime,
                            style: TextStyle(
                                fontSize: fontSizeClock,
                                color: _stopwatch.isRunning ? stopwatchColor : stopwatchColor.shade200),
                          )))),
                  displayActionControls(FightRole.blue, padding, cellHeightClock, fontSizeDefault),
                  displayTechnicalPoints(fight.b, Colors.blue, cellHeightClock, fontSizeClock),
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

  @override
  void dispose() async {
    super.dispose();
    await _stopwatch.dispose();
  }
}

class ActionsWidget extends StatelessWidget {
  final List<FightAction> actions;

  ActionsWidget(this.actions) {
    actions.sort((a, b) => a.duration.compareTo(b.duration));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double padding = width / 100;
    double cellHeight = width / 18;

    return SingleChildScrollView(
      reverse: true,
      scrollDirection: Axis.horizontal,
      child: IntrinsicHeight(
        child: Row(
          children: [
            ...this.actions.map((e) {
              final color = e.role == FightRole.red ? Colors.red : Colors.blue;
              return Tooltip(
                  message: durationToString(e.duration),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 1),
                    height: cellHeight,
                    padding: EdgeInsets.all(padding),
                    child: FittedText(e.toString()),
                    color: color,
                  ));
            }),
          ],
        ),
      ),
    );
  }
}
