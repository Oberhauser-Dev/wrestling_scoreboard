import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/competition/competition_age_category_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/competition/competition_weight_category_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/age_category_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_weight_category_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
import 'package:wrestling_scoreboard_client/view/widgets/tab_group.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class CompetitionAgeCategoryOverview extends ConsumerWidget {
  static const route = 'competition_age_category';

  static void navigateTo(BuildContext context, CompetitionAgeCategory dataObject) {
    context.push('/$route/${dataObject.id}');
  }

  final int id;
  final CompetitionAgeCategory? competitionAgeCategory;

  const CompetitionAgeCategoryOverview({super.key, required this.id, this.competitionAgeCategory});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = context.l10n;
    return SingleConsumer<CompetitionAgeCategory>(
      id: id,
      initialData: competitionAgeCategory,
      builder: (context, competitionAgeCategory) {
        final description = InfoWidget(
          obj: competitionAgeCategory,
          editPage: CompetitionAgeCategoryEdit(
            competitionAgeCategory: competitionAgeCategory,
            initialCompetition: competitionAgeCategory.competition,
          ),
          onDelete:
              () async => (await ref.read(
                dataManagerNotifierProvider,
              )).deleteSingle<CompetitionAgeCategory>(competitionAgeCategory),
          classLocale: localizations.ageCategory,
          children: [
            ContentItem(
              title: competitionAgeCategory.competition.name,
              subtitle: localizations.competition,
              icon: Icons.leaderboard,
              onTap: () => CompetitionOverview.navigateTo(context, competitionAgeCategory.competition),
            ),
            ContentItem(
              title: competitionAgeCategory.ageCategory.name,
              subtitle: localizations.ageCategory,
              icon: Icons.school,
              onTap: () => AgeCategoryOverview.navigateTo(context, competitionAgeCategory.ageCategory),
            ),
          ],
        );
        return FavoriteScaffold<CompetitionAgeCategory>(
          dataObject: competitionAgeCategory,
          label: localizations.weightCategory,
          details: competitionAgeCategory.ageCategory.name,
          actions: [],
          tabs: [Tab(child: HeadingText(localizations.info)), Tab(child: HeadingText(localizations.weightCategories))],
          body: TabGroup(
            items: [
              description,
              FilterableManyConsumer<CompetitionWeightCategory, CompetitionAgeCategory>.add(
                context: context,
                addPageBuilder:
                    (context) => CompetitionWeightCategoryEdit(initialCompetition: competitionAgeCategory.competition),
                filterObject: competitionAgeCategory,
                itemBuilder: (context, weightCategory) {
                  return ContentItem(
                    title: weightCategory.name,
                    icon: Icons.fitness_center,
                    onTap: () async => CompetitionWeightCategoryOverview.navigateTo(context, weightCategory),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
