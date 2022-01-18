import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/data/club.dart';
import 'package:wrestling_scoreboard/data/league.dart';
import 'package:wrestling_scoreboard/data/team.dart';
import 'package:wrestling_scoreboard/ui/club/club_edit.dart';
import 'package:wrestling_scoreboard/ui/components/consumer.dart';
import 'package:wrestling_scoreboard/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard/ui/components/info.dart';
import 'package:wrestling_scoreboard/ui/league/league_edit.dart';
import 'package:wrestling_scoreboard/ui/team/team_edit.dart';

import 'match_selection.dart';

class TeamSelection<T extends DataObject, S extends T> extends StatelessWidget {
  final S filterObject;

  const TeamSelection({Key? key, required this.filterObject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return SingleConsumer<T, S>(
      id: filterObject.id!,
      initialData: filterObject,
      builder: (context, data) {
        final description = data is ClientClub
            ? InfoWidget(
                obj: data,
                editPage: ClubEdit(
                  club: data as ClientClub,
                ),
                children: [
                  ContentItem(
                    title: (data as ClientClub).no ?? '-',
                    subtitle: localizations.clubNumber,
                    icon: Icons.tag,
                  )
                ],
                classLocale: localizations.club,
              )
            : data is ClientLeague
                ? InfoWidget(
                    obj: data,
                    editPage: LeagueEdit(
                      league: data as ClientLeague,
                    ),
                    children: [
                      ContentItem(
                        title: (data as ClientLeague).startDate.toIso8601String(),
                        subtitle: localizations.date, // Start date
                        icon: Icons.emoji_events,
                      )
                    ],
                    classLocale: localizations.league,
                  )
                : const SizedBox();
        return Scaffold(
          appBar: AppBar(
            title: Text(data is League ? (data as ClientLeague).name : (data as ClientClub).name),
          ),
          body: GroupedList(items: [
            description,
            ManyConsumer<Team, ClientTeam>(
              filterObject: data,
              builder: (BuildContext context, List<ClientTeam> team) {
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

  handleSelectedTeam(ClientTeam team, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MatchSelection<Team, ClientTeam>(
          filterObject: team,
        ),
      ),
    );
  }
}
