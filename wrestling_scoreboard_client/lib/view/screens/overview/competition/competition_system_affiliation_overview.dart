import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/competition/competition_system_affiliation_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
import 'package:wrestling_scoreboard_client/view/widgets/tab_group.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class CompetitionSystemAffiliationOverview extends ConsumerWidget {
  static const route = 'competition_system_affiliation';

  static void navigateTo(BuildContext context, CompetitionSystemAffiliation dataObject) {
    context.push('/$route/${dataObject.id}');
  }

  final int id;
  final CompetitionSystemAffiliation? competitionSystemAffiliation;

  const CompetitionSystemAffiliationOverview({super.key, required this.id, this.competitionSystemAffiliation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = context.l10n;
    return SingleConsumer<CompetitionSystemAffiliation>(
      id: id,
      initialData: competitionSystemAffiliation,
      builder: (context, competitionSystemAffiliation) {
        final description = InfoWidget(
          obj: competitionSystemAffiliation,
          editPage: CompetitionSystemAffiliationEdit(
            competitionSystemAffiliation: competitionSystemAffiliation,
            initialCompetition: competitionSystemAffiliation.competition,
          ),
          onDelete:
              () async => (await ref.read(
                dataManagerProvider,
              )).deleteSingle<CompetitionSystemAffiliation>(competitionSystemAffiliation),
          classLocale: localizations.competitionSystem,
          children: [
            ContentItem.icon(
              title: competitionSystemAffiliation.competition.name,
              subtitle: localizations.competition,
              iconData: Icons.leaderboard,
              onTap: () => CompetitionOverview.navigateTo(context, competitionSystemAffiliation.competition),
            ),
            ContentItem.icon(
              title: competitionSystemAffiliation.competitionSystem.name,
              subtitle: localizations.competitionSystem,
              iconData: Icons.label,
            ),
            ContentItem.icon(
              title: competitionSystemAffiliation.poolGroupCount.toString(),
              subtitle: localizations.poolGroupCount,
              iconData: Icons.pool,
            ),
            ContentItem.icon(
              title: competitionSystemAffiliation.maxContestants?.toString() ?? 'unset',
              subtitle: '${localizations.participations} (${localizations.maximum})',
              iconData: Icons.numbers,
            ),
          ],
        );
        return FavoriteScaffold<CompetitionSystemAffiliation>(
          dataObject: competitionSystemAffiliation,
          label: localizations.competitionSystem,
          details: competitionSystemAffiliation.competitionSystem.name,
          tabs: [Tab(child: HeadingText(localizations.info))],
          body: TabGroup(items: [description]),
        );
      },
    );
  }
}
