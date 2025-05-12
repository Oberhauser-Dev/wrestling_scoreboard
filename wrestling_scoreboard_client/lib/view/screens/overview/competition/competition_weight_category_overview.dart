import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/wrestling_style.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/competition/weight_category_display.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/competition/competition_participation_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/competition/competition_weight_category_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_participation_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
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
              title: competitionWeightCategory.ageCategory.name,
              subtitle: localizations.ageCategory,
              icon: Icons.school,
            ),
            ContentItem(
              title: competitionWeightCategory.weightClass.name,
              subtitle: localizations.weightClass,
              icon: Icons.label,
            ),
            ContentItem(
              title:
                  '${competitionWeightCategory.weightClass.style.localize(context)} (${competitionWeightCategory.weightClass.style.abbreviation(context)})',
              subtitle: localizations.wrestlingStyle,
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.tv),
                onPressed: () => _handleSelectedWeightCategoryDisplay(competitionWeightCategory, context),
                label: Text(localizations.display),
              ),
            ),
            EditAction(
              icon: const Icon(Icons.autorenew),
              label: Text(localizations.generate),
              onSubmit: () async {
                final hasConfirmed = await showOkCancelDialog(
                  context: context,
                  child: Text(localizations.warningBoutGenerate),
                );
                if (hasConfirmed && context.mounted) {
                  await catchAsync(context, () => _handleSubmit(ref, navigator, competitionWeightCategory));
                }
              },
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
                      onTap: () => _handleSelectedParticipation(item, context),
                    ),
              ),
            ],
          ),
        );
      },
    );
  }

  _handleSelectedParticipation(CompetitionParticipation participation, BuildContext context) {
    context.push('/${CompetitionParticipationOverview.route}/${participation.id}');
  }

  _handleSelectedWeightCategoryDisplay(CompetitionWeightCategory category, BuildContext context) {
    context.push(
      '/${CompetitionOverview.route}/${category.competition.id}/${CompetitionWeightCategoryOverview.route}/${category.id}/${CompetitionWeightCategoryDisplay.route}',
    );
  }

  Future<void> _handleSubmit(WidgetRef ref, NavigatorState navigator, CompetitionWeightCategory weightCategory) async {
    final dataManager = await ref.read(dataManagerNotifierProvider);
    await dataManager.generateBouts<CompetitionWeightCategory>(weightCategory, false);
    navigator.pop();
  }
}
