import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_match/league_team_participation_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/league_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
import 'package:wrestling_scoreboard_client/view/widgets/tab_group.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class LeagueTeamParticipationOverview extends ConsumerWidget {
  static const route = 'league_team_participation';

  static void navigateTo(BuildContext context, LeagueTeamParticipation leagueTeamParticipation) {
    context.push('/$route/${leagueTeamParticipation.id}');
  }

  final int id;
  final LeagueTeamParticipation? leagueTeamParticipation;

  const LeagueTeamParticipationOverview({super.key, required this.id, this.leagueTeamParticipation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = context.l10n;
    return SingleConsumer<LeagueTeamParticipation>(
      id: id,
      initialData: leagueTeamParticipation,
      builder: (context, data) {
        final description = InfoWidget(
          obj: data,
          editPage: LeagueTeamParticipationEdit(participation: data),
          onDelete:
              () async => (await ref.read(dataManagerNotifierProvider)).deleteSingle<LeagueTeamParticipation>(data),
          classLocale: localizations.team,
          children: [
            ContentItem(
              title: data.team.name,
              subtitle: localizations.team,
              icon: Icons.group,
              onTap: () => TeamOverview.navigateTo(context, data.team),
            ),
            ContentItem(
              title: '${data.league.fullname}, ${data.league.startDate.toDateString(context)}',
              subtitle: localizations.league,
              icon: Icons.emoji_events,
              onTap: () => LeagueOverview.navigateTo(context, data.league),
            ),
          ],
        );
        return FavoriteScaffold<LeagueTeamParticipation>(
          dataObject: data,
          label: localizations.participatingTeam,
          details: data.team.name,
          tabs: [Tab(child: HeadingText(localizations.info))],
          body: TabGroup(items: [description]),
        );
      },
    );
  }
}
