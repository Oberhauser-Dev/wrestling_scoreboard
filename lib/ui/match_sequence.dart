import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wrestling_scoreboard/data/fight.dart';
import 'package:wrestling_scoreboard/data/fight_result.dart';
import 'package:wrestling_scoreboard/data/fight_role.dart';
import 'package:wrestling_scoreboard/data/participant_status.dart';
import 'package:wrestling_scoreboard/data/team_match.dart';
import 'package:wrestling_scoreboard/data/wrestling_style.dart';
import 'package:wrestling_scoreboard/util/date_time.dart';
import 'package:wrestling_scoreboard/util/units.dart';

import 'common_elements.dart';
import 'components/FittedText.dart';

class MatchSequence extends StatelessWidget {
  late TeamMatch match;
  late Function(Fight) listItemCallback;

  MatchSequence(this.match, this.listItemCallback);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double padding = width / 100;
    int flexWidthWeight = 12;
    int flexWidthStyle = 5;
    var fights = match.fights;
    return Scaffold(
      body: Column(children: [
        Column(children: [
          Row(children: [
            Expanded(
              flex: flexWidthWeight + flexWidthStyle,
              child: Container(
                child: FittedText('${match.league}\nNo: ${match.id ?? ''}\nSR: ${match.referee.fullName}'),
                padding: EdgeInsets.all(padding),
              ),
            ),
            ...CommonElements.getTeamHeader(match, context),
          ]),
          Divider(
            height: 1,
          ),
        ]),
        Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: fights.length,
              itemBuilder: (context, index) {
                var fight = fights[index];
                return FightListItem(fight, listItemCallback, flexWidthWeight, flexWidthStyle);
              }),
        ),
      ]),
    );
  }
}

class FightListItem extends StatelessWidget {
  Fight fight;
  late Function(Fight) listItemCallback;
  int flexWidthWeight = 12;
  int flexWidthStyle = 5;

  FightListItem(this.fight, this.listItemCallback, this.flexWidthWeight, this.flexWidthStyle);

  displayName(ParticipantStatus? pStatus, FightRole role, double fontSize) {
    return Container(
      color: getColorFromFightRole(role),
      child: Center(
          child: Text(
        pStatus == null ? 'Unbesetzt' : pStatus.participant.fullName,
        style: TextStyle(color: pStatus == null ? Colors.white30 : Colors.white, fontSize: fontSize),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double padding = width / 100;
    EdgeInsets edgeInsets = EdgeInsets.all(padding);
    double fontSizeDefault = width / 60;
    TextStyle fontStyleDefault = TextStyle(fontSize: fontSizeDefault);

    return Column(children: [
      InkWell(
          onTap: () {
            listItemCallback(fight);
          },
          child: IntrinsicHeight(
            child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Expanded(
                  flex: flexWidthWeight,
                  child: Container(
                    padding: edgeInsets,
                    child: Center(child: Text('${fight.weightClass.weight} $weightUnit', style: fontStyleDefault)),
                  )),
              Expanded(
                  flex: flexWidthStyle,
                  child: Container(
                    child: Center(
                        child: Text('${fight.weightClass.style == WrestlingStyle.free ? 'F' : 'G'}',
                            style: fontStyleDefault)),
                  )),
              Expanded(
                  flex: 55,
                  child: ChangeNotifierProvider.value(
                    value: fight.r,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 50,
                          child: displayName(fight.r, FightRole.red, fontSizeDefault),
                        ),
                        Consumer<ParticipantStatus?>(
                          builder: (context, cart, child) => Expanded(
                            flex: 5,
                            child: Column(children: [
                              Expanded(
                                  flex: 70,
                                  child: Container(
                                    color: fight.winner == FightRole.red ? Colors.red.shade800 : null,
                                    child: Center(
                                      child: Text(fight.r?.classificationPoints?.toString() ?? '-',
                                          style: fontStyleDefault),
                                    ),
                                  )),
                              Expanded(
                                  flex: 50,
                                  child: Row(children: [
                                    Expanded(
                                        flex: 50,
                                        child: Container(
                                          color: fight.winner == FightRole.red ? Colors.red.shade800 : null,
                                          child: Center(
                                            child: fight.r?.classificationPoints != null
                                                ? Text(fight.r!.technicalPoints.toString(),
                                                    style: TextStyle(fontSize: fontSizeDefault / 2))
                                                : null,
                                          ),
                                        )),
                                  ])),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  )),
              Expanded(
                  flex: 10,
                  child: Column(
                    children: [
                      Expanded(
                          flex: 70,
                          child: Container(
                            color: fight.winner != null ? getColorFromFightRole(fight.winner!).shade800 : null,
                            child: Center(
                              child: Text(getStringFromFightResult(fight.result),
                                  style: TextStyle(fontSize: fontSizeDefault * 0.7)),
                            ),
                          )),
                      Expanded(
                          flex: 50,
                          child: Container(
                            child: Center(
                              child: fight.winner != null
                                  ? Text(durationToString(fight.duration),
                                      style: TextStyle(fontSize: fontSizeDefault / 2))
                                  : null,
                            ),
                          )),
                    ],
                  )),
              Expanded(
                flex: 55,
                child: ChangeNotifierProvider.value(
                  value: fight.r,
                  child: Row(children: [
                    Consumer<ParticipantStatus?>(
                      builder: (context, cart, child) => Expanded(
                        flex: 5,
                        child: Column(children: [
                          Expanded(
                              flex: 70,
                              child: Container(
                                color: fight.winner == FightRole.blue ? Colors.blue.shade800 : null,
                                child: Center(
                                  child:
                                      Text(fight.b?.classificationPoints?.toString() ?? '-', style: fontStyleDefault),
                                ),
                              )),
                          Expanded(
                              flex: 50,
                              child: Row(children: [
                                Expanded(
                                    flex: 50,
                                    child: Container(
                                      color: fight.winner == FightRole.blue ? Colors.blue.shade800 : null,
                                      child: Center(
                                        child: fight.b?.classificationPoints != null
                                            ? Text(fight.b!.technicalPoints.toString(),
                                                style: TextStyle(fontSize: fontSizeDefault / 2))
                                            : null,
                                      ),
                                    )),
                              ])),
                        ]),
                      ),
                    ),
                    Expanded(
                      flex: 50,
                      child: displayName(fight.b, FightRole.blue, fontSizeDefault),
                    )
                  ]),
                ),
              ),
            ]),
          )),
      Divider(
        height: 1,
      ),
    ]);
  }
}
