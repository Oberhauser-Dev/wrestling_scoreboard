import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/data/wrestling_style.dart';
import 'package:wrestling_scoreboard_client/ui/components/consumer.dart';
import 'package:wrestling_scoreboard_client/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard_client/ui/components/info.dart';
import 'package:wrestling_scoreboard_client/ui/edit/league_edit.dart';
import 'package:wrestling_scoreboard_client/ui/edit/league_team_participation_edit.dart';
import 'package:wrestling_scoreboard_client/ui/edit/league_weight_class_edit.dart';
import 'package:wrestling_scoreboard_client/ui/overview/league_weight_class_overview.dart';
import 'package:wrestling_scoreboard_client/ui/overview/shared/matches_widget.dart';
import 'package:wrestling_scoreboard_client/ui/overview/team_overview.dart';
import 'package:wrestling_scoreboard_client/util/date_time.dart';
import 'package:wrestling_scoreboard_client/util/network/data_provider.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class LeagueOverview extends StatelessWidget {
  static const route = 'league';

  final int id;
  final League? league;

  const LeagueOverview({Key? key, required this.id, this.league}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          onDelete: () => dataProvider.deleteSingle(data),
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
            )
          ],
        );
        return Scaffold(
          appBar: AppBar(
            title: Text(data.name),
          ),
          body: GroupedList(items: [
            description,
            ManyConsumer<LeagueTeamParticipation, League>(
              filterObject: data,
              builder: (BuildContext context, List<LeagueTeamParticipation> team) {
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
                  items: team.map(
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
                      builder: (context, data) => ContentItem(
                          title: '${data.weightClass.name} ${styleToString(data.weightClass.style, context)}',
                          icon: Icons.fitness_center,
                          onTap: () => handleSelectedWeightClass(data, context)),
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
    context.go('/${TeamOverview.route}/${teamParticipation.team.id}');
  }

  handleSelectedWeightClass(LeagueWeightClass leagueWeightClass, BuildContext context) {
    context.go('/${LeagueWeightClassOverview.route}/${leagueWeightClass.id}');
  }
}
