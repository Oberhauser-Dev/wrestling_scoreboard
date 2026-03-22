import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/competition.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/competition/competition_system_phase_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_system_affiliation_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
import 'package:wrestling_scoreboard_client/view/widgets/tab_group.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class CompetitionSystemPhaseOverview extends ConsumerWidget {
  static const route = 'competition_system_phase';

  static void navigateTo(BuildContext context, CompetitionSystemPhase dataObject) {
    context.push('/$route/${dataObject.id}');
  }

  final int id;
  final CompetitionSystemPhase? competitionSystemPhase;

  const CompetitionSystemPhaseOverview({super.key, required this.id, this.competitionSystemPhase});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = context.l10n;
    return SingleConsumer<CompetitionSystemPhase>(
      id: id,
      initialData: competitionSystemPhase,
      builder: (context, competitionSystemPhase) {
        final description = InfoWidget(
          obj: competitionSystemPhase,
          editPage: CompetitionSystemPhaseEdit(
            competitionSystemPhase: competitionSystemPhase,
            initialCompetitionSystemAffiliation: competitionSystemPhase.competitionSystemAffiliation,
          ),
          onDelete: () async =>
              (await ref.read(dataManagerProvider)).deleteSingle<CompetitionSystemPhase>(competitionSystemPhase),
          classLocale: localizations.competitionSystem,
          children: [
            ContentItem.icon(
              title: competitionSystemPhase.competitionSystemAffiliation.localize(context),
              subtitle: localizations.competition,
              iconData: Icons.leaderboard,
              onTap: () => CompetitionSystemAffiliationOverview.navigateTo(
                context,
                competitionSystemPhase.competitionSystemAffiliation,
              ),
            ),
            ContentItem.icon(
              title: competitionSystemPhase.competitionSystem.localize(context),
              subtitle: localizations.competitionSystem,
              iconData: Icons.label,
            ),
            ContentItem.icon(
              title: competitionSystemPhase.poolGroupCount.toString(),
              subtitle: localizations.poolGroupCount,
              iconData: Icons.pool,
            ),
            ContentItem.icon(
              title: localizations.holdBoutsForRanks(
                CompetitionSystemPhase.displayMaxRanks(competitionSystemPhase.maxRank),
              ),
              subtitle: '${localizations.rank} (${localizations.maximum})',
              iconData: Icons.vertical_align_top,
            ),
            ContentItem.icon(
              title: competitionSystemPhase.isCrossOver ? localizations.enabled : localizations.disabled,
              subtitle: localizations.crossOver,
              iconData: Icons.shuffle,
            ),
          ],
        );
        return FavoriteScaffold<CompetitionSystemPhase>(
          dataObject: competitionSystemPhase,
          label: localizations.phase,
          details: competitionSystemPhase.competitionSystem.localize(context),
          tabs: [Tab(child: HeadingText(localizations.info))],
          body: TabGroup(items: [description]),
        );
      },
    );
  }
}
