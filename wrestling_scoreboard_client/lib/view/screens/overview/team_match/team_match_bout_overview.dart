import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/bout_display.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_match/team_match_bout_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/bout_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/team_match_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class TeamMatchBoutOverview extends BoutOverview {
  static const route = 'team_match_bout';

  final int id;
  final TeamMatchBout? teamMatchBout;

  const TeamMatchBoutOverview({super.key, required this.id, this.teamMatchBout});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    return SingleConsumer<TeamMatchBout>(
      id: id,
      initialData: teamMatchBout,
      builder: (context, data) {
        return buildOverview(
          context,
          ref,
          classLocale: localizations.bout,
          editPage: TeamMatchBoutEdit(
            teamMatchBout: data,
            initialTeamMatch: data.teamMatch,
          ),
          onDelete: () async => (await ref.read(dataManagerNotifierProvider)).deleteSingle<TeamMatchBout>(data),
          tiles: [],
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.tv),
                onPressed: () => handleSelectedBoutDisplay(data, context),
                label: Text(localizations.display),
              ),
            )
          ],
          dataId: data.bout.id!,
          initialData: data.bout,
        );
      },
    );
  }

  handleSelectedBoutDisplay(TeamMatchBout bout, BuildContext context) {
    context.push(
        '/${TeamMatchOverview.route}/${bout.teamMatch.id}/${TeamMatchBoutOverview.route}/${bout.id}/${TeamMatchBoutDisplay.route}');
  }
}
