import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';
import 'package:wrestling_scoreboard_client/localization/person_role.dart';
import 'package:wrestling_scoreboard_client/localization/season.dart';
import 'package:wrestling_scoreboard_client/provider/account_provider.dart';
import 'package:wrestling_scoreboard_client/provider/data_provider.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/services/print/pdf/team_match_transcript.dart';
import 'package:wrestling_scoreboard_client/utils/export.dart';
import 'package:wrestling_scoreboard_client/utils/io.dart';
import 'package:wrestling_scoreboard_client/utils/provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/event/match_display.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/person_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_match/team_lineup_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_match/team_match_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_match/team_match_person_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/scratch_bout_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/shared/actions.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/shared/team_match_bout_list.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/league_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/team_match_person_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/auth.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';
import 'package:wrestling_scoreboard_client/view/widgets/tab_group.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class TeamMatchOverview extends ConsumerWidget {
  static const route = 'match';

  static void navigateTo(BuildContext context, TeamMatch dataObject) {
    context.push('/$route/${dataObject.id}');
  }

  final int id;
  final TeamMatch? match;

  const TeamMatchOverview({required this.id, this.match, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = context.l10n;
    final navigator = Navigator.of(context);

    return SingleConsumer<TeamMatch>(
      id: id,
      initialData: match,
      builder: (context, match) {
        return SingleConsumer<Organization>(
          id: match.organization?.id,
          initialData: match.organization,
          builder: (context, organization) {
            final pdfAction = ResponsiveScaffoldActionItem(
              label: localizations.print,
              icon: const Icon(Icons.print),
              onTap: () async {
                final teamMatchBouts = await _getBouts(ref, match: match);

                final teamMatchBoutActions = Map.fromEntries(
                  await Future.wait(
                    teamMatchBouts.map((teamMatchBout) async {
                      final boutActions = await _getActions(ref, bout: teamMatchBout.bout);
                      return MapEntry(teamMatchBout, boutActions);
                    }),
                  ),
                );
                final isTimeCountDown = await ref.read(timeCountDownProvider);

                final homeParticipations = await ref.readAsync(
                  manyDataStreamProvider<TeamLineupParticipation, TeamLineup>(
                    ManyProviderData<TeamLineupParticipation, TeamLineup>(filterObject: match.home),
                  ).future,
                );

                final guestParticipations = await ref.readAsync(
                  manyDataStreamProvider<TeamLineupParticipation, TeamLineup>(
                    ManyProviderData<TeamLineupParticipation, TeamLineup>(filterObject: match.guest),
                  ).future,
                );

                final officials = await _getOfficials(ref, match: match);

                if (context.mounted) {
                  final bytes =
                      await TeamMatchTranscript(
                        teamMatchBoutActions: teamMatchBoutActions,
                        buildContext: context,
                        teamMatch: match,
                        officials: officials,
                        boutConfig: match.league?.division.boutConfig ?? TeamMatch.defaultBoutConfig,
                        isTimeCountDown: isTimeCountDown,
                        guestParticipations: guestParticipations,
                        homeParticipations: homeParticipations,
                      ).buildPdf();
                  Printing.sharePdf(bytes: bytes, filename: '${match.fileBaseName}.pdf');
                }
              },
            );

            return ConditionalOrganizationImportActionBuilder(
              id: id,
              organization: organization,
              importType: OrganizationImportType.teamMatch,
              builder: (context, importAction) {
                return FavoriteScaffold<TeamMatch>(
                  dataObject: match,
                  label: localizations.match,
                  details: '${match.home.team.name} - ${match.guest.team.name}',
                  actions: [
                    ResponsiveScaffoldActionItem(
                      onTap:
                          () async => ScratchBoutOverview.navigateTo(
                            context,
                            ref,
                            boutConfig: match.league?.division.boutConfig ?? TeamMatch.defaultBoutConfig,
                          ),
                      icon: const Icon(Icons.rocket_launch),
                      label: localizations.launchScratchBout,
                    ),
                    if (importAction != null) importAction,
                    OrganizationReportActionItem(
                      context: context,
                      organization: organization,
                      onTap: (reporter) async {
                        final teamMatchBouts = await _getBouts(ref, match: match);
                        final boutMap = Map.fromEntries(
                          await Future.wait(
                            teamMatchBouts.map((bout) async => MapEntry(bout, await _getActions(ref, bout: bout.bout))),
                          ),
                        );

                        final officials = await _getOfficials(ref, match: match);
                        final reportStr = reporter.exportTeamMatchReport(
                          teamMatch: match,
                          boutMap: boutMap,
                          officials: officials,
                        );

                        await exportRDB(fileBaseName: match.fileBaseName, rdbString: reportStr);
                      },
                    ),
                    pdfAction,
                    ResponsiveScaffoldActionItem(
                      style: ResponsiveScaffoldActionItemStyle.elevatedIconAndText,
                      icon: const Icon(Icons.tv),
                      onTap: () => MatchDisplay.navigateTo(context, match),
                      label: localizations.display,
                    ),
                  ],
                  tabs: [
                    Tab(child: HeadingText(localizations.info)),
                    if (match.league != null) Tab(child: HeadingText(localizations.lineups)),
                    Tab(child: HeadingText(localizations.bouts)),
                    Tab(child: HeadingText(localizations.officials)),
                  ],
                  body: SingleConsumer<TeamLineup>(
                    id: match.home.id!,
                    initialData: match.home,
                    builder:
                        (context, homeLineup) => SingleConsumer<TeamLineup>(
                          id: match.guest.id!,
                          initialData: match.guest,
                          builder: (context, guestLineup) {
                            final items = [
                              InfoWidget(
                                obj: match,
                                editPage: TeamMatchEdit(teamMatch: match, initialOrganization: organization),
                                onDelete:
                                    () async => (await ref.read(dataManagerProvider)).deleteSingle<TeamMatch>(match),
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
                                    subtitle: localizations.startDate,
                                    icon: Icons.event,
                                  ),
                                  ContentItem(
                                    title: match.endDate?.toDateString(context) ?? '-',
                                    subtitle: localizations.endDate,
                                    icon: Icons.event,
                                  ),
                                  ContentItem(
                                    title: homeLineup.team.name,
                                    subtitle: '${localizations.team} ${localizations.red}',
                                    icon: Icons.group,
                                    onTap: () => TeamOverview.navigateTo(context, homeLineup.team),
                                  ),
                                  ContentItem(
                                    title: guestLineup.team.name,
                                    subtitle: '${localizations.team} ${localizations.blue}',
                                    icon: Icons.group,
                                    onTap: () => TeamOverview.navigateTo(context, guestLineup.team),
                                  ),
                                  ContentItem(
                                    title: match.visitorsCount?.toString() ?? '-',
                                    subtitle: localizations.visitors,
                                    icon: Icons.confirmation_number,
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
                                    onTap:
                                        match.league == null
                                            ? null
                                            : () => LeagueOverview.navigateTo(context, match.league!),
                                  ),
                                  ContentItem(
                                    title:
                                        match.seasonPartition?.asSeasonPartition(
                                          context,
                                          match.league?.division.seasonPartitions,
                                        ) ??
                                        '-',
                                    subtitle: localizations.seasonPartition,
                                    icon: Icons.sunny_snowing,
                                  ),
                                ],
                              ),
                              if (match.league != null)
                                LoadingBuilder<User?>(
                                  future: ref.watch(userProvider),
                                  builder: (context, user) {
                                    final items = [
                                      ContentItem(
                                        title: homeLineup.team.name,
                                        icon: Icons.view_list,
                                        onTap:
                                            (user?.privilege ?? UserPrivilege.none) < UserPrivilege.write
                                                ? null
                                                : () async => handleSelectedLineup(
                                                  context,
                                                  ref,
                                                  homeLineup,
                                                  match,
                                                  navigator,
                                                  league: match.league!,
                                                ),
                                      ),
                                      ContentItem(
                                        title: guestLineup.team.name,
                                        icon: Icons.view_list,
                                        onTap:
                                            (user?.privilege ?? UserPrivilege.none) < UserPrivilege.write
                                                ? null
                                                : () async => handleSelectedLineup(
                                                  context,
                                                  ref,
                                                  guestLineup,
                                                  match,
                                                  navigator,
                                                  league: match.league!,
                                                ),
                                      ),
                                    ];
                                    return GroupedList(
                                      header: HeadingItem(
                                        trailing: Restricted(
                                          privilege: UserPrivilege.write,
                                          child: ElevatedButton.icon(
                                            icon: const Icon(Icons.autorenew),
                                            label: Text(localizations.generate),
                                            onPressed: () async {
                                              final hasConfirmed = await showOkCancelDialog(
                                                context: context,
                                                child: Text(localizations.warningBoutGenerate),
                                              );
                                              if (hasConfirmed && context.mounted) {
                                                await catchAsync(context, () async {
                                                  final dataManager = await ref.read(dataManagerProvider);
                                                  await dataManager.generateBouts<TeamMatch>(match, false);
                                                  if (context.mounted) {
                                                    await showOkDialog(
                                                      context: context,
                                                      child: Text(localizations.actionSuccessful),
                                                    );
                                                  }
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      itemCount: items.length,
                                      itemBuilder: (context, index) => items[index],
                                    );
                                  },
                                ),
                              TeamMatchBoutList(filterObject: match),
                              FilterableManyConsumer<TeamMatchPerson, TeamMatch>.addOrCreate(
                                context: context,
                                addPageBuilder:
                                    (context) => TeamMatchPersonEdit(
                                      initialTeamMatch: match,
                                      initialOrganization: match.organization!,
                                    ),
                                createPageBuilder:
                                    (context) => PersonEdit(
                                      initialOrganization: match.organization!,
                                      onCreated: (person) async {
                                        // TODO: ability to change role inside another implementation of PersonEdit.
                                        await (await ref.read(dataManagerProvider)).createOrUpdateSingle(
                                          TeamMatchPerson(teamMatch: match, person: person, role: PersonRole.steward),
                                        );
                                      },
                                    ),
                                filterObject: match,
                                itemBuilder: (context, teamMatchPerson) {
                                  return ContentItem(
                                    title:
                                        '${teamMatchPerson.role.localize(context)} | ${teamMatchPerson.person.fullName}',
                                    icon: teamMatchPerson.role.icon,
                                    onTap: () async => TeamMatchPersonOverview.navigateTo(context, teamMatchPerson),
                                  );
                                },
                              ),
                            ];
                            return TabGroup(items: items);
                          },
                        ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<List<TeamMatchBout>> _getBouts(WidgetRef ref, {required TeamMatch match}) async {
    final teamMatchBouts = await ref.readAsync(
      manyDataStreamProvider<TeamMatchBout, TeamMatch>(
        ManyProviderData<TeamMatchBout, TeamMatch>(filterObject: match),
      ).future,
    );

    return await Future.wait(
      teamMatchBouts.map((tmb) async {
        return tmb.copyWith(
          bout: await ref.readAsync(singleDataStreamProvider<Bout>(SingleProviderData<Bout>(id: tmb.bout.id!)).future),
        );
      }),
    );
  }

  Future<List<BoutAction>> _getActions(WidgetRef ref, {required Bout bout}) => ref.readAsync(
    manyDataStreamProvider<BoutAction, Bout>(ManyProviderData<BoutAction, Bout>(filterObject: bout)).future,
  );

  Future<Map<Person, PersonRole>> _getOfficials(WidgetRef ref, {required TeamMatch match}) async {
    final officials = await ref.readAsync(
      manyDataStreamProvider<TeamMatchPerson, TeamMatch>(
        ManyProviderData<TeamMatchPerson, TeamMatch>(filterObject: match),
      ).future,
    );

    return Map.fromEntries(officials.map((tmp) => MapEntry(tmp.person, tmp.role)));
  }

  void handleSelectedLineup(
    BuildContext context,
    WidgetRef ref,
    TeamLineup lineup,
    TeamMatch match,
    NavigatorState navigator, {
    required League league,
  }) async {
    final dataManager = await ref.read(dataManagerProvider);
    final participations = await dataManager.readMany<TeamLineupParticipation, TeamLineup>(filterObject: lineup);
    final leagueWeightClasses =
        (await dataManager.readMany<LeagueWeightClass, League>(
          filterObject: league,
        )).where((element) => element.seasonPartition == match.seasonPartition).toList();
    var weightClasses = leagueWeightClasses.map((e) => e.weightClass).toList();
    if (weightClasses.isEmpty) {
      final divisionWeightClasses =
          (await dataManager.readMany<DivisionWeightClass, Division>(
            filterObject: league.division,
          )).where((element) => element.seasonPartition == match.seasonPartition).toList();
      weightClasses = divisionWeightClasses.map((e) => e.weightClass).toList();
    }
    TeamLineup? proposedLineup;
    List<TeamLineupParticipation>? proposedParticipations;
    if (participations.isEmpty) {
      // Load lineup from previous fight as proposal
      var matches = await ref.readAsync(
        manyDataStreamProvider<TeamMatch, League>(ManyProviderData<TeamMatch, League>(filterObject: league)).future,
      );
      matches =
          matches.where((match) => match.date.isBefore(DateTime.now().subtract(const Duration(hours: 24)))).toList();
      matches.sort((a, b) => a.date.compareTo(b.date));
      final resolvedMatch = matches.lastWhereOrNull(
        (match) => match.home.team == lineup.team || match.guest.team == lineup.team,
      );
      if (resolvedMatch != null && resolvedMatch.organization != null && context.mounted) {
        await checkProposeImport(
          context,
          ref,
          organization: resolvedMatch.organization!,
          id: resolvedMatch.id!,
          importType: OrganizationImportType.teamMatch,
        );
        proposedLineup = resolvedMatch.home.team == lineup.team ? resolvedMatch.home : resolvedMatch.guest;
        proposedParticipations = await dataManager.readMany<TeamLineupParticipation, TeamLineup>(
          filterObject: proposedLineup,
        );
      }
    }
    navigator.push(
      MaterialPageRoute(
        builder: (context) {
          return TeamLineupEdit(
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
    final fileNameBuilder = [date.toFileNameDateFormat(), league?.fullname, no, home.team.name, '–', guest.team.name];
    fileNameBuilder.removeWhere((e) => e == null || e.isEmpty);
    return fileNameBuilder.map((e) => e!.replaceAll(' ', '-')).join('_');
  }
}
