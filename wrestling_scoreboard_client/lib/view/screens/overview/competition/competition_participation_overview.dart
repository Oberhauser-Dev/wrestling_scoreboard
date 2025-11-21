import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/contestant_status.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/competition/competition_participation_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_lineup_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_weight_category_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/membership_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/image.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
import 'package:wrestling_scoreboard_client/view/widgets/tab_group.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class CompetitionParticipationOverview extends ConsumerWidget {
  static const route = 'competition_participation';

  static void navigateTo(BuildContext context, CompetitionParticipation participation) {
    context.push('/$route/${participation.id}');
  }

  final int id;
  final CompetitionParticipation? competitionParticipation;

  const CompetitionParticipationOverview({super.key, required this.id, this.competitionParticipation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = context.l10n;
    return SingleConsumer<CompetitionParticipation>(
      id: id,
      initialData: competitionParticipation,
      builder: (context, competitionParticipation) {
        final description = InfoWidget(
          obj: competitionParticipation,
          editPage: CompetitionParticipationEdit(
            competitionParticipation: competitionParticipation,
            initialLineup: competitionParticipation.lineup,
            initialCompetition: competitionParticipation.lineup.competition,
          ),
          onDelete:
              () async => (await ref.read(
                dataManagerProvider,
              )).deleteSingle<CompetitionParticipation>(competitionParticipation),
          classLocale: localizations.participation,
          children: [
            ContentItem.icon(
              title: competitionParticipation.lineup.club.name,
              subtitle: localizations.lineup,
              iconData: Icons.view_list,
              onTap: () => CompetitionLineupOverview.navigateTo(context, competitionParticipation.lineup),
            ),
            ContentItem(
              title: competitionParticipation.membership.info,
              subtitle: localizations.membership,
              icon:
                  competitionParticipation.membership.person.imageUri == null
                      ? Icon(Icons.person)
                      : CircularImage(imageUri: competitionParticipation.membership.person.imageUri!),
              onTap: () => MembershipOverview.navigateTo(context, competitionParticipation.membership),
            ),
            ContentItem.icon(
              title: competitionParticipation.weightCategory?.name ?? '-',
              subtitle: localizations.weightCategory,
              iconData: Icons.category,
              onTap:
                  competitionParticipation.weightCategory == null
                      ? null
                      : () => CompetitionWeightCategoryOverview.navigateTo(
                        context,
                        competitionParticipation.weightCategory!,
                      ),
            ),
            ContentItem.icon(
              title: competitionParticipation.weight?.toString() ?? '-',
              subtitle: localizations.weight,
              iconData: Icons.fitness_center,
            ),
            ContentItem.icon(
              title: competitionParticipation.poolGroup?.toString() ?? '-',
              subtitle: localizations.pool,
              iconData: Icons.pool,
            ),
            ContentItem.icon(
              title: competitionParticipation.displayPoolDrawNumber?.toString() ?? '-',
              subtitle: localizations.numberAbbreviation,
              iconData: Icons.numbers,
            ),
            ContentItem.icon(
              title: competitionParticipation.contestantStatus?.localize(context) ?? '-',
              subtitle: localizations.contestantStatus,
              iconData: Icons.cancel_outlined,
            ),
          ],
        );
        return FavoriteScaffold<CompetitionParticipation>(
          dataObject: competitionParticipation,
          label: localizations.participation,
          details: competitionParticipation.name,
          tabs: [Tab(child: HeadingText(localizations.info))],
          body: TabGroup(items: [description]),
        );
      },
    );
  }
}
