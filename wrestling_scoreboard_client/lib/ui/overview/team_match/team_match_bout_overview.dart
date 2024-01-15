import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_client/ui/components/consumer.dart';
import 'package:wrestling_scoreboard_client/ui/edit/team_match/team_match_bout_edit.dart';
import 'package:wrestling_scoreboard_client/ui/overview/bout_overview.dart';
import 'package:wrestling_scoreboard_client/util/network/data_provider.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class TeamMatchBoutOverview extends BoutOverview {
  static const route = 'team_match_bout';

  final int id;
  final TeamMatchBout? teamMatchBout;

  const TeamMatchBoutOverview({super.key, required this.id, this.teamMatchBout});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return SingleConsumer<TeamMatchBout>(
      id: id,
      initialData: teamMatchBout,
      builder: (context, data) {
        return buildOverview(context,
            classLocale: localizations.bout,
            editPage: TeamMatchBoutEdit(
              teamMatchBout: data,
              initialTeamMatch: data.teamMatch,
            ),
            onDelete: () => dataProvider.deleteSingle<TeamMatchBout>(data),
            tiles: [],
            dataId: data.bout.id!,
            initialData: data.bout);
      },
    );
  }
}
