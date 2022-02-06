import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/ui/components/consumer.dart';
import 'package:wrestling_scoreboard/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard/ui/components/info.dart';
import 'package:wrestling_scoreboard/ui/edit/league_edit.dart';
import 'package:wrestling_scoreboard/ui/edit/team_edit.dart';
import 'package:wrestling_scoreboard/ui/overview/team_overview.dart';
import 'package:wrestling_scoreboard/ui/edit/league_weight_class_edit.dart';

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
          children: [
            ContentItem(
              title: data.startDate.toIso8601String(),
              subtitle: localizations.date, // Start date
              icon: Icons.emoji_events,
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
                  items: team.map((e) =>
                      ContentItem(title: e.name, icon: Icons.group, onTap: () => handleSelectedTeam(e, context))),
                );
              },
            ),
            ManyConsumer<LeagueWeightClass>(
              filterObject: data,
              builder: (BuildContext context, List<LeagueWeightClass> leagueWeightClass) {
                return ListGroup(
                  header: HeadingItem(
                    title: localizations.weightClass,
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LeagueWeightClassEdit(league: data),
                        ),
                      ),
                    ),
                  ),
                  items: leagueWeightClass.map((e) =>
                      ContentItem(title: e.weightClass.name, icon: Icons.group, onTap: () => handleSelectedWeightClass(e, context))),
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
        // TODO may add its own overview
        builder: (context) => LeagueWeightClassEdit(
          leagueWeightClass: leagueWeightClass, league: leagueWeightClass.league,
        ),
      ),
    );
  }
}
