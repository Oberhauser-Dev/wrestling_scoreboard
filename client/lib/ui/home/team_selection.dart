import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/ui/club/club_edit.dart';
import 'package:wrestling_scoreboard/ui/components/consumer.dart';
import 'package:wrestling_scoreboard/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard/ui/components/info.dart';
import 'package:wrestling_scoreboard/ui/league/league_edit.dart';
import 'package:wrestling_scoreboard/ui/team/team_edit.dart';

import 'match_selection.dart';

class TeamSelection<T extends DataObject> extends StatelessWidget {
  final T filterObject;

  const TeamSelection({Key? key, required this.filterObject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return SingleConsumer<T>(
      id: filterObject.id!,
      initialData: filterObject,
      builder: (context, data) {
        final description = data is Club
            ? InfoWidget(
                obj: data,
                editPage: ClubEdit(
                  club: data as Club,
                ),
                children: [
                  ContentItem(
                    title: (data as Club).no ?? '-',
                    subtitle: localizations.clubNumber,
                    icon: Icons.tag,
                  )
                ],
                classLocale: localizations.club,
              )
            : data is League
                ? InfoWidget(
                    obj: data,
                    editPage: LeagueEdit(
                      league: data as League,
                    ),
                    children: [
                      ContentItem(
                        title: (data as League).startDate.toIso8601String(),
                        subtitle: localizations.date, // Start date
                        icon: Icons.emoji_events,
                      )
                    ],
                    classLocale: localizations.league,
                  )
                : const SizedBox();
        return Scaffold(
          appBar: AppBar(
            title: Text(data is League ? (data as League).name : (data as Club).name),
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
                            initialClub: data is Club ? data as Club : null,
                            initialLeague: data is League ? data as League : null,
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
