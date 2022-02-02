import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/ui/components/consumer.dart';
import 'package:wrestling_scoreboard/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard/ui/components/info.dart';
import 'package:wrestling_scoreboard/ui/league/league_edit.dart';
import 'package:wrestling_scoreboard/ui/team/team_edit.dart';

import '../home/match_selection.dart';

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
          ]),
        );
      },
    );
  }

  handleSelectedTeam(Team team, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MatchSelection<Team>(
          filterObject: team,
        ),
      ),
    );
  }
}
