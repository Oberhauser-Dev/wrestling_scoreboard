import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/data/club.dart';
import 'package:wrestling_scoreboard/data/league.dart';
import 'package:wrestling_scoreboard/data/team.dart';
import 'package:wrestling_scoreboard/ui/club/edit_club.dart';
import 'package:wrestling_scoreboard/ui/components/consumer.dart';
import 'package:wrestling_scoreboard/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard/ui/league/edit_league.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';

import 'match_selection.dart';

class TeamSelection<T extends DataObject, S extends T> extends StatelessWidget {
  final S filterObject;

  const TeamSelection({Key? key, required this.filterObject}) : super(key: key);

  Widget buildInfoWidget(
      {required S obj,
      required Widget editPage,
      required Widget body,
      required String classLocale,
      required BuildContext context}) {
    final localizations = AppLocalizations.of(context)!;
    return ListGroup(
      header: HeadingItem(
        title: localizations.info,
        trailing: Wrap(
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => editPage,
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  content: Text('${localizations.remove} $classLocale?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(localizations.cancel),
                    ),
                    TextButton(
                      onPressed: () {
                        dataProvider.deleteSingle(obj);
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      child: Text(localizations.ok),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      items: [body],
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return SingleConsumer<T, S>(
      id: filterObject.id!,
      initialData: filterObject,
      builder: (context, data) {
        final description = data is ClientClub
            ? buildInfoWidget(
                obj: data,
                editPage: EditClub(
                  title: localizations.edit + ' ' + localizations.club,
                  club: data as ClientClub,
                ),
                body: ContentItem(
                  title: (data as ClientClub).no ?? '-',
                  subtitle: localizations.clubNumber,
                  icon: Icons.tag,
                ),
                classLocale: localizations.club,
                context: context)
            : data is ClientLeague
                ? buildInfoWidget(
                    obj: data,
                    editPage: EditLeague(
                      title: localizations.edit + ' ' + localizations.league,
                      league: data as ClientLeague,
                    ),
                    body: ContentItem(
                      title: (data as ClientLeague).startDate.toIso8601String(),
                      subtitle: localizations.date, // Start date
                      icon: Icons.emoji_events,
                    ),
                    classLocale: localizations.league,
                    context: context)
                : const SizedBox();
        return Scaffold(
          appBar: AppBar(
            title: Text(data is League ? (data as ClientLeague).name : (data as ClientClub).name),
          ),
          body: GroupedList(items: [
            description,
            ManyConsumer<Team, ClientTeam>(
              filterObject: data,
              builder: (BuildContext context, List<ClientTeam> data) {
                return ListGroup(
                  header: HeadingItem(title: localizations.teams),
                  items: data.map((e) =>
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
        builder: (context) => MatchSelection(
          title: team.name,
          filterObject: team,
        ),
      ),
    );
  }
}
