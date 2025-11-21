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
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_age_category_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_participation_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/image.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';
import 'package:wrestling_scoreboard_client/view/widgets/tab_group.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class CompetitionWeightCategoryOverview extends ConsumerWidget {
  static const route = 'competition_weight_category';

  static void navigateTo(BuildContext context, CompetitionWeightCategory dataObject) {
    context.push('/$route/${dataObject.id}');
  }

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
                dataManagerProvider,
              )).deleteSingle<CompetitionWeightCategory>(competitionWeightCategory),
          classLocale: localizations.weightCategory,
          children: [
            ContentItem.icon(
              title: competitionWeightCategory.competition.name,
              subtitle: localizations.competition,
              iconData: Icons.leaderboard,
              onTap: () => CompetitionOverview.navigateTo(context, competitionWeightCategory.competition),
            ),
            ContentItem.icon(
              title: competitionWeightCategory.competitionAgeCategory.ageCategory.name,
              subtitle: localizations.ageCategory,
              iconData: Icons.school,
              onTap:
                  () => CompetitionAgeCategoryOverview.navigateTo(
                    context,
                    competitionWeightCategory.competitionAgeCategory,
                  ),
            ),
            ContentItem.icon(
              title: competitionWeightCategory.weightClass.localize(context),
              subtitle: localizations.weightClass,
              iconData: Icons.style,
              // TODO: View weight class (?)
            ),
            ContentItem.icon(
              title: competitionWeightCategory.competitionSystem?.name ?? '-',
              subtitle: localizations.competitionSystem,
              iconData: Icons.label,
            ),
            ContentItem.icon(
              title: competitionWeightCategory.poolGroupCount.toString(),
              subtitle: localizations.poolGroupCount,
              iconData: Icons.pool,
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
              onTap: () => CompetitionWeightCategoryDisplay.navigateTo(context, competitionWeightCategory),
              label: localizations.display,
            ),
            ResponsiveScaffoldActionItem(
              icon: const Icon(Icons.autorenew),
              label: localizations.pairBouts,
              onTap: () async {
                final hasConfirmed = await showOkCancelDialog(
                  context: context,
                  title: Text(localizations.pairBouts),
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
              FilterableManyConsumer<CompetitionParticipation, CompetitionWeightCategory>.add(
                context: context,
                filterObject: competitionWeightCategory,
                addPageBuilder:
                    (context) => CompetitionParticipationEdit(
                      initialCompetition: competitionWeightCategory.competition,
                      initialWeightCategory: competitionWeightCategory,
                    ),
                mapData: (participations) => participations..sort((a, b) => a.name.compareTo(b.name)),
                itemBuilder:
                    (context, item) => ContentItem(
                      title: item.name,
                      icon:
                          item.membership.person.imageUri == null
                              ? Icon(Icons.person)
                              : CircularImage(imageUri: item.membership.person.imageUri!),
                      onTap: () => CompetitionParticipationOverview.navigateTo(context, item),
                    ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleGenerateBouts(
    WidgetRef ref,
    NavigatorState navigator,
    CompetitionWeightCategory weightCategory,
  ) async {
    final dataManager = await ref.read(dataManagerProvider);
    // TODO: set isReset to false, when more general approach to generate bouts is available
    await dataManager.generateBouts<CompetitionWeightCategory>(weightCategory, true);
  }
}
