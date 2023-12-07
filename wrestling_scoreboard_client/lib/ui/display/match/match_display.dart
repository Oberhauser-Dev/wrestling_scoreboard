import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/data/bout_result.dart';
import 'package:wrestling_scoreboard_client/data/bout_role.dart';
import 'package:wrestling_scoreboard_client/data/wrestling_style.dart';
import 'package:wrestling_scoreboard_client/ui/components/consumer.dart';
import 'package:wrestling_scoreboard_client/ui/components/exception.dart';
import 'package:wrestling_scoreboard_client/ui/components/scaled_text.dart';
import 'package:wrestling_scoreboard_client/ui/display/bout/bout_display.dart';
import 'package:wrestling_scoreboard_client/ui/display/common.dart';
import 'package:wrestling_scoreboard_client/ui/overview/team_match_overview.dart';
import 'package:wrestling_scoreboard_client/ui/utils.dart';
import 'package:wrestling_scoreboard_client/util/units.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class MatchDisplay extends StatelessWidget {
  static const route = 'match_display';
  static const flexWidths = [17, 50, 30, 50];

  final int id;
  final TeamMatch? teamMatch;

  const MatchDisplay({required this.id, this.teamMatch, super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    double width = MediaQuery.of(context).size.width;
    double padding = width / 140;
    return SingleConsumer<TeamMatch>(
      id: id,
      initialData: teamMatch,
      builder: (context, match) {
        if (match == null) return ExceptionWidget(localizations.notFoundException);
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
          body: ManyConsumer<Bout, TeamMatch>(
            filterObject: match,
            builder: (context, bouts) {
              final matchInfos = [
                match.league?.name,
                '${AppLocalizations.of(context)!.boutNo}: ${match.id ?? ''}',
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
                ...CommonElements.getTeamHeader(match, bouts, context),
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
                      itemCount: bouts.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () => navigateToBoutScreen(context, match, bouts[index]),
                              child: IntrinsicHeight(
                                child: ManyConsumer<BoutAction, Bout>(
                                  filterObject: bouts[index],
                                  builder: (context, actions) => Row(
                                    children: BoutListItemTwo(match: match, bout: bouts[index], actions: actions)
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

class BoutListItemTwo {
  final TeamMatch match;
  final Bout bout;
  final List<BoutAction> actions;

  const BoutListItemTwo({required this.match, required this.bout, required this.actions});

  displayName({ParticipantState? pStatus, required BoutRole role, double? fontSize, required BuildContext context}) {
    return Container(
      color: getColorFromBoutRole(role),
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

  Widget displayParticipantState({ParticipantState? pState, required BoutRole role}) {
    final color = (role == bout.winnerRole) ? getColorFromBoutRole(role).shade800 : null;
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
                '${bout.weightClass.weight} $weightUnit',
                softWrap: false,
                minFontSize: 10,
              )),
            ),
          ),
          Expanded(
              child: Center(
                  child: ScaledText(
            styleToAbbr(bout.weightClass.style, context),
            minFontSize: 12,
          ))),
        ],
      ),
      displayName(pStatus: bout.r, role: BoutRole.red, context: context),
      Row(
        children: [
          Expanded(
            flex: 50,
            child: displayParticipantState(pState: bout.r, role: BoutRole.red),
          ),
          Expanded(
            flex: 100,
            child: SingleConsumer<Bout>(
              id: bout.id,
              initialData: bout,
              builder: (context, data) => Column(
                children: [
                  Expanded(
                      flex: 70,
                      child: Container(
                        color: data?.winnerRole != null ? getColorFromBoutRole(data!.winnerRole!).shade800 : null,
                        child: Center(
                          child: ScaledText(getAbbreviationFromBoutResult(data?.result, context), fontSize: 12),
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
            child: displayParticipantState(pState: bout.b, role: BoutRole.blue),
          ),
        ],
      ),
      displayName(pStatus: bout.b, role: BoutRole.blue, context: context),
    ];
  }
}
