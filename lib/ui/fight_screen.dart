import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:wrestling_scoreboard/data/fight.dart';
import 'package:wrestling_scoreboard/data/team_match.dart';
import 'package:wrestling_scoreboard/data/wrestling_style.dart';
import 'package:wrestling_scoreboard/ui/fight_shortcuts.dart';
import 'package:wrestling_scoreboard/util/units.dart';

import 'common_elements.dart';
import 'components/FittedText.dart';

class FightScreen extends StatefulWidget {
  late TeamMatch match;
  late Fight fight;

  FightScreen(this.match, this.fight);

  @override
  State<StatefulWidget> createState() {
    return FightState(match, fight);
  }
}

class FightState extends State<FightScreen> {
  late TeamMatch match;
  late Fight fight;
  late StopWatchTimer _stopwatch;
  String _currentTime = '0:00';

  FightState(this.match, this.fight) {
    _stopwatch = StopWatchTimer(
        mode: StopWatchMode.countUp,
        onChangeRawSecond: (value) {
          fight.duration = Duration(seconds: value);
          setState(() {
            _currentTime = StopWatchTimer.getDisplayTime(value * 1000,
                    minute: true, second: true, milliSecond: false, hours: false)
                .replaceFirst(RegExp(r'^0'), '');
          });
        });
    _stopwatch.setPresetTime(
      mSec: fight.duration.inMilliseconds,
    );
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
    return FightShortCuts(
        toggleStopwatch: () {
          _stopwatch.isRunning
              ? _stopwatch.onExecute.add(StopWatchExecute.stop)
              : _stopwatch.onExecute.add(StopWatchExecute.start);
        },
        child: Scaffold(
          body: Column(
            children: [
              IntrinsicHeight(
                  child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...CommonElements.getTeamHeader(match, context),
                ],
              )),
              Row(
                children: [
                  Expanded(
                      flex: 50,
                      child: Container(
                          color: Colors.red,
                          child: Column(children: [
                            Container(
                                padding: EdgeInsets.all(padding),
                                height: cellHeight * 2,
                                child: Center(
                                    child: FittedText(
                                  fight.r?.participant.fullName ?? 'Unbesetzt',
                                  style: TextStyle(color: fight.r == null ? Colors.white30 : Colors.white),
                                ))),
                            Container(
                                height: cellHeight,
                                child: Center(
                                    child: Text(
                                        (fight.r?.weight != null ? '${fight.r?.weight} $weightUnit' : 'Unknown weight'),
                                        // + ' | ' +
                                        // (fight.r?.participant.age != null
                                        //     ? '${fight.r?.participant.age} years'
                                        //     : 'Unknown age'),
                                        style: TextStyle(fontSize: fontSizeDefault)))),
                          ]))),
                  Expanded(
                      flex: 20,
                      child: Column(children: [
                        Container(
                            padding: EdgeInsets.all(padding),
                            child: Center(
                                child: Text(
                              'Kampf ${match.fights.indexOf(this.fight)}',
                              style: fontStyleInfo,
                            ))),
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
                              '${fight.weightClass.weight} $weightUnit',
                              style: fontStyleInfo,
                            ))),
                      ])),
                  Expanded(
                      flex: 50,
                      child: Container(
                          color: Colors.blue,
                          child: Column(children: [
                            Container(
                                padding: EdgeInsets.all(padding),
                                height: cellHeight * 2,
                                child: Center(
                                    child: FittedText(
                                  fight.b?.participant.fullName ?? 'Unbesetzt',
                                  style: TextStyle(color: fight.b == null ? Colors.white30 : Colors.white),
                                ))),
                            Container(
                                height: cellHeight,
                                child: Center(
                                    child: Text(
                                        (fight.b?.weight != null ? '${fight.b?.weight} $weightUnit' : 'Unknown weight'),
                                        // + ' | ' +
                                        // (fight.b?.participant.age != null
                                        //     ? '${fight.b?.participant.age} years'
                                        //     : 'Unknown age'),
                                        style: TextStyle(fontSize: fontSizeDefault)))),
                          ]))),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      flex: 30,
                      child: Container(
                          color: Colors.red,
                          height: cellHeightClock,
                          child: Center(
                              child: Text((fight.r?.technicalPoints ?? 0).toString(),
                                  style: TextStyle(fontSize: fontSizeClock))))),
                  Expanded(
                      flex: 60,
                      child: Container(
                          height: cellHeightClock,
                          child: Center(
                              child: Text(
                            _currentTime,
                            style: TextStyle(fontSize: fontSizeClock),
                          )))),
                  Expanded(
                      flex: 30,
                      child: Container(
                          color: Colors.blue,
                          height: cellHeightClock,
                          child: Center(
                              child: Text((fight.b?.technicalPoints ?? 0).toString(),
                                  style: TextStyle(fontSize: fontSizeClock))))),
                ],
              ),
            ],
          ),
        ));
  }
}
