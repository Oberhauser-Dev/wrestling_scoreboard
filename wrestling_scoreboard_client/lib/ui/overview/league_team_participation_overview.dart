import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_client/ui/components/consumer.dart';
import 'package:wrestling_scoreboard_client/ui/components/exception.dart';
import 'package:wrestling_scoreboard_client/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard_client/ui/components/info.dart';
import 'package:wrestling_scoreboard_client/ui/edit/league_team_participation_edit.dart';
import 'package:wrestling_scoreboard_client/ui/overview/common.dart';
import 'package:wrestling_scoreboard_client/util/network/data_provider.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class LeagueTeamParticipationOverview extends StatelessWidget {
  static const route = 'league_team_participation';

  final int id;
  final LeagueTeamParticipation? leagueTeamParticipation;

  const LeagueTeamParticipationOverview({Key? key, required this.id, this.leagueTeamParticipation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return SingleConsumer<LeagueTeamParticipation>(
      id: id,
      initialData: leagueTeamParticipation,
      builder: (context, data) {
        if (data == null) return ExceptionWidget(localizations.notFoundException);
        final description = InfoWidget(
            obj: data,
            editPage: LeagueTeamParticipationEdit(
              participation: data,
            ),
            onDelete: () => dataProvider.deleteSingle<LeagueTeamParticipation>(data),
            classLocale: localizations.team,
            children: [
              ContentItem(
                title: data.team.name,
                subtitle: localizations.team,
                icon: Icons.group,
              ),
              ContentItem(
                title: data.league.name,
                subtitle: localizations.league,
                icon: Icons.emoji_events,
              ),
            ]);
        return Scaffold(
          appBar: AppBar(
            title: AppBarTitle(label: localizations.participatingTeam, details: data.team.name),
          ),
          body: GroupedList(items: [
            description,
          ]),
        );
      },
    );
  }
}
