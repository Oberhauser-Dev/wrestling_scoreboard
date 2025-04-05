import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/competition/competition_participation_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/competition/competition_weight_category_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_participation_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
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
          onDelete: () async => (await ref.read(dataManagerNotifierProvider))
              .deleteSingle<CompetitionWeightCategory>(competitionWeightCategory),
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
          ],
        );
        return FavoriteScaffold<CompetitionWeightCategory>(
          dataObject: competitionWeightCategory,
          label: localizations.weightCategory,
          details: competitionWeightCategory.name,
          tabs: [
            Tab(child: HeadingText(localizations.info)),
            Tab(child: HeadingText(localizations.participations)),
          ],
          body: TabGroup(items: [
            description,
            FilterableManyConsumer<CompetitionParticipation, CompetitionWeightCategory>.edit(
              context: context,
              filterObject: competitionWeightCategory,
              editPageBuilder: (context) =>
                  CompetitionParticipationEdit(initialCompetition: competitionWeightCategory.competition),
              mapData: (participations) => participations..sort((a, b) => a.name.compareTo(b.name)),
              itemBuilder: (context, item) => ContentItem(
                title: item.name,
                icon: Icons.person,
                onTap: () => _handleSelectedParticipation(item, context),
              ),
            ),
          ]),
        );
      },
    );
  }

  _handleSelectedParticipation(CompetitionParticipation participation, BuildContext context) {
    context.push('/${CompetitionParticipationOverview.route}/${participation.id}');
  }
}
