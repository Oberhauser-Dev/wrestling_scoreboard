import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/data/fight_result.dart';
import 'package:wrestling_scoreboard_client/data/fight_role.dart';
import 'package:wrestling_scoreboard_client/data/wrestling_style.dart';
import 'package:wrestling_scoreboard_client/ui/components/consumer.dart';
import 'package:wrestling_scoreboard_client/ui/components/exception.dart';
import 'package:wrestling_scoreboard_client/ui/components/scaled_text.dart';
import 'package:wrestling_scoreboard_client/ui/fight/fight_display.dart';
import 'package:wrestling_scoreboard_client/ui/overview/team_match_overview.dart';
import 'package:wrestling_scoreboard_client/util/units.dart';
import 'package:wrestling_scoreboard_common/common.dart';

import 'common_elements.dart';

class MatchDisplay extends StatelessWidget {
  static const route = 'match_display';
  static const flexWidths = [17, 50, 30, 50];

  final int id;
  final TeamMatch? teamMatch;

  const MatchDisplay({required this.id, this.teamMatch, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    double width = MediaQuery.of(context).size.width;
    double padding = width / 140;
    int flexWidthWeight = 12;
    int flexWidthStyle = 5;
    return SingleConsumer<TeamMatch>(
      id: id,
      initialData: teamMatch,
      builder: (context, match) {
        if (match == null) return ExceptionWidget(localizations.notFoundException);
        final isMobile =
            !kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS);
        final infoAction = IconButton(
          icon: const Icon(Icons.info),
          onPressed: () => handleSelectedTeamMatch(match, context),
        );
        return Scaffold(
          appBar: isMobile ? AppBar(actions: [infoAction]) : null,
          bottomNavigationBar: isMobile
              ? null
              : BottomAppBar(
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                    ),
                    infoAction,
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

              final headerItems = <Widget>[
                Padding(
                    padding: EdgeInsets.all(padding),
                    child: Center(
                        child: ScaledText(
                      matchInfos.join('\n'),
                      softWrap: false,
                      fontSize: 12,
                      minFontSize: 10,
                    ))),
                ...CommonElements.getTeamHeader(match, fights, context),
              ];
              final column = Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: headerItems
                            .asMap()
                            .entries
                            .map((entry) => Expanded(flex: flexWidths[entry.key], child: entry.value))
                            .toList()),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: fights.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () => navigateToFightScreen(context, match, fights[index]),
                              child: IntrinsicHeight(
                                child: ManyConsumer<FightAction, Fight>(
                                  filterObject: fights[index],
                                  builder: (context, actions) => Row(
                                    children: FightListItemTwo(match: match, fight: fights[index], actions: actions)
                                        .build(context)
                                        .asMap()
                                        .entries
                                        .map((entry) => Expanded(flex: flexWidths[entry.key], child: entry.value))
                                        .toList(),
                                  ),
                                ),
                              ),
                            ),
                            const Divider(height: 1),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
              return column;
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

class FightListItemTwo {
  final TeamMatch match;
  final Fight fight;
  final List<FightAction> actions;

  const FightListItemTwo({required this.match, required this.fight, required this.actions});

  displayName({ParticipantState? pStatus, required FightRole role, double? fontSize, required BuildContext context}) {
    return Container(
      color: getColorFromFightRole(role),
      child: Center(
        child: ScaledText(
          pStatus == null
              ? AppLocalizations.of(context)!.participantVacant
              : pStatus.participation.membership.person.fullName,
          color: pStatus == null ? Colors.white30 : Colors.white,
          fontSize: 17,
          minFontSize: 14,
        ),
      ),
    );
  }

  Widget displayParticipantState({ParticipantState? pState, required FightRole role}) {
    final color = (role == fight.winnerRole) ? getColorFromFightRole(role).shade800 : null;
    return SingleConsumer<ParticipantState>(
      id: pState?.id,
      initialData: pState,
      builder: (context, pState) => Column(
        children: [
          Expanded(
              flex: 70,
              child: Container(
                color: color,
                child: Center(
                  child: ScaledText(
                    pState?.classificationPoints?.toString() ?? '-',
                    fontSize: 15,
                  ),
                ),
              )),
          Expanded(
            flex: 50,
            child: Container(
              color: color,
              child: Center(
                child: pState?.classificationPoints != null
                    ? ScaledText(
                        ParticipantState.getTechnicalPoints(actions, role).toString(),
                        fontSize: 8,
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = width / 100;
    final edgeInsets = EdgeInsets.all(padding);
    return [
      Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: edgeInsets,
              child: Center(
                  child: ScaledText(
                '${fight.weightClass.weight} $weightUnit',
                softWrap: false,
                minFontSize: 10,
              )),
            ),
          ),
          Expanded(
              child: Center(
                  child: ScaledText(
            styleToAbbr(fight.weightClass.style, context),
            minFontSize: 12,
          ))),
        ],
      ),
      displayName(pStatus: fight.r, role: FightRole.red, context: context),
      Row(
        children: [
          Expanded(
            flex: 50,
            child: displayParticipantState(pState: fight.r, role: FightRole.red),
          ),
          Expanded(
            flex: 100,
            child: SingleConsumer<Fight>(
              id: fight.id,
              initialData: fight,
              builder: (context, data) => Column(
                children: [
                  Expanded(
                      flex: 70,
                      child: Container(
                        color: data?.winnerRole != null ? getColorFromFightRole(data!.winnerRole!).shade800 : null,
                        child: Center(
                          child: ScaledText(getAbbreviationFromFightResult(data?.result, context), fontSize: 12),
                        ),
                      )),
                  Expanded(
                      flex: 50,
                      child: Center(
                        child:
                            data?.winnerRole != null ? ScaledText(durationToString(data!.duration), fontSize: 8) : null,
                      )),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 50,
            child: displayParticipantState(pState: fight.b, role: FightRole.blue),
          ),
        ],
      ),
      displayName(pStatus: fight.b, role: FightRole.blue, context: context),
    ];
  }
}
