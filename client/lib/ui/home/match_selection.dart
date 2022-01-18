import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/data/team.dart';
import 'package:wrestling_scoreboard/data/team_match.dart';
import 'package:wrestling_scoreboard/ui/components/consumer.dart';
import 'package:wrestling_scoreboard/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard/ui/components/info.dart';
import 'package:wrestling_scoreboard/ui/match/match_sequence.dart';
import 'package:wrestling_scoreboard/ui/match/team_match_edit.dart';
import 'package:wrestling_scoreboard/ui/team/team_edit.dart';

class MatchSelection extends StatelessWidget {
  final String title;
  final DataObject filterObject;

  const MatchSelection({Key? key, required this.title, required this.filterObject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final description = filterObject is ClientTeam
        ? InfoWidget(
            obj: filterObject,
            editPage: TeamEdit(
              team: filterObject as ClientTeam,
            ),
            children: [
              ContentItem(
                title: (filterObject as Team).description ?? '-',
                subtitle: localizations.description,
                icon: Icons.subject,
              ),
              ContentItem(
                title: (filterObject as Team).league?.name ?? '-',
                subtitle: localizations.league,
                icon: Icons.emoji_events,
              ),
              ContentItem(
                title: (filterObject as Team).club.name,
                subtitle: localizations.club,
                icon: Icons.foundation,
              ),
            ],
            classLocale: localizations.team)
        : const SizedBox();
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: GroupedList(items: [
        description,
        ManyConsumer<TeamMatch, ClientTeamMatch>(
          filterObject: filterObject,
          builder: (BuildContext context, List<ClientTeamMatch> teamMatch) {
            return ListGroup(
              header: HeadingItem(
                title: localizations.matches,
                trailing: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TeamMatchEdit(
                        initialHomeTeam: filterObject is Team ? filterObject as Team : null,
                        initialGuestTeam: filterObject is Team ? filterObject as Team : null,
                      ),
                    ),
                  ),
                ),
              ),
              items: teamMatch.map(
                (e) => SingleConsumer<TeamMatch, ClientTeamMatch>(
                  id: e.id!,
                  initialData: e,
                  builder: (context, data) => ListTile(
                    title: RichText(
                        textScaleFactor: 1.5, // MediaQuery.of(context).textScaleFactor
                        text: TextSpan(
                          text:
                              '${data.date?.toIso8601String().substring(0, 10) ?? 'no date'}, ${data.no ?? 'no ID'}, ',
                          children: [
                            TextSpan(
                                text: data.home.team.name,
                                style: data.home.team == (filterObject as Team)
                                    ? const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)
                                    : null),
                            const TextSpan(text: ' - '),
                            TextSpan(
                                text: data.guest.team.name,
                                style: data.guest.team == (filterObject as Team)
                                    ? const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)
                                    : null),
                          ],
                        )),
                    leading: const Icon(Icons.event),
                    onTap: () => handleSelectedMatch(data, context),
                  ),
                ),
              ),
            );
          },
        ),
      ]),
    );
  }

  handleSelectedMatch(ClientTeamMatch match, BuildContext context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MatchSequence(match)));
  }
}
