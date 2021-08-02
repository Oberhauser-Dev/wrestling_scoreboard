import 'package:common/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wrestling_scoreboard/data/fight.dart';
import 'package:wrestling_scoreboard/data/fight_result.dart';
import 'package:wrestling_scoreboard/data/fight_role.dart';
import 'package:wrestling_scoreboard/data/participant_state.dart';
import 'package:wrestling_scoreboard/data/team_match.dart';
import 'package:wrestling_scoreboard/ui/fight/fight_screen.dart';
import 'package:wrestling_scoreboard/ui/lineup/edit_team_match.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';
import 'package:wrestling_scoreboard/util/units.dart';

import '../components/fitted_text.dart';
import 'common_elements.dart';

class MatchSequence extends StatelessWidget {
  final ClientTeamMatch match;

  MatchSequence(this.match);

  handleSelectedFight(ClientTeamMatch match, ClientFight fight, BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => FightScreen(match, fight)));
  }

  handleEditLineups(ClientTeamMatch match, BuildContext context) {
    final title = AppLocalizations.of(context)!.edit + ' ' + AppLocalizations.of(context)!.match;
    Navigator.push(context, MaterialPageRoute(builder: (context) => EditTeamMatch(title: title, match: match)));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double padding = width / 100;
    int flexWidthWeight = 12;
    int flexWidthStyle = 5;
    return StreamBuilder(
      stream: dataProvider.readSingleStream<TeamMatch>(match.id!),
      initialData: match,
      builder: (BuildContext context, AsyncSnapshot<TeamMatch> matchSnap) {
        if (matchSnap.hasError) {
          throw matchSnap.error!;
        }
        final match = matchSnap.data as ClientTeamMatch;
        return Scaffold(
            bottomNavigationBar: BottomAppBar(
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => handleEditLineups(match, context),
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
                            '${match.league}\n${AppLocalizations.of(context)!.fightNo}: ${match.id ?? ''}\n${AppLocalizations.of(context)!.refereeAbbr}: ${match.referees.map((e) => e.fullName).join(', ')}'),
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
                  child: StreamBuilder(
                    stream: dataProvider.readManyStream<Fight>(filterObject: match),
                    initialData: match.fights,
                    builder: (BuildContext context, AsyncSnapshot<List<Fight>> fightSnap) {
                      if (fightSnap.hasError) {
                        throw fightSnap.error!;
                      }
                      final fights = fightSnap.data as List<ClientFight>;
                      return ListView.builder(
                        itemCount: fights.length,
                        itemBuilder: (context, index) {
                          final fight = fights[index];
                          return FightListItem(fight, (fight) => handleSelectedFight(match, fight, context),
                              flexWidthWeight, flexWidthStyle);
                        },
                      );
                    },
                  ),
                ),
              ]),
            ));
      },
    );
  }
}

class FightListItem extends StatelessWidget {
  final ClientFight fight;
  final Function(ClientFight) listItemCallback;
  final int flexWidthWeight;
  final int flexWidthStyle;

  FightListItem(this.fight, this.listItemCallback, [this.flexWidthWeight = 12, this.flexWidthStyle = 5]);

  displayName(ClientParticipantState? pStatus, FightRole role, double fontSize, BuildContext context) {
    return Container(
      color: getColorFromFightRole(role),
      child: Center(
          child: Text(
        pStatus == null
            ? AppLocalizations.of(context)!.participantVacant
            : pStatus.participation.membership.person.fullName,
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
                            Consumer<ClientParticipantState?>(
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
                        Consumer<ClientParticipantState?>(
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
