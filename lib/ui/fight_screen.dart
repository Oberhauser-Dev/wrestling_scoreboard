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
  late StopWatchTimer _stopwatch;
  String _currentTime = '0:00';
  int _presetSecondsPrev = 0;

  FightState(this.match, this.fight) {
    _stopwatch = StopWatchTimer(
        mode: StopWatchMode.countUp,
        onChangeRawSecond: (value) {
          int tmpVal;
          if (!_stopwatch.isRunning) {
            tmpVal = fight.duration.inSeconds + (value - _presetSecondsPrev);
            _presetSecondsPrev = value;
          } else {
            tmpVal = value;
          }
          fight.duration = Duration(seconds: tmpVal);
          setState(() {
            _currentTime = StopWatchTimer.getDisplayTime(tmpVal * 1000,
                    minute: true, second: true, milliSecond: false, hours: false)
                .replaceFirst(RegExp(r'^0'), '');
          });
        });
    _stopwatch.setPresetTime(
      mSec: fight.duration.inMilliseconds,
    );
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
                  style: TextStyle(fontSize: fontSizeDefault)))),
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
    Function(FightScreenActionIntent) callback = (FightScreenActionIntent intent) {
      FightActionHandler.handleIntentStatic(intent, _stopwatch, match, fight, context: context);
    };
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
          'S',
          () =>
              callback(isRed ? const FightScreenActionIntent.RedDismissal() : FightScreenActionIntent.BlueDismissal()),
          color,
          padding), // TODO not correct?
      displayActionControl(
          'P',
          () =>
              callback(isRed ? const FightScreenActionIntent.RedPassivity() : FightScreenActionIntent.BluePassivity()),
          color,
          padding),
      displayActionControl(
          'V',
          () => callback(isRed ? const FightScreenActionIntent.RedCaution() : FightScreenActionIntent.BlueCaution()),
          color,
          padding),
      displayActionControl(
          '<',
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
                          Container(
                              padding: EdgeInsets.all(padding),
                              child: Center(
                                  child: Text(
                                    'Kampf ${match.fights.indexOf(this.fight) + 1}',
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
                            style: TextStyle(fontSize: fontSizeClock),
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
