import 'package:common/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wrestling_scoreboard/data/fight.dart';
import 'package:wrestling_scoreboard/data/fight_result.dart';
import 'package:wrestling_scoreboard/data/fight_role.dart';
import 'package:wrestling_scoreboard/data/participant_status.dart';
import 'package:wrestling_scoreboard/data/team_match.dart';
import 'package:wrestling_scoreboard/data/wrestling_style.dart';
import 'package:wrestling_scoreboard/ui/fight/fight_screen.dart';
import 'package:common/src/util/date_time.dart';
import 'package:wrestling_scoreboard/util/units.dart';

import '../components/fitted_text.dart';
import 'common_elements.dart';

class MatchSequence extends StatelessWidget {
  late ClientTeamMatch match;

  MatchSequence(this.match);

  handleSelectedFight(ClientFight fight, BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => FightScreen(match, fight)));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double padding = width / 100;
    int flexWidthWeight = 12;
    int flexWidthStyle = 5;
    var fights = match.fights;
    return Scaffold(
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
        body: ChangeNotifierProvider.value(
          value: match,
          child: Column(children: [
            Column(children: [
              Row(children: [
                Expanded(
                  flex: flexWidthWeight + flexWidthStyle,
                  child: Container(
                    child: FittedText(
                        '${match.league}\n${AppLocalizations.of(context)!.fightNo}: ${match.id ?? ''}\n${AppLocalizations.of(context)!.refereeAbbr}: ${match.referee.fullName}'),
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
                    return FightListItem(
                        fight, (fight) => handleSelectedFight(fight, context), flexWidthWeight, flexWidthStyle);
                  }),
            ),
          ]),
        ));
  }
}

class FightListItem extends StatelessWidget {
  ClientFight fight;
  late Function(ClientFight) listItemCallback;
  int flexWidthWeight = 12;
  int flexWidthStyle = 5;

  FightListItem(this.fight, this.listItemCallback, this.flexWidthWeight, this.flexWidthStyle);

  displayName(ClientParticipantStatus? pStatus, FightRole role, double fontSize, BuildContext context) {
    return Container(
      color: getColorFromFightRole(role),
      child: Center(
          child: Text(
        pStatus == null ? AppLocalizations.of(context)!.participantVacant : pStatus.membership.person.fullName,
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

    return ChangeNotifierProvider.value(
        value: fight,
        child: Column(children: [
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
                            child: Text(
                                '${fight.weightClass.style == WrestlingStyle.free ? AppLocalizations.of(context)!.freeStyleAbbr : AppLocalizations.of(context)!.grecoRomanAbbr}',
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
                              child: displayName(fight.r, FightRole.red, fontSizeDefault, context),
                            ),
                            Consumer<ClientParticipantStatus?>(
                              builder: (context, data, child) => Expanded(
                                flex: 5,
                                child: Column(children: [
                                  Expanded(
                                      flex: 70,
                                      child: Container(
                                        color: fight.winner == FightRole.red ? Colors.red.shade800 : null,
                                        child: Center(
                                          child: Text(data?.classificationPoints?.toString() ?? '-',
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
                                                child: data?.classificationPoints != null
                                                    ? Text(data!.technicalPoints.toString(),
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
                      child: Consumer<ClientFight>(
                          builder: (context, data, child) => Column(
                                children: [
                                  Expanded(
                                      flex: 70,
                                      child: Container(
                                        color:
                                            data.winner != null ? getColorFromFightRole(data.winner!).shade800 : null,
                                        child: Center(
                                          child: Text(getAbbreviationFromFightResult(data.result, context),
                                              style: TextStyle(fontSize: fontSizeDefault * 0.7)),
                                        ),
                                      )),
                                  Expanded(
                                      flex: 50,
                                      child: Container(
                                        child: Center(
                                          child: data.winner != null
                                              ? Text(durationToString(data.duration),
                                                  style: TextStyle(fontSize: fontSizeDefault / 2))
                                              : null,
                                        ),
                                      )),
                                ],
                              ))),
                  Expanded(
                    flex: 55,
                    child: ChangeNotifierProvider.value(
                      value: fight.b,
                      child: Row(children: [
                        Consumer<ClientParticipantStatus?>(
                          builder: (context, data, child) => Expanded(
                            flex: 5,
                            child: Column(children: [
                              Expanded(
                                  flex: 70,
                                  child: Container(
                                    color: fight.winner == FightRole.blue ? Colors.blue.shade800 : null,
                                    child: Center(
                                      child:
                                          Text(data?.classificationPoints?.toString() ?? '-', style: fontStyleDefault),
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
                                            child: data?.classificationPoints != null
                                                ? Text(data!.technicalPoints.toString(),
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
                          child: displayName(fight.b, FightRole.blue, fontSizeDefault, context),
                        )
                      ]),
                    ),
                  ),
                ]),
              )),
          Divider(
            height: 1,
          ),
        ]));
  }
}
