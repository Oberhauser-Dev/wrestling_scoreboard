import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';
import 'package:wrestling_scoreboard_client/localization/season.dart';
import 'package:wrestling_scoreboard_client/localization/wrestling_style.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_match/league_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_match/league_team_participation_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_match/league_weight_class_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/shared/matches_widget.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/league_team_participation_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/league_weight_class_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class LeagueOverview extends ConsumerWidget {
  static const route = 'league';

  final int id;
  final League? league;

  const LeagueOverview({super.key, required this.id, this.league});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    return SingleConsumer<League>(
      id: id,
      initialData: league,
      builder: (context, data) {
        final description = InfoWidget(
          obj: data,
          editPage: LeagueEdit(
            league: data,
          ),
          onDelete: () async => (await ref.read(dataManagerNotifierProvider)).deleteSingle<League>(data),
          classLocale: localizations.league,
          children: [
            ContentItem(
              title: data.startDate.toDateString(context),
              subtitle: localizations.date, // Start date
              icon: Icons.emoji_events,
            ),
            ContentItem(
              title: '${data.boutConfig.periodDuration.inSeconds} ✕ ${data.boutConfig.periodCount}',
              // '${localizations.breakDurationInSecs}: ${data.boutConfig.breakDuration.inSeconds}, '
              // '${localizations.activityDurationInSecs}: ${data.boutConfig.activityDuration.inSeconds}, '
              // '${localizations.injuryDurationInSecs}: ${data.boutConfig.injuryDuration.inSeconds}',
              subtitle: localizations.periodDurationInSecs, // Start date
              icon: Icons.timer,
            ),
            ContentItem(
              title: data.seasonPartitions.toString(),
              subtitle: localizations.seasonPartitions,
              icon: Icons.sunny_snowing,
            ),
          ],
        );
        return Scaffold(
          appBar: AppBar(
            title: AppBarTitle(label: localizations.league, details: data.name),
          ),
          body: GroupedList(items: [
            description,
            ManyConsumer<LeagueTeamParticipation, League>(
              filterObject: data,
              builder: (BuildContext context, List<LeagueTeamParticipation> teamParticipations) {
                return ListGroup(
                  header: HeadingItem(
                    title: localizations.participatingTeams,
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LeagueTeamParticipationEdit(
                            initialLeague: data,
                          ),
                        ),
                      ),
                    ),
                  ),
                  items: teamParticipations.map(
                    (e) => SingleConsumer<LeagueTeamParticipation>(
                        id: e.id,
                        initialData: e,
                        builder: (context, data) {
                          return ContentItem(
                            title: data.team.name,
                            icon: Icons.group,
                            onTap: () => handleSelectedTeam(data, context),
                          );
                        }),
                  ),
                );
              },
            ),
            MatchesWidget<League>(filterObject: data),
            ManyConsumer<LeagueWeightClass, League>(
              filterObject: data,
              builder: (BuildContext context, List<LeagueWeightClass> leagueWeightClasses) {
                return ListGroup(
                  header: HeadingItem(
                    title: localizations.weightClasses,
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LeagueWeightClassEdit(initialLeague: data),
                        ),
                      ),
                    ),
                  ),
                  items: leagueWeightClasses.map((e) {
                    return SingleConsumer<LeagueWeightClass>(
                      id: e.id,
                      initialData: e,
                      builder: (context, data) {
                        return ContentItem(
                            title:
                                '${data.weightClass.name} ${data.weightClass.style.localize(context)} ${data.seasonPartition == null ? '' : '(${data.seasonPartition!.asSeasonPartition(context, data.league.seasonPartitions)})'}',
                            icon: Icons.fitness_center,
                            onTap: () => handleSelectedWeightClass(data, context));
                      },
                    );
                  }),
                );
              },
            ),
          ]),
        );
      },
    );
  }

  handleSelectedTeam(LeagueTeamParticipation teamParticipation, BuildContext context) {
    context.push('/${LeagueTeamParticipationOverview.route}/${teamParticipation.id}');
  }

  handleSelectedWeightClass(LeagueWeightClass leagueWeightClass, BuildContext context) {
    context.push('/${LeagueWeightClassOverview.route}/${leagueWeightClass.id}');
  }
}
