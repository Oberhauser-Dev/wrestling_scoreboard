import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/data/fight_result.dart';
import 'package:wrestling_scoreboard_client/data/fight_role.dart';
import 'package:wrestling_scoreboard_client/data/wrestling_style.dart';
import 'package:wrestling_scoreboard_client/ui/components/consumer.dart';
import 'package:wrestling_scoreboard_client/ui/components/exception.dart';
import 'package:wrestling_scoreboard_client/ui/fight/fight_display.dart';
import 'package:wrestling_scoreboard_client/ui/overview/team_match_overview.dart';
import 'package:wrestling_scoreboard_client/util/units.dart';
import 'package:wrestling_scoreboard_common/common.dart';

import '../components/fitted_text.dart';
import 'common_elements.dart';

class MatchDisplay extends StatelessWidget {
  static const route = 'match_display';

  final int id;
  final TeamMatch? teamMatch;

  const MatchDisplay({required this.id, this.teamMatch, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    double width = MediaQuery.of(context).size.width;
    double padding = width / 100;
    int flexWidthWeight = 12;
    int flexWidthStyle = 5;
    return SingleConsumer<TeamMatch>(
      id: id,
      initialData: teamMatch,
      builder: (context, match) {
        if (match == null) return ExceptionWidget(localizations.notFoundException);
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
                onPressed: () => handleSelectedTeamMatch(match, context),
              ),
            ]),
          ),
          body: ManyConsumer<Fight, TeamMatch>(
            filterObject: match,
            builder: (context, fights) {
              final matchInfos = [
                match.league?.name,
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
                          padding: EdgeInsets.all(padding),
                          child: FittedText(matchInfos.join('\n')),
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
                        return FightListItem(
                            match, fights[index], (match, fight) => navigateToFightScreen(context, match, fight),
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

  handleSelectedTeamMatch(TeamMatch match, BuildContext context) {
    context.push('/${TeamMatchOverview.route}/${match.id}');
  }
}

class FightListItem extends StatelessWidget {
  final TeamMatch match;
  final Fight fight;
  final Function(TeamMatch match, Fight fight) listItemCallback;
  final int flexWidthWeight;
  final int flexWidthStyle;

  const FightListItem(this.match, this.fight, this.listItemCallback,
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

    return Column(
      children: [
        InkWell(
          onTap: () {
            listItemCallback(match, fight);
          },
          child: IntrinsicHeight(
            child: ManyConsumer<FightAction, Fight>(
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
                                      color: fight.winnerRole == FightRole.red ? Colors.red.shade800 : null,
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
                                          color: fight.winnerRole == FightRole.red ? Colors.red.shade800 : null,
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
                                color:
                                    data?.winnerRole != null ? getColorFromFightRole(data!.winnerRole!).shade800 : null,
                                child: Center(
                                  child: Text(getAbbreviationFromFightResult(data?.result, context),
                                      style: TextStyle(fontSize: fontSizeDefault * 0.7)),
                                ),
                              )),
                          Expanded(
                              flex: 50,
                              child: Center(
                                child: data?.winnerRole != null
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
                                      color: fight.winnerRole == FightRole.blue ? Colors.blue.shade800 : null,
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
                                          color: fight.winnerRole == FightRole.blue ? Colors.blue.shade800 : null,
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
