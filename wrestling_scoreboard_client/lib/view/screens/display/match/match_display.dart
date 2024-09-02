import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';
import 'package:wrestling_scoreboard_client/localization/bout_result.dart';
import 'package:wrestling_scoreboard_client/localization/bout_utils.dart';
import 'package:wrestling_scoreboard_client/localization/wrestling_style.dart';
import 'package:wrestling_scoreboard_client/provider/data_provider.dart';
import 'package:wrestling_scoreboard_client/services/print/pdf/team_match_transcript.dart';
import 'package:wrestling_scoreboard_client/utils/units.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/bout_display.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/team_match_overview.dart';
import 'package:wrestling_scoreboard_client/view/utils.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaffold.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaled_text.dart';
import 'package:wrestling_scoreboard_client/view/widgets/themed.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class MatchDisplay extends ConsumerWidget {
  static const route = 'display';
  static const flexWidths = [17, 50, 30, 50];

  final int id;
  final TeamMatch? teamMatch;

  const MatchDisplay({required this.id, this.teamMatch, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    double width = MediaQuery.of(context).size.width;
    double padding = width / 140;
    return SingleConsumer<TeamMatch>(
      id: id,
      initialData: teamMatch,
      builder: (context, match) {
        final infoAction = IconButton(
          icon: const Icon(Icons.info),
          onPressed: () => handleSelectedTeamMatch(match, context),
        );
        final pdfAction = IconButton(
          icon: const Icon(Icons.print),
          onPressed: () async {
            final teamMatchBouts = await ref.read(manyDataStreamProvider<TeamMatchBout, TeamMatch>(
              ManyProviderData<TeamMatchBout, TeamMatch>(filterObject: match),
            ).future);

            final teamMatchBoutActions = Map.fromEntries(await Future.wait(teamMatchBouts.map((teamMatchBout) async {
              final boutActions = await ref.read(manyDataStreamProvider<BoutAction, Bout>(
                ManyProviderData<BoutAction, Bout>(filterObject: teamMatchBout.bout),
              ).future);
              // final boutActions = await (await ref.read(dataManagerNotifierProvider)).readMany<BoutAction, Bout>(filterObject: teamMatchBout.bout);
              return MapEntry(teamMatchBout, boutActions);
            })));
            if (context.mounted) {
              final bytes = await TeamMatchTranscript(
                teamMatchBoutActions: teamMatchBoutActions,
                buildContext: context,
                teamMatch: match,
                boutConfig: match.league?.division.boutConfig ?? const BoutConfig(),
              ).buildPdf();
              Printing.sharePdf(bytes: bytes, filename: '${match.fileBaseName}.pdf');
            }
          },
        );
        return WindowStateScaffold(
          hideAppBarOnFullscreen: true,
          actions: [infoAction, pdfAction],
          body: ManyConsumer<TeamMatchBout, TeamMatch>(
            filterObject: match,
            builder: (context, teamMatchBouts) {
              final matchInfos = [
                match.league?.fullname,
                '${localizations.boutNo}: ${match.id ?? ''}',
                if (match.referee != null) '${localizations.refereeAbbr}: ${match.referee?.fullName}',
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
                ...CommonElements.getTeamHeader(
                    match.home.team, match.guest.team, teamMatchBouts.map((e) => e.bout).toList(), context),
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
                      itemCount: teamMatchBouts.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () => navigateToTeamMatchBoutScreen(context, match, teamMatchBouts[index]),
                              child: IntrinsicHeight(
                                child: ManyConsumer<BoutAction, Bout>(
                                  filterObject: teamMatchBouts[index].bout,
                                  builder: (context, actions) => BoutListItem(
                                    match: match,
                                    bout: teamMatchBouts[index].bout,
                                    actions: actions,
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
    // FIXME: use `push` route, https://github.com/flutter/flutter/issues/140586
    context.go('/${TeamMatchOverview.route}/${match.id}');
  }
}

class BoutListItem extends StatelessWidget {
  final TeamMatch match;
  final Bout bout;
  final List<BoutAction> actions;

  const BoutListItem({super.key, required this.match, required this.bout, required this.actions});

  displayName({ParticipantState? pStatus, required BoutRole role, double? fontSize, required BuildContext context}) {
    return ThemedContainer(
      color: role.color(),
      child: Center(
        child: ScaledText(
          pStatus == null
              ? AppLocalizations.of(context)!.participantVacant
              : pStatus.participation.membership.person.fullName,
          color: pStatus == null ? Colors.white.disabled() : Colors.white,
          fontSize: 17,
          minFontSize: 14,
        ),
      ),
    );
  }

  Widget displayParticipantState({ParticipantState? pState, required Bout bout, required BoutRole role}) {
    final color = (role == bout.winnerRole) ? role.color().shade800 : null;
    return NullableSingleConsumer<ParticipantState>(
      id: pState?.id,
      initialData: pState,
      builder: (context, pState) {
        final technicalPoints = ParticipantState.getTechnicalPoints(actions, role);
        return Column(
          children: [
            Expanded(
                flex: 70,
                child: ThemedContainer(
                  color: color,
                  child: Center(
                    child: bout.result != null
                        ? ScaledText(
                            pState?.classificationPoints?.toString() ?? '0',
                            fontSize: 15,
                          )
                        : null,
                  ),
                )),
            Expanded(
              flex: 50,
              child: ThemedContainer(
                color: color,
                child: Center(
                  child: bout.result != null ||
                          technicalPoints > 0 ||
                          bout.duration > Duration.zero ||
                          pState?.classificationPoints != null
                      ? ScaledText(
                          technicalPoints.toString(),
                          fontSize: 8,
                        )
                      : null,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = width / 100;
    final edgeInsets = EdgeInsets.all(padding);
    return SingleConsumer<Bout>(
        initialData: bout,
        id: bout.id,
        builder: (context, bout) {
          final winnerRole = bout.winnerRole;
          return Row(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: edgeInsets,
                      child: bout.weightClass == null
                          ? null
                          : Center(
                              child: ScaledText(
                                '${bout.weightClass!.weight} $weightUnit',
                                softWrap: false,
                                minFontSize: 10,
                              ),
                            ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: bout.weightClass == null
                          ? null
                          : ScaledText(
                              bout.weightClass!.style.abbreviation(context),
                              minFontSize: 12,
                            ),
                    ),
                  ),
                ],
              ),
              displayName(pStatus: bout.r, role: BoutRole.red, context: context),
              Row(
                children: [
                  Expanded(
                    flex: 50,
                    child: displayParticipantState(pState: bout.r, role: BoutRole.red, bout: bout),
                  ),
                  Expanded(
                    flex: 100,
                    child: Column(
                      children: [
                        Expanded(
                            flex: 70,
                            child: ThemedContainer(
                              color: winnerRole?.color().shade800,
                              child: Center(
                                child: ScaledText(bout.result?.abbreviation(context) ?? '', fontSize: 12),
                              ),
                            )),
                        Expanded(
                          flex: 50,
                          child: Center(
                            child: bout.result != null || bout.duration > Duration.zero
                                ? ScaledText(durationToString(bout.duration), fontSize: 8)
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 50,
                    child: displayParticipantState(pState: bout.b, role: BoutRole.blue, bout: bout),
                  ),
                ],
              ),
              displayName(pStatus: bout.b, role: BoutRole.blue, context: context),
            ]
                .asMap()
                .entries
                .map((entry) => Expanded(flex: MatchDisplay.flexWidths[entry.key], child: entry.value))
                .toList(),
          );
        });
  }
}
