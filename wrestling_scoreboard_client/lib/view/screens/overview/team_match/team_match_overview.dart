import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';
import 'package:wrestling_scoreboard_client/localization/bout_utils.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';
import 'package:wrestling_scoreboard_client/localization/season.dart';
import 'package:wrestling_scoreboard_client/provider/data_provider.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/services/print/pdf/team_match_transcript.dart';
import 'package:wrestling_scoreboard_client/utils/export.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/match/match_display.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/lineup_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_match/team_match_bout_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_match/team_match_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/shared/actions.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/team_match_bout_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/auth.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
import 'package:wrestling_scoreboard_client/view/widgets/tab_group.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class TeamMatchOverview extends ConsumerWidget {
  static const route = 'match';

  final int id;
  final TeamMatch? match;

  const TeamMatchOverview({required this.id, this.match, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);

    return SingleConsumer<TeamMatch>(
        id: id,
        initialData: match,
        builder: (context, match) {
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
              final isTimeCountDown = await ref.read(timeCountDownNotifierProvider);
              if (context.mounted) {
                final bytes = await TeamMatchTranscript(
                  teamMatchBoutActions: teamMatchBoutActions,
                  buildContext: context,
                  teamMatch: match,
                  boutConfig: match.league?.division.boutConfig ?? TeamMatch.defaultBoutConfig,
                  isTimeCountDown: isTimeCountDown,
                ).buildPdf();
                Printing.sharePdf(bytes: bytes, filename: '${match.fileBaseName}.pdf');
              }
            },
          );

          return FavoriteScaffold<TeamMatch>(
            dataObject: match,
            label: localizations.match,
            details: '${match.home.team.name} - ${match.guest.team.name}',
            actions: [
              ConditionalOrganizationImportAction(
                  id: id, organization: match.organization!, importType: OrganizationImportType.teamMatch),
              // TODO: replace with file_save when https://github.com/flutter/flutter/issues/102560 is merged, also replace in settings.
              IconButton(
                  onPressed: () async {
                    final reporter = match.organization?.getReporter();
                    if (reporter != null) {
                      final bouts = await _getBouts(ref, match: match);
                      final boutMap = Map.fromEntries(await Future.wait(
                          bouts.map((bout) async => MapEntry(bout, await _getActions(ref, bout: bout)))));
                      final reportStr = reporter.exportTeamMatchReport(match, boutMap);

                      await exportRDB(fileBaseName: match.fileBaseName, rdbString: reportStr);
                    } else {
                      if (context.mounted) {
                        showExceptionDialog(
                          context: context,
                          exception: Exception(match.organization == null
                              ? 'No organization applied to match with id ${match.id}. Please contact the development team.'
                              : 'No reporter selected for the organization ${match.organization?.name}. Please select one in the organization editor.'),
                          stackTrace: null,
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.description)),
              pdfAction,
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.tv),
                  onPressed: () => handleSelectedMatchSequence(match, context),
                  label: Text(localizations.display),
                ),
              )
            ],
            tabs: [
              Tab(child: HeadingText(localizations.info)),
              if (match.league != null) Tab(child: HeadingText(localizations.lineups)),
              Tab(child: HeadingText(localizations.bouts)),
              Tab(child: HeadingText(localizations.persons)),
            ],
            body: SingleConsumer<Lineup>(
              id: match.home.id!,
              initialData: match.home,
              builder: (context, homeLineup) => SingleConsumer<Lineup>(
                id: match.guest.id!,
                initialData: match.guest,
                builder: (context, guestLineup) {
                  final items = [
                    InfoWidget(
                        obj: match,
                        editPage: TeamMatchEdit(
                          teamMatch: match,
                        ),
                        onDelete: () async =>
                            (await ref.read(dataManagerNotifierProvider)).deleteSingle<TeamMatch>(match),
                        classLocale: localizations.match,
                        children: [
                          ContentItem(
                            title: match.no ?? '-',
                            subtitle: localizations.matchNumber,
                            icon: Icons.tag,
                          ),
                          ContentItem(
                            title: match.location ?? 'no location',
                            subtitle: localizations.place,
                            icon: Icons.place,
                          ),
                          ContentItem(
                            title: match.date.toDateTimeString(context),
                            subtitle: localizations.date,
                            icon: Icons.date_range,
                          ),
                          ContentItem(
                            title: homeLineup.team.name,
                            subtitle: '${localizations.team} ${localizations.red}',
                            icon: Icons.group,
                          ),
                          ContentItem(
                            title: guestLineup.team.name,
                            subtitle: '${localizations.team} ${localizations.blue}',
                            icon: Icons.group,
                          ),
                          ContentItem(
                            title: match.comment ?? '-',
                            subtitle: localizations.comment,
                            icon: Icons.comment,
                          ),
                          ContentItem(
                            title: match.league?.fullname ?? '-',
                            subtitle: localizations.league,
                            icon: Icons.emoji_events,
                          ),
                          ContentItem(
                            title: match.seasonPartition
                                    ?.asSeasonPartition(context, match.league?.division.seasonPartitions) ??
                                '-',
                            subtitle: localizations.seasonPartition,
                            icon: Icons.sunny_snowing,
                          ),
                        ]),
                    if (match.league != null)
                      GroupedList(
                        header: const HeadingItem(),
                        items: [
                          ContentItem(
                              title: homeLineup.team.name,
                              icon: Icons.view_list,
                              onTap: () async => handleSelectedLineup(
                                    context,
                                    ref,
                                    homeLineup,
                                    match,
                                    navigator,
                                    league: match.league!,
                                  )),
                          ContentItem(
                              title: guestLineup.team.name,
                              icon: Icons.view_list,
                              onTap: () async => handleSelectedLineup(
                                    context,
                                    ref,
                                    guestLineup,
                                    match,
                                    navigator,
                                    league: match.league!,
                                  )),
                        ],
                      ),
                    ManyConsumer<TeamMatchBout, TeamMatch>(
                      filterObject: match,
                      builder: (BuildContext context, List<TeamMatchBout> teamMatchBouts) {
                        return GroupedList(
                          header: HeadingItem(
                            trailing: RestrictedAddButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TeamMatchBoutEdit(
                                    initialTeamMatch: match,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          items: teamMatchBouts.map(
                            (bout) => SingleConsumer<TeamMatchBout>(
                              id: bout.id,
                              initialData: bout,
                              builder: (context, teamMatchBout) => ContentItem(
                                title: teamMatchBout.bout.title(context),
                                icon: Icons.sports_kabaddi,
                                onTap: () => handleSelectedTeamMatchBout(match, teamMatchBout, context),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    GroupedList(
                      header: const HeadingItem(),
                      items: [
                        ContentItem(
                          title: match.referee?.fullName ?? '-',
                          subtitle: localizations.referee,
                          icon: Icons.sports,
                        ),
                        ContentItem(
                          title: match.matChairman?.fullName ?? '-',
                          subtitle: localizations.matChairman,
                          icon: Icons.manage_accounts,
                        ),
                        ContentItem(
                          title: match.judge?.fullName ?? '-',
                          subtitle: localizations.judge,
                          icon: Icons.manage_accounts,
                        ),
                        ContentItem(
                          title: match.timeKeeper?.fullName ?? '-',
                          subtitle: localizations.timeKeeper,
                          icon: Icons.pending_actions,
                        ),
                        ContentItem(
                          title: match.transcriptWriter?.fullName ?? '-',
                          subtitle: localizations.transcriptionWriter,
                          icon: Icons.history_edu,
                        ),
                        ContentItem(
                          title: '-', // TODO: Multiple stewards
                          subtitle: localizations.steward,
                          icon: Icons.security,
                        ),
                      ],
                    ),
                  ];
                  return TabGroup(items: items);
                },
              ),
            ),
          );
        });
  }

  Future<List<Bout>> _getBouts(WidgetRef ref, {required TeamMatch match}) =>
      ref.read(manyDataStreamProvider<Bout, TeamMatch>(ManyProviderData<Bout, TeamMatch>(filterObject: match)).future);

  Future<List<BoutAction>> _getActions(WidgetRef ref, {required Bout bout}) =>
      ref.read(manyDataStreamProvider<BoutAction, Bout>(ManyProviderData<BoutAction, Bout>(filterObject: bout)).future);

  handleSelectedTeamMatchBout(TeamMatch match, TeamMatchBout bout, BuildContext context) {
    context.push('/${TeamMatchOverview.route}/${match.id}/${TeamMatchBoutOverview.route}/${bout.id}');
  }

  handleSelectedMatchSequence(TeamMatch match, BuildContext context) {
    context.push('/${TeamMatchOverview.route}/${match.id}/${MatchDisplay.route}');
  }

  handleSelectedLineup(
    BuildContext context,
    WidgetRef ref,
    Lineup lineup,
    TeamMatch match,
    NavigatorState navigator, {
    required League league,
  }) async {
    final dataManager = await ref.read(dataManagerNotifierProvider);
    final participations = await dataManager.readMany<Participation, Lineup>(filterObject: lineup);
    final leagueWeightClasses = (await dataManager.readMany<LeagueWeightClass, League>(filterObject: league))
        .where((element) => element.seasonPartition == match.seasonPartition)
        .toList();
    var weightClasses = leagueWeightClasses.map((e) => e.weightClass).toList();
    if (weightClasses.isEmpty) {
      final divisionWeightClasses =
          (await dataManager.readMany<DivisionWeightClass, Division>(filterObject: league.division))
              .where((element) => element.seasonPartition == match.seasonPartition)
              .toList();
      weightClasses = divisionWeightClasses.map((e) => e.weightClass).toList();
    }
    Lineup? proposedLineup;
    List<Participation>? proposedParticipations;
    if (participations.isEmpty) {
      // Load lineup from previous fight as proposal
      var matches = await ref.read(manyDataStreamProvider<TeamMatch, League>(
        ManyProviderData<TeamMatch, League>(filterObject: league),
      ).future);
      matches =
          matches.where((match) => match.date.isBefore(DateTime.now().subtract(const Duration(hours: 24)))).toList();
      matches.sort((a, b) => a.date.compareTo(b.date));
      final resolvedMatch =
          matches.lastWhereOrNull((match) => match.home.team == lineup.team || match.guest.team == lineup.team);
      if (resolvedMatch != null && resolvedMatch.organization != null && context.mounted) {
        await checkProposeImport(
          context,
          ref,
          orgId: resolvedMatch.organization!.id!,
          id: resolvedMatch.id!,
          importType: OrganizationImportType.teamMatch,
        );
        proposedLineup = resolvedMatch.home.team == lineup.team ? resolvedMatch.home : resolvedMatch.guest;
        proposedParticipations = await dataManager.readMany<Participation, Lineup>(filterObject: proposedLineup);
      }
    }
    navigator.push(
      MaterialPageRoute(
        builder: (context) {
          return LineupEdit(
            weightClasses: weightClasses,
            participations: participations,
            lineup: lineup,
            initialCoach: proposedLineup?.coach,
            initialLeader: proposedLineup?.leader,
            initialParticipations: proposedParticipations,
            onSubmitGenerate: () async {
              await dataManager.generateBouts<TeamMatch>(match, false);
            },
          );
        },
      ),
    );
  }
}

extension TeamMatchFileExt on TeamMatch {
  String get fileBaseName {
    final fileNameBuilder = [
      date.toIso8601String().substring(0, 10),
      league?.fullname,
      no,
      home.team.name,
      '–',
      guest.team.name,
    ];
    fileNameBuilder.removeWhere((e) => e == null || e.isEmpty);
    return fileNameBuilder.map((e) => e!.replaceAll(' ', '-')).join('_');
  }
}
