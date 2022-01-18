import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wrestling_scoreboard/data/fight.dart';
import 'package:wrestling_scoreboard/data/fight_result.dart';
import 'package:wrestling_scoreboard/data/fight_role.dart';
import 'package:wrestling_scoreboard/data/participant_state.dart';
import 'package:wrestling_scoreboard/data/team_match.dart';
import 'package:wrestling_scoreboard/ui/components/consumer.dart';
import 'package:wrestling_scoreboard/ui/fight/fight_screen.dart';
import 'package:wrestling_scoreboard/ui/match/team_match_overview.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';
import 'package:wrestling_scoreboard/util/units.dart';

import '../components/fitted_text.dart';
import 'common_elements.dart';

class MatchSequence extends StatelessWidget {
  final ClientTeamMatch filterObject;

  const MatchSequence(this.filterObject, {Key? key}) : super(key: key);

  handleSelectedFight(ClientTeamMatch match, int fightIndex, BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => FightScreen(match, fightIndex)));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double padding = width / 100;
    int flexWidthWeight = 12;
    int flexWidthStyle = 5;
    return SingleConsumer<TeamMatch, ClientTeamMatch>(
      id: filterObject.id!,
      initialData: filterObject,
      builder: (BuildContext context, ClientTeamMatch match) {
        return Scaffold(
            bottomNavigationBar: BottomAppBar(
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.info),
                  onPressed: () =>
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TeamMatchOverview(match: match))),
                ),
              ]),
            ),
            body: ChangeNotifierProvider.value(
              value: match,
              child: StreamBuilder(
                  stream: dataProvider.streamMany<Fight, ClientFight>(filterObject: match),
                  builder: (BuildContext context, AsyncSnapshot<ManyDataObject<ClientFight>> snapshot) {
                    if (!snapshot.hasData) return const CircularProgressIndicator();
                    final fights = snapshot.data!.data.toList();
                    if (fights.isEmpty) {
                      dataProvider.generateFights(match);
                    }
                    match.fights = fights;
                    return Column(children: [
                      Column(children: [
                        Row(children: [
                          Expanded(
                            flex: flexWidthWeight + flexWidthStyle,
                            child: Container(
                              child: FittedText(
                                  '${match.league.name}\n${AppLocalizations.of(context)!.fightNo}: ${match.id ?? ''}\n${AppLocalizations.of(context)!.refereeAbbr}: ${match.referees.map((e) => e.fullName).join(', ')}'),
                              padding: EdgeInsets.all(padding),
                            ),
                          ),
                          ...CommonElements.getTeamHeader(match, context),
                        ]),
                        const Divider(
                          height: 1,
                        ),
                      ]),
                      Expanded(
                        child: ListView.builder(
                          itemCount: fights.length,
                          itemBuilder: (context, index) {
                            final ClientFight fight = fights.elementAt(index);
                            return FightListItem(fight, (fight) => handleSelectedFight(match, index, context),
                                flexWidthWeight: flexWidthWeight, flexWidthStyle: flexWidthStyle);
                          },
                        ),
                      ),
                    ]);
                  }),
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

  const FightListItem(this.fight, this.listItemCallback, {this.flexWidthWeight = 12, this.flexWidthStyle = 5, Key? key})
      : super(key: key);

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
                      child: Center(
                          child: Text(
                              fight.weightClass.style == WrestlingStyle.free
                                  ? AppLocalizations.of(context)!.freeStyleAbbr
                                  : AppLocalizations.of(context)!.grecoRomanAbbr,
                              style: fontStyleDefault))),
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
                                      child: Center(
                                        child: data.winner != null
                                            ? Text(durationToString(data.duration),
                                                style: TextStyle(fontSize: fontSizeDefault / 2))
                                            : null,
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
          const Divider(
            height: 1,
          ),
        ]));
  }
}
