import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';
import 'package:wrestling_scoreboard_client/provider/data_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/utils/export.dart';
import 'package:wrestling_scoreboard_client/utils/io.dart';
import 'package:wrestling_scoreboard_client/utils/provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/event/competition_display.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/competition/competition_age_category_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/competition/competition_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/competition/competition_lineup_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/competition/competition_system_affiliation_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/competition/competition_weight_category_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/bout_config_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_age_category_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_cycle_management.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_lineup_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_system_affiliation_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_weight_category_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/scratch_bout_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/shared/competition_bout_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';
import 'package:wrestling_scoreboard_client/view/widgets/tab_group.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class CompetitionOverview extends ConsumerWidget with BoutConfigOverviewTab {
  static const route = 'competition';

  final int id;
  final Competition? competition;

  const CompetitionOverview({required this.id, this.competition, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = context.l10n;

    return SingleConsumer<Competition>(
      id: id,
      initialData: competition,
      builder: (context, competition) {
        return SingleConsumer<Organization>(
          id: competition.organization?.id,
          initialData: competition.organization,
          builder: (context, organization) {
            final (boutConfigTab, boutConfigTabContent) = buildTab(context, initialData: competition.boutConfig);

            // final pdfAction = IconButton(
            //   icon: const Icon(Icons.print),
            //   onPressed: () async {
            //     final teamMatchBouts = await ref.readAsync(manyDataStreamProvider<CompetitionBout, Competition>(
            //       ManyProviderData<CompetitionBout, Competition>(filterObject: competition),
            //     ).future);
            //
            //     final teamMatchBoutActions = Map.fromEntries(await Future.wait(teamMatchBouts.map((teamMatchBout) async {
            //       final boutActions = await ref.readAsync(manyDataStreamProvider<BoutAction, Bout>(
            //         ManyProviderData<BoutAction, Bout>(filterObject: teamMatchBout.bout),
            //       ).future);
            //       // final boutActions = await (await ref.read(dataManagerNotifierProvider)).readMany<BoutAction, Bout>(filterObject: teamMatchBout.bout);
            //       return MapEntry(teamMatchBout, boutActions);
            //     })));
            //     final isTimeCountDown = await ref.read(timeCountDownNotifierProvider);
            //
            //     final homeParticipations = await ref.readAsync(manyDataStreamProvider<CompetitionParticipation, CompetitionLineup>(
            //       ManyProviderData<CompetitionParticipation, CompetitionLineup>(filterObject: competition.home),
            //     ).future);
            //
            //     final guestParticipations =
            //         await ref.readAsync(manyDataStreamProvider<CompetitionParticipation, CompetitionLineup>(
            //       ManyProviderData<CompetitionParticipation, CompetitionLineup>(filterObject: competition.guest),
            //     ).future);
            //
            //     if (context.mounted) {
            //       final bytes = await CompetitionTranscript(
            //         teamMatchBoutActions: teamMatchBoutActions,
            //         buildContext: context,
            //         teamMatch: competition,
            //         boutConfig: competition.league?.division.boutConfig ?? Competition.defaultBoutConfig,
            //         isTimeCountDown: isTimeCountDown,
            //         guestParticipations: guestParticipations,
            //         homeParticipations: homeParticipations,
            //       ).buildPdf();
            //       Printing.sharePdf(bytes: bytes, filename: '${competition.fileBaseName}.pdf');
            //     }
            //   },
            // );

            // final contentItems = [
            //   ContentItem(
            //     title: competition.referee?.fullName ?? '-',
            //     subtitle: localizations.referee,
            //     icon: Icons.sports,
            //   ),
            //   ContentItem(
            //     title: competition.matChairman?.fullName ?? '-',
            //     subtitle: localizations.matChairman,
            //     icon: Icons.manage_accounts,
            //   ),
            //   ContentItem(
            //     title: competition.judge?.fullName ?? '-',
            //     subtitle: localizations.judge,
            //     icon: Icons.manage_accounts,
            //   ),
            //   ContentItem(
            //     title: competition.timeKeeper?.fullName ?? '-',
            //     subtitle: localizations.timeKeeper,
            //     icon: Icons.pending_actions,
            //   ),
            //   ContentItem(
            //     title: competition.transcriptWriter?.fullName ?? '-',
            //     subtitle: localizations.transcriptionWriter,
            //     icon: Icons.history_edu,
            //   ),
            //   ContentItem(
            //     title: '-', // TODO: Multiple stewards
            //     subtitle: localizations.steward,
            //     icon: Icons.security,
            //   ),
            // ];

            final description = InfoWidget(
              obj: competition,
              editPage: CompetitionEdit(competition: competition),
              onDelete: () async {
                await (await ref.read(dataManagerNotifierProvider)).deleteSingle<Competition>(competition);
                if (context.mounted) await super.onDelete(context, ref, single: competition.boutConfig);
              },
              classLocale: localizations.competition,
              children: [
                ContentItem(title: competition.no ?? '-', subtitle: localizations.competitionNumber, icon: Icons.tag),
                ContentItem(
                  title: competition.location ?? 'no location',
                  subtitle: localizations.place,
                  icon: Icons.place,
                ),
                ContentItem(
                  title: competition.date.toDateTimeString(context),
                  subtitle: localizations.date,
                  icon: Icons.date_range,
                ),
                ContentItem(title: competition.comment ?? '-', subtitle: localizations.comment, icon: Icons.comment),
              ],
            );

            final tabItems = {
              Tab(child: HeadingText(localizations.cycles)): CompetitionCycleManagement(competition: competition),
              Tab(
                child: HeadingText(localizations.lineups),
              ): FilterableManyConsumer<CompetitionLineup, Competition>.edit(
                context: context,
                editPageBuilder: (context) => CompetitionLineupEdit(initialCompetition: competition),
                filterObject: competition,
                itemBuilder: (context, lineup) {
                  return ContentItem(
                    title: lineup.club.name,
                    icon: Icons.view_list,
                    onTap: () async => _handleSelectedCompetitionLineup(context, lineup),
                  );
                },
              ),
              Tab(
                child: HeadingText(localizations.ageCategories),
              ): FilterableManyConsumer<CompetitionAgeCategory, Competition>.edit(
                context: context,
                editPageBuilder: (context) => CompetitionAgeCategoryEdit(initialCompetition: competition),
                filterObject: competition,
                itemBuilder: (context, competitionAgeCategory) {
                  return ContentItem(
                    title: competitionAgeCategory.ageCategory.name,
                    icon: Icons.school,
                    onTap: () async => _handleSelectedCompetitionAgeCategory(context, competitionAgeCategory),
                  );
                },
              ),
              Tab(
                child: HeadingText(localizations.weightCategories),
              ): FilterableManyConsumer<CompetitionWeightCategory, Competition>.edit(
                context: context,
                editPageBuilder: (context) => CompetitionWeightCategoryEdit(initialCompetition: competition),
                filterObject: competition,
                itemBuilder: (context, weightCategory) {
                  return ContentItem(
                    title: weightCategory.name,
                    icon: Icons.fitness_center,
                    onTap: () async => _handleSelectedWeightCategory(context, weightCategory),
                  );
                },
              ),
              Tab(
                child: HeadingText(localizations.competitionSystems),
              ): FilterableManyConsumer<CompetitionSystemAffiliation, Competition>.edit(
                context: context,
                editPageBuilder: (context) => CompetitionSystemAffiliationEdit(initialCompetition: competition),
                filterObject: competition,
                itemBuilder: (context, competitionSystemAffiliation) {
                  return ContentItem(
                    title:
                        '${competitionSystemAffiliation.poolGroupCount} × ${competitionSystemAffiliation.competitionSystem.name}',
                    icon: Icons.account_tree,
                    onTap:
                        () async => _handleSelectedCompetitionSystemAffiliation(context, competitionSystemAffiliation),
                  );
                },
              ),
              Tab(child: HeadingText(localizations.bouts)): CompetitionBoutList(filterObject: competition),

              // Tab(child: HeadingText(localizations.persons)):
              // GroupedList(
              //   header: const HeadingItem(),
              //   itemCount: contentItems.length,
              //   itemBuilder: (context, index) => contentItems[index],
              // ),
            };
            final reporter = organization.getReporter();
            return FavoriteScaffold<Competition>(
              dataObject: competition,
              label: localizations.competition,
              details: competition.name,
              tabs: [Tab(child: HeadingText(localizations.info)), boutConfigTab, ...tabItems.keys],
              body: TabGroup(items: [description, boutConfigTabContent, ...tabItems.values]),
              actions: [
                ResponsiveScaffoldActionItem(
                  onTap: () async => navigateToScratchBoutOverview(context, ref, boutConfig: competition.boutConfig),
                  icon: const Icon(Icons.rocket_launch),
                  label: localizations.launchScratchBout,
                ),
                // if (organization != null)
                //   ConditionalOrganizationImportAction(
                //       id: id, organization: organization!, importType: OrganizationImportType.competition),
                // TODO: replace with file_save when https://github.com/flutter/flutter/issues/102560 is merged, also replace in settings.
                ResponsiveScaffoldActionItem(
                  label:
                      reporter == null
                          ? 'No reporter available. Please select one in the organization editor of ${organization.name}.'
                          : localizations.report,
                  icon: const Icon(Icons.description),
                  onTap:
                      reporter == null
                          ? null
                          : () async {
                            final cbouts = await _getBouts(ref, competition: competition);
                            final boutMap = Map.fromEntries(
                              await Future.wait(
                                cbouts.map((bout) async => MapEntry(bout, await _getActions(ref, bout: bout.bout))),
                              ),
                            );
                            final weightCategories = await ref.readAsync(
                              manyDataStreamProvider(
                                ManyProviderData<CompetitionWeightCategory, Competition>(filterObject: competition),
                              ).future,
                            );
                            final weightCategoriesMap = Map.fromEntries(
                              await Future.wait(
                                weightCategories.map(
                                  (wc) async => MapEntry(
                                    wc,
                                    await ref.readAsync(
                                      manyDataStreamProvider(
                                        ManyProviderData<CompetitionParticipation, CompetitionWeightCategory>(
                                          filterObject: wc,
                                        ),
                                      ).future,
                                    ),
                                  ),
                                ),
                              ),
                            );
                            final reportStr = reporter.exportCompetitionReport(
                              competition: competition,
                              boutMap: boutMap,
                              boutResultRules: await ref.readAsync(
                                manyDataStreamProvider(
                                  ManyProviderData<BoutResultRule, BoutConfig>(filterObject: competition.boutConfig),
                                ).future,
                              ),
                              competitionLineups: await ref.readAsync(
                                manyDataStreamProvider(
                                  ManyProviderData<CompetitionLineup, Competition>(filterObject: competition),
                                ).future,
                              ),
                              competitionSystems: await ref.readAsync(
                                manyDataStreamProvider(
                                  ManyProviderData<CompetitionSystemAffiliation, Competition>(
                                    filterObject: competition,
                                  ),
                                ).future,
                              ),
                              competitionAgeCategories: await ref.readAsync(
                                manyDataStreamProvider(
                                  ManyProviderData<CompetitionAgeCategory, Competition>(filterObject: competition),
                                ).future,
                              ),
                              competitionWeightCategoryMap: weightCategoriesMap,
                            );

                            await exportRDB(fileBaseName: competition.fileBaseName, rdbString: reportStr);
                          },
                ),
                // pdfAction,
                ResponsiveScaffoldActionItem(
                  icon: const Icon(Icons.tv),
                  onTap: () => _handleSelectedCompetitionDisplay(competition, context),
                  label: localizations.display,
                  style: ResponsiveScaffoldActionItemStyle.elevatedIconAndText,
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<List<CompetitionBout>> _getBouts(WidgetRef ref, {required Competition competition}) => ref.readAsync(
    manyDataStreamProvider<CompetitionBout, Competition>(
      ManyProviderData<CompetitionBout, Competition>(filterObject: competition),
    ).future,
  );

  Future<List<BoutAction>> _getActions(WidgetRef ref, {required Bout bout}) => ref.readAsync(
    manyDataStreamProvider<BoutAction, Bout>(ManyProviderData<BoutAction, Bout>(filterObject: bout)).future,
  );

  void _handleSelectedCompetitionDisplay(Competition competition, BuildContext context) {
    context.push('/${CompetitionOverview.route}/${competition.id}/${CompetitionDisplay.route}');
  }

  void _handleSelectedWeightCategory(BuildContext context, CompetitionWeightCategory weightCategory) {
    context.push('/${CompetitionWeightCategoryOverview.route}/${weightCategory.id}');
  }

  void _handleSelectedCompetitionSystemAffiliation(BuildContext context, CompetitionSystemAffiliation affiliation) {
    context.push('/${CompetitionSystemAffiliationOverview.route}/${affiliation.id}');
  }

  void _handleSelectedCompetitionLineup(BuildContext context, CompetitionLineup lineup) {
    context.push('/${CompetitionLineupOverview.route}/${lineup.id}');
  }

  void _handleSelectedCompetitionAgeCategory(BuildContext context, CompetitionAgeCategory competitionAgeCategory) {
    context.push('/${CompetitionAgeCategoryOverview.route}/${competitionAgeCategory.id}');
  }
}

extension CompetitionFileExt on Competition {
  String get fileBaseName {
    final fileNameBuilder = [date.toFileNameDateFormat(), no, name];
    fileNameBuilder.removeWhere((e) => e == null || e.isEmpty);
    return fileNameBuilder.map((e) => e!.replaceAll(' ', '-')).join('_');
  }
}
