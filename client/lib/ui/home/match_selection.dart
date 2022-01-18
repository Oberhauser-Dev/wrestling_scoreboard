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

class MatchSelection<T extends DataObject, S extends T> extends StatelessWidget {
  final S filterObject;

  const MatchSelection({Key? key, required this.filterObject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return SingleConsumer<T, S>(
        id: filterObject.id!,
        initialData: filterObject,
        builder: (context, data) {
          final description = data is ClientTeam
              ? InfoWidget(
              obj: data,
              editPage: TeamEdit(
                team: data as ClientTeam,
              ),
              children: [
                ContentItem(
                  title: (data as Team).description ?? '-',
                  subtitle: localizations.description,
                  icon: Icons.subject,
                ),
                ContentItem(
                  title: (data as Team).league?.name ?? '-',
                  subtitle: localizations.league,
                  icon: Icons.emoji_events,
                ),
                ContentItem(
                  title: (data as Team).club.name,
                  subtitle: localizations.club,
                  icon: Icons.foundation,
                ),
              ],
              classLocale: localizations.team)
              : const SizedBox();
          return Scaffold(
            appBar: AppBar(
              title: Text(data is Team ? (data as Team).name : 'no title'),
            ),
            body: GroupedList(items: [
              description,
              ManyConsumer<TeamMatch, ClientTeamMatch>(
                filterObject: data,
                builder: (BuildContext context, List<ClientTeamMatch> matches) {
                  return ListGroup(
                    header: HeadingItem(
                      title: localizations.matches,
                      trailing: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TeamMatchEdit(
                              initialHomeTeam: data is Team ? data as Team : null,
                              initialGuestTeam: data is Team ? data as Team : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                    items: matches.map(
                          (e) => SingleConsumer<TeamMatch, ClientTeamMatch>(
                        id: e.id!,
                        initialData: e,
                        builder: (context, match) => ListTile(
                          title: RichText(
                              textScaleFactor: 1.5, // MediaQuery.of(context).textScaleFactor
                              text: TextSpan(
                                text:
                                '${match.date?.toIso8601String().substring(0, 10) ?? 'no date'}, ${match.no ?? 'no ID'}, ',
                                children: [
                                  TextSpan(
                                      text: match.home.team.name,
                                      style: match.home.team == (data as Team)
                                          ? const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)
                                          : null),
                                  const TextSpan(text: ' - '),
                                  TextSpan(
                                      text: match.guest.team.name,
                                      style: match.guest.team == (data as Team)
                                          ? const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)
                                          : null),
                                ],
                              )),
                          leading: const Icon(Icons.event),
                          onTap: () => handleSelectedMatch(match, context),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ]),
          );
        }
    );
  }

  handleSelectedMatch(ClientTeamMatch match, BuildContext context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MatchSequence(match)));
  }
}
