import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/bout_utils.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';
import 'package:wrestling_scoreboard_client/localization/season.dart';
import 'package:wrestling_scoreboard_client/provider/data_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/services/network/data_manager.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/match/match_display.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/lineup_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_match/team_match_bout_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_match/team_match_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/team_match_bout_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
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
          return Scaffold(
            appBar: AppBar(
              title: AppBarTitle(
                label: localizations.match,
                details: '${match.home.team.name} - ${match.guest.team.name}',
              ),
              actions: [
                // TODO: replace with file_save when https://github.com/flutter/flutter/issues/102560 is merged, also replace in settings.
                IconButton(
                    onPressed: () async {
                      final reporter = match.organization?.getReporter();
                      if (reporter != null) {
                        final fileNameBuilder = [
                          match.date.toIso8601String().substring(0, 10),
                          match.league?.fullname,
                          match.no,
                          match.home.team.name,
                          '–',
                          '${match.guest.team.name}.rdb',
                        ];
                        fileNameBuilder.removeWhere((e) => e == null || e.isEmpty);
                        final fileName = fileNameBuilder.map((e) => e!.replaceAll(' ', '-')).join('_');
                        String? outputPath = await FilePicker.platform.saveFile(
                          fileName: fileName,
                        );
                        if (outputPath != null) {
                          final bouts = await _getBouts(ref, match: match);
                          final boutMap = Map.fromEntries(await Future.wait(
                              bouts.map((bout) async => MapEntry(bout, await _getActions(ref, bout: bout)))));
                          final reportStr = reporter.exportTeamMatchReport(match, boutMap);
                          final outputFile = File(outputPath);
                          await outputFile.writeAsString(reportStr, encoding: const Utf8Codec());
                        }
                      } else {
                        if (context.mounted) {
                          showExceptionDialog(
                            context: context,
                            exception: Exception('Please select a report provider in the settings'),
                            stackTrace: null,
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.description)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.tv),
                    onPressed: () => handleSelectedMatchSequence(match, context),
                    label: Text(localizations.display),
                  ),
                )
              ],
            ),
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
                    ListGroup(
                      header: HeadingItem(title: localizations.persons),
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
                          title: '-', // Multiple stewards
                          subtitle: localizations.steward,
                          icon: Icons.security,
                        ),
                      ],
                    ),
                    if (match.league != null)
                      ListGroup(
                        header: HeadingItem(title: localizations.lineups),
                        items: [
                          ContentItem(
                              title: homeLineup.team.name,
                              icon: Icons.view_list,
                              onTap: () async => handleSelectedLineup(
                                    homeLineup,
                                    match,
                                    navigator,
                                    (await ref.read(dataManagerNotifierProvider)),
                                    league: match.league!,
                                  )),
                          ContentItem(
                              title: guestLineup.team.name,
                              icon: Icons.view_list,
                              onTap: () async => handleSelectedLineup(
                                    guestLineup,
                                    match,
                                    navigator,
                                    (await ref.read(dataManagerNotifierProvider)),
                                    league: match.league!,
                                  )),
                        ],
                      ),
                    ManyConsumer<TeamMatchBout, TeamMatch>(
                      filterObject: match,
                      builder: (BuildContext context, List<TeamMatchBout> teamMatchBouts) {
                        return ListGroup(
                          header: HeadingItem(
                            title: localizations.bouts,
                            trailing: IconButton(
                              icon: const Icon(Icons.add),
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
                                onTap: () => handleSelectedBout(teamMatchBout, context),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ];
                  return GroupedList(items: items);
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

  handleSelectedBout(TeamMatchBout bout, BuildContext context) {
    context.push('/${TeamMatchBoutOverview.route}/${bout.id}');
  }

  handleSelectedMatchSequence(TeamMatch match, BuildContext context) {
    context.push('/${TeamMatchOverview.route}/${match.id}/${MatchDisplay.route}');
  }

  handleSelectedLineup(Lineup lineup, TeamMatch match, NavigatorState navigator, DataManager dataManager,
      {required League league}) async {
    final participations = await dataManager.readMany<Participation, Lineup>(filterObject: lineup);
    final weightClasses = (await dataManager.readMany<DivisionWeightClass, Division>(filterObject: league.division))
        .where((element) => element.seasonPartition == match.seasonPartition)
        .toList();
    navigator.push(
      MaterialPageRoute(
        builder: (context) {
          return LineupEdit(
            weightClasses: weightClasses.map((e) => e.weightClass).toList(),
            participations: participations,
            lineup: lineup,
            onSubmitGenerate: () {
              dataManager.generateBouts<TeamMatch>(match, false);
            },
          );
        },
      ),
    );
  }
}
