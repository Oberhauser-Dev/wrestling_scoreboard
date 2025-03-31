import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/competition/competition_lineup_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
import 'package:wrestling_scoreboard_client/view/widgets/tab_group.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class CompetitionLineupOverview extends ConsumerWidget {
  static const route = 'competition_lineup';

  final int id;
  final CompetitionLineup? competitionLineup;

  const CompetitionLineupOverview({super.key, required this.id, this.competitionLineup});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = context.l10n;
    return SingleConsumer<CompetitionLineup>(
      id: id,
      initialData: competitionLineup,
      builder: (context, competitionLineup) {
        final description = InfoWidget(
          obj: competitionLineup,
          editPage: CompetitionLineupEdit(
            competitionLineup: competitionLineup,
            initialCompetition: competitionLineup.competition,
          ),
          onDelete: () async =>
              (await ref.read(dataManagerNotifierProvider)).deleteSingle<CompetitionLineup>(competitionLineup),
          classLocale: localizations.lineup,
          children: [
            ContentItem(
              title: competitionLineup.club.name,
              subtitle: localizations.club,
              icon: Icons.foundation,
            ),
            ContentItem(
              title: competitionLineup.competition.name,
              subtitle: localizations.competition,
              icon: Icons.leaderboard,
            ),
          ],
        );
        return FavoriteScaffold<CompetitionLineup>(
          dataObject: competitionLineup,
          label: localizations.lineup,
          details: competitionLineup.club.name,
          tabs: [
            Tab(child: HeadingText(localizations.info)),
          ],
          body: TabGroup(items: [
            description,
          ]),
        );
      },
    );
  }
}
