import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/weight_class.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/competition/weight_category_display.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/competition/competition_participation_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/competition/competition_weight_category_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_participation_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';
import 'package:wrestling_scoreboard_client/view/widgets/tab_group.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class CompetitionWeightCategoryOverview extends ConsumerWidget {
  static const route = 'competition_weight_category';

  final int id;
  final CompetitionWeightCategory? competitionWeightCategory;

  const CompetitionWeightCategoryOverview({super.key, required this.id, this.competitionWeightCategory});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigator = Navigator.of(context);
    final localizations = context.l10n;
    return SingleConsumer<CompetitionWeightCategory>(
      id: id,
      initialData: competitionWeightCategory,
      builder: (context, competitionWeightCategory) {
        final description = InfoWidget(
          obj: competitionWeightCategory,
          editPage: CompetitionWeightCategoryEdit(
            competitionWeightCategory: competitionWeightCategory,
            initialCompetition: competitionWeightCategory.competition,
          ),
          onDelete:
              () async => (await ref.read(
                dataManagerNotifierProvider,
              )).deleteSingle<CompetitionWeightCategory>(competitionWeightCategory),
          classLocale: localizations.weightCategory,
          children: [
            ContentItem(
              title: competitionWeightCategory.competition.name,
              subtitle: localizations.competition,
              icon: Icons.leaderboard,
            ),
            ContentItem(
              title: competitionWeightCategory.competitionAgeCategory.ageCategory.name,
              subtitle: localizations.ageCategory,
              icon: Icons.school,
            ),
            ContentItem(
              title: competitionWeightCategory.weightClass.localize(context),
              subtitle: localizations.weightClass,
              icon: Icons.style,
            ),
            ContentItem(
              title: competitionWeightCategory.competitionSystem?.name ?? '-',
              subtitle: localizations.competitionSystem,
              icon: Icons.label,
            ),
            ContentItem(
              title: competitionWeightCategory.poolGroupCount.toString(),
              subtitle: localizations.poolGroupCount,
              icon: Icons.pool,
            ),
          ],
        );
        return FavoriteScaffold<CompetitionWeightCategory>(
          dataObject: competitionWeightCategory,
          label: localizations.weightCategory,
          details: competitionWeightCategory.name,
          actions: [
            ResponsiveScaffoldActionItem(
              style: ResponsiveScaffoldActionItemStyle.elevatedIconAndText,
              icon: const Icon(Icons.tv),
              onTap: () => _handleSelectedWeightCategoryDisplay(competitionWeightCategory, context),
              label: localizations.display,
            ),
            ResponsiveScaffoldActionItem(
              icon: const Icon(Icons.autorenew),
              label: localizations.generate,
              onTap: () async {
                final hasConfirmed = await showOkCancelDialog(
                  context: context,
                  child: Text(localizations.warningBoutGenerate),
                );
                if (hasConfirmed && context.mounted) {
                  await catchAsync(context, () async {
                    await _handleGenerateBouts(ref, navigator, competitionWeightCategory);
                    if (context.mounted) {
                      await showOkDialog(context: context, child: Text(localizations.actionSuccessful));
                    }
                  });
                }
              },
              style: ResponsiveScaffoldActionItemStyle.elevatedIconAndText,
            ),
          ],
          tabs: [Tab(child: HeadingText(localizations.info)), Tab(child: HeadingText(localizations.participations))],
          body: TabGroup(
            items: [
              description,
              FilterableManyConsumer<CompetitionParticipation, CompetitionWeightCategory>.edit(
                context: context,
                filterObject: competitionWeightCategory,
                editPageBuilder:
                    (context) => CompetitionParticipationEdit(
                      initialCompetition: competitionWeightCategory.competition,
                      initialWeightCategory: competitionWeightCategory,
                    ),
                mapData: (participations) => participations..sort((a, b) => a.name.compareTo(b.name)),
                itemBuilder:
                    (context, item) => ContentItem(
                      title: item.name,
                      icon: Icons.person,
                      onTap: () => navigateToCompetitionParticipationOverview(context, item),
                    ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleSelectedWeightCategoryDisplay(CompetitionWeightCategory category, BuildContext context) {
    context.push(
      '/${CompetitionOverview.route}/${category.competition.id}/${CompetitionWeightCategoryOverview.route}/${category.id}/${CompetitionWeightCategoryDisplay.route}',
    );
  }

  Future<void> _handleGenerateBouts(
    WidgetRef ref,
    NavigatorState navigator,
    CompetitionWeightCategory weightCategory,
  ) async {
    final dataManager = await ref.read(dataManagerNotifierProvider);
    // TODO: set isReset to false, when more general approach to generate bouts is available
    await dataManager.generateBouts<CompetitionWeightCategory>(weightCategory, true);
  }
}
