import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';
import 'package:wrestling_scoreboard_client/localization/person_role.dart';
import 'package:wrestling_scoreboard_client/provider/data_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/utils/export.dart';
import 'package:wrestling_scoreboard_client/utils/io.dart';
import 'package:wrestling_scoreboard_client/utils/provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/event/competition_display.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/competition/competition_age_category_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/competition/competition_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/competition/competition_lineup_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/competition/competition_person_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/competition/competition_system_affiliation_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/competition/competition_weight_category_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/person_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/bout_config_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_age_category_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_cycle_management.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_lineup_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_person_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_system_affiliation_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_weight_category_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/scratch_bout_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/shared/actions.dart';
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

  static void navigateTo(BuildContext context, Competition dataObject) {
    context.push('/$route/${dataObject.id}');
  }

  // FIXME: use `push` route, https://github.com/flutter/flutter/issues/140586
  static void goTo(BuildContext context, Competition competition) {
    context.go('/$route/${competition.id}');
  }

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
                ContentItem(title: competition.name, subtitle: localizations.name, icon: Icons.description),
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
              ): FilterableManyConsumer<CompetitionLineup, Competition>.add(
                context: context,
                addPageBuilder: (context) => CompetitionLineupEdit(initialCompetition: competition),
                filterObject: competition,
                itemBuilder: (context, lineup) {
                  return ContentItem(
                    title: lineup.club.name,
                    icon: Icons.view_list,
                    onTap: () async => CompetitionLineupOverview.navigateTo(context, lineup),
                  );
                },
              ),
              Tab(
                child: HeadingText(localizations.ageCategories),
              ): FilterableManyConsumer<CompetitionAgeCategory, Competition>.add(
                context: context,
                addPageBuilder: (context) => CompetitionAgeCategoryEdit(initialCompetition: competition),
                filterObject: competition,
                itemBuilder: (context, competitionAgeCategory) {
                  return ContentItem(
                    title: competitionAgeCategory.ageCategory.name,
                    icon: Icons.school,
                    onTap: () async => CompetitionAgeCategoryOverview.navigateTo(context, competitionAgeCategory),
                  );
                },
              ),
              Tab(
                child: HeadingText(localizations.weightCategories),
              ): FilterableManyConsumer<CompetitionWeightCategory, Competition>.add(
                context: context,
                addPageBuilder: (context) => CompetitionWeightCategoryEdit(initialCompetition: competition),
                filterObject: competition,
                itemBuilder: (context, weightCategory) {
                  return ContentItem(
                    title: weightCategory.name,
                    icon: Icons.fitness_center,
                    onTap: () async => CompetitionWeightCategoryOverview.navigateTo(context, weightCategory),
                  );
                },
              ),
              Tab(
                child: HeadingText(localizations.competitionSystems),
              ): FilterableManyConsumer<CompetitionSystemAffiliation, Competition>.add(
                context: context,
                addPageBuilder: (context) => CompetitionSystemAffiliationEdit(initialCompetition: competition),
                filterObject: competition,
                itemBuilder: (context, competitionSystemAffiliation) {
                  return ContentItem(
                    title:
                        '${competitionSystemAffiliation.poolGroupCount} × ${competitionSystemAffiliation.competitionSystem.name}',
                    icon: Icons.account_tree,
                    onTap:
                        () async =>
                            CompetitionSystemAffiliationOverview.navigateTo(context, competitionSystemAffiliation),
                  );
                },
              ),
              Tab(child: HeadingText(localizations.bouts)): CompetitionBoutList(filterObject: competition),
              Tab(
                child: HeadingText(localizations.officials),
              ): FilterableManyConsumer<CompetitionPerson, Competition>.addOrCreate(
                context: context,
                addPageBuilder:
                    (context) => CompetitionPersonEdit(
                      initialCompetition: competition,
                      initialOrganization: competition.organization!,
                    ),
                createPageBuilder:
                    (context) => PersonEdit(
                      initialOrganization: competition.organization!,
                      onCreated: (person) async {
                        // TODO: ability to change role inside another implementation of PersonEdit.
                        await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(
                          CompetitionPerson(competition: competition, person: person, role: PersonRole.steward),
                        );
                      },
                    ),
                filterObject: competition,
                itemBuilder: (context, competitionPerson) {
                  return ContentItem(
                    title: '${competitionPerson.role.localize(context)} | ${competitionPerson.person.fullName}',
                    // TODO: adapt icon to role
                    icon: Icons.person,
                    onTap: () async => CompetitionPersonOverview.navigateTo(context, competitionPerson),
                  );
                },
              ),
            };
            return FavoriteScaffold<Competition>(
              dataObject: competition,
              label: localizations.competition,
              details: competition.name,
              tabs: [Tab(child: HeadingText(localizations.info)), ...tabItems.keys, boutConfigTab],
              body: TabGroup(items: [description, ...tabItems.values, boutConfigTabContent]),
              actions: [
                ResponsiveScaffoldActionItem(
                  onTap: () async => ScratchBoutOverview.navigateTo(context, ref, boutConfig: competition.boutConfig),
                  icon: const Icon(Icons.rocket_launch),
                  label: localizations.launchScratchBout,
                ),
                // if (organization != null)
                //   ConditionalOrganizationImportAction(
                //       id: id, organization: organization!, importType: OrganizationImportType.competition),
                OrganizationReportActionItem(
                  context: context,
                  organization: organization,
                  onTap: (reporter) async {
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
                                ManyProviderData<CompetitionParticipation, CompetitionWeightCategory>(filterObject: wc),
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
                          ManyProviderData<CompetitionSystemAffiliation, Competition>(filterObject: competition),
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
                  onTap: () => CompetitionDisplay.navigateTo(context, competition),
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
}

extension CompetitionFileExt on Competition {
  String get fileBaseName {
    final fileNameBuilder = [date.toFileNameDateFormat(), no, name];
    fileNameBuilder.removeWhere((e) => e == null || e.isEmpty);
    return fileNameBuilder.map((e) => e!.replaceAll(' ', '-')).join('_');
  }
}
