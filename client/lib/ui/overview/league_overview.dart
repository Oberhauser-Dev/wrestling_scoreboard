import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/data/wrestling_style.dart';
import 'package:wrestling_scoreboard/ui/components/consumer.dart';
import 'package:wrestling_scoreboard/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard/ui/components/info.dart';
import 'package:wrestling_scoreboard/ui/edit/league_edit.dart';
import 'package:wrestling_scoreboard/ui/edit/league_weight_class_edit.dart';
import 'package:wrestling_scoreboard/ui/edit/team_edit.dart';
import 'package:wrestling_scoreboard/ui/overview/league_weight_class_overview.dart';
import 'package:wrestling_scoreboard/ui/overview/team_overview.dart';
import 'package:wrestling_scoreboard/util/date_time.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';

class LeagueOverview extends StatelessWidget {
  final League filterObject;

  const LeagueOverview({Key? key, required this.filterObject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return SingleConsumer<League>(
      id: filterObject.id!,
      initialData: filterObject,
      builder: (context, data) {
        final description = InfoWidget(
          obj: data!,
          editPage: LeagueEdit(
            league: data,
          ),
          onDelete: () => dataProvider.deleteSingle(data),
          children: [
            ContentItem(
              title: data.startDate.toDateString(context),
              subtitle: localizations.date, // Start date
              icon: Icons.emoji_events,
            ),
            ContentItem(
              title:
                  '${data.boutConfig.periodDuration.inSeconds} ✕ ${data.boutConfig.periodCount}',
              // '${localizations.breakDurationInSecs}: ${data.boutConfig.breakDuration.inSeconds}, '
              // '${localizations.activityDurationInSecs}: ${data.boutConfig.activityDuration.inSeconds}, '
              // '${localizations.injuryDurationInSecs}: ${data.boutConfig.injuryDuration.inSeconds}',
              subtitle: localizations.periodDurationInSecs, // Start date
              icon: Icons.timer,
            )
          ],
          classLocale: localizations.league,
        );
        return Scaffold(
          appBar: AppBar(
            title: Text(data.name),
          ),
          body: GroupedList(items: [
            description,
            ManyConsumer<Team>(
              filterObject: data,
              builder: (BuildContext context, List<Team> team) {
                return ListGroup(
                  header: HeadingItem(
                    title: localizations.teams,
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TeamEdit(
                            initialLeague: data,
                          ),
                        ),
                      ),
                    ),
                  ),
                  items: team.map(
                    (e) => SingleConsumer<Team>(
                        id: e.id,
                        initialData: e,
                        builder: (context, data) {
                          return ContentItem(
                              title: data!.name, icon: Icons.group, onTap: () => handleSelectedTeam(data, context));
                        }),
                  ),
                );
              },
            ),
            ManyConsumer<LeagueWeightClass>(
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
                          title: '${data!.weightClass.name} ${styleToString(data.weightClass.style, context)}',
                          icon: Icons.group,
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

  handleSelectedTeam(Team team, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeamOverview(
          filterObject: team,
        ),
      ),
    );
  }

  handleSelectedWeightClass(LeagueWeightClass leagueWeightClass, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LeagueWeightClassOverview(
          filterObject: leagueWeightClass,
        ),
      ),
    );
  }
}
