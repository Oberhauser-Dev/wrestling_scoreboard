import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/data/fight_result.dart';
import 'package:wrestling_scoreboard/data/fight_role.dart';
import 'package:wrestling_scoreboard/data/wrestling_style.dart';
import 'package:wrestling_scoreboard/ui/components/consumer.dart';
import 'package:wrestling_scoreboard/ui/fight/fight_screen.dart';
import 'package:wrestling_scoreboard/ui/overview/team_match_overview.dart';
import 'package:wrestling_scoreboard/util/units.dart';

import '../components/fitted_text.dart';
import 'common_elements.dart';

class MatchSequence extends StatelessWidget {
  final TeamMatch filterObject;

  const MatchSequence(this.filterObject, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double padding = width / 100;
    int flexWidthWeight = 12;
    int flexWidthStyle = 5;
    return SingleConsumer<TeamMatch>(
      id: filterObject.id!,
      initialData: filterObject,
      builder: (context, match) {
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TeamMatchOverview(match: match!))),
              ),
            ]),
          ),
          body: ManyConsumer<Fight>(
            filterObject: match,
            builder: (context, fights) {
              final matchInfos = [
                match!.league.name,
                '${AppLocalizations.of(context)!.fightNo}: ${match.id ?? ''}',
                if (match.referee != null) '${AppLocalizations.of(context)!.refereeAbbr}: ${match.referee?.fullName}',
                // Not enough space to display all three referees
                // if (match.matChairman != null)
                //   '${AppLocalizations.of(context)!.refereeAbbr}: ${match.matChairman?.fullName}',
                // if (match.judge != null) '${AppLocalizations.of(context)!.refereeAbbr}: ${match.judge?.fullName}',
              ];
              return Column(
                children: [
                  Column(children: [
                    Row(children: [
                      Expanded(
                        flex: flexWidthWeight + flexWidthStyle,
                        child: Container(
                          child: FittedText(matchInfos.join('\n')),
                          padding: EdgeInsets.all(padding),
                        ),
                      ),
                      ...CommonElements.getTeamHeader(match, fights, context),
                    ]),
                    const Divider(
                      height: 1,
                    ),
                  ]),
                  Expanded(
                    child: ListView.builder(
                      itemCount: fights.length,
                      itemBuilder: (context, index) {
                        return FightListItem(match, fights, index,
                            (match, fights, index) => navigateToFightScreen(context, match, fights, index),
                            flexWidthWeight: flexWidthWeight, flexWidthStyle: flexWidthStyle);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class FightListItem extends StatelessWidget {
  final TeamMatch match;
  final List<Fight> fights;
  final int index;
  final Function(TeamMatch match, List<Fight> fights, int index) listItemCallback;
  final int flexWidthWeight;
  final int flexWidthStyle;

  const FightListItem(this.match, this.fights, this.index, this.listItemCallback,
      {this.flexWidthWeight = 12, this.flexWidthStyle = 5, Key? key})
      : super(key: key);

  displayName(ParticipantState? pStatus, FightRole role, double fontSize, BuildContext context) {
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

    final fight = fights[index];
    return Column(
      children: [
        InkWell(
          onTap: () {
            listItemCallback(match, fights, index);
          },
          child: IntrinsicHeight(
            child: ManyConsumer<FightAction>(
              filterObject: fight,
              builder: (context, actions) => Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                      flex: flexWidthWeight,
                      child: Container(
                        padding: edgeInsets,
                        child: Center(child: Text('${fight.weightClass.weight} $weightUnit', style: fontStyleDefault)),
                      )),
                  Expanded(
                      flex: flexWidthStyle,
                      child:
                          Center(child: Text(styleToAbbr(fight.weightClass.style, context), style: fontStyleDefault))),
                  Expanded(
                    flex: 55,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 50,
                          child: displayName(fight.r, FightRole.red, fontSizeDefault, context),
                        ),
                        SingleConsumer<ParticipantState>(
                          id: fight.r?.id,
                          initialData: fight.r,
                          builder: (context, pState) => Expanded(
                            flex: 5,
                            child: Column(
                              children: [
                                Expanded(
                                    flex: 70,
                                    child: Container(
                                      color: fight.winner == FightRole.red ? Colors.red.shade800 : null,
                                      child: Center(
                                        child: Text(pState?.classificationPoints?.toString() ?? '-',
                                            style: fontStyleDefault),
                                      ),
                                    )),
                                Expanded(
                                  flex: 50,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 50,
                                        child: Container(
                                          color: fight.winner == FightRole.red ? Colors.red.shade800 : null,
                                          child: Center(
                                            child: pState?.classificationPoints != null
                                                ? Text(
                                                    ParticipantState.getTechnicalPoints(actions, FightRole.red)
                                                        .toString(),
                                                    style: TextStyle(fontSize: fontSizeDefault / 2))
                                                : null,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: SingleConsumer<Fight>(
                      id: fight.id,
                      initialData: fight,
                      builder: (context, data) => Column(
                        children: [
                          Expanded(
                              flex: 70,
                              child: Container(
                                color: data?.winner != null ? getColorFromFightRole(data!.winner!).shade800 : null,
                                child: Center(
                                  child: Text(getAbbreviationFromFightResult(data?.result, context),
                                      style: TextStyle(fontSize: fontSizeDefault * 0.7)),
                                ),
                              )),
                          Expanded(
                              flex: 50,
                              child: Center(
                                child: data?.winner != null
                                    ? Text(durationToString(data!.duration),
                                        style: TextStyle(fontSize: fontSizeDefault / 2))
                                    : null,
                              )),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 55,
                    child: Row(
                      children: [
                        SingleConsumer<ParticipantState>(
                          id: fight.b?.id,
                          initialData: fight.b,
                          builder: (context, pState) => Expanded(
                            flex: 5,
                            child: Column(
                              children: [
                                Expanded(
                                    flex: 70,
                                    child: Container(
                                      color: fight.winner == FightRole.blue ? Colors.blue.shade800 : null,
                                      child: Center(
                                        child: Text(pState?.classificationPoints?.toString() ?? '-',
                                            style: fontStyleDefault),
                                      ),
                                    )),
                                Expanded(
                                  flex: 50,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 50,
                                        child: Container(
                                          color: fight.winner == FightRole.blue ? Colors.blue.shade800 : null,
                                          child: Center(
                                            child: pState?.classificationPoints != null
                                                ? Text(
                                                    ParticipantState.getTechnicalPoints(actions, FightRole.blue)
                                                        .toString(),
                                                    style: TextStyle(fontSize: fontSizeDefault / 2))
                                                : null,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 50,
                          child: displayName(fight.b, FightRole.blue, fontSizeDefault, context),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Divider(
          height: 1,
        ),
      ],
    );
  }
}
