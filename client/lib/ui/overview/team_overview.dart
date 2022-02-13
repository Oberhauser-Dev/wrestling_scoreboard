import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/ui/components/consumer.dart';
import 'package:wrestling_scoreboard/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard/ui/components/info.dart';
import 'package:wrestling_scoreboard/ui/edit/team_edit.dart';
import 'package:wrestling_scoreboard/ui/edit/team_match_edit.dart';
import 'package:wrestling_scoreboard/ui/match/match_sequence.dart';
import 'package:wrestling_scoreboard/util/date_time.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';

class TeamOverview<T extends DataObject> extends StatelessWidget {
  final Team filterObject;

  const TeamOverview({Key? key, required this.filterObject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return SingleConsumer<Team>(
        id: filterObject.id!,
        initialData: filterObject,
        builder: (context, data) {
          final description = InfoWidget(
              obj: data!,
              editPage: TeamEdit(
                team: data,
              ),
              onDelete: () => dataProvider.deleteSingle(data),
              children: [
                ContentItem(
                  title: data.description ?? '-',
                  subtitle: localizations.description,
                  icon: Icons.subject,
                ),
                ContentItem(
                  title: data.league?.name ?? '-',
                  subtitle: localizations.league,
                  icon: Icons.emoji_events,
                ),
                ContentItem(
                  title: data.club.name,
                  subtitle: localizations.club,
                  icon: Icons.foundation,
                ),
              ],
              classLocale: localizations.team);
          return Scaffold(
            appBar: AppBar(
              title: Text(data.name),
            ),
            body: GroupedList(items: [
              description,
              ManyConsumer<TeamMatch>(
                filterObject: data,
                builder: (BuildContext context, List<TeamMatch> matches) {
                  return ListGroup(
                    header: HeadingItem(
                      title: localizations.matches,
                      trailing: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TeamMatchEdit(
                              initialHomeTeam: data,
                              initialGuestTeam: data,
                            ),
                          ),
                        ),
                      ),
                    ),
                    items: matches.map(
                      (e) => SingleConsumer<TeamMatch>(
                        id: e.id!,
                        initialData: e,
                        builder: (context, match) => ListTile(
                          title: RichText(
                              textScaleFactor: 1.5, // MediaQuery.of(context).textScaleFactor
                              text: TextSpan(
                                text:
                                    '${match!.date?.toDateString(context) ?? 'no date'}, ${match.no ?? 'no ID'}, ',
                                children: [
                                  TextSpan(
                                      text: match.home.team.name,
                                      style: match.home.team == data
                                          ? const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)
                                          : null),
                                  const TextSpan(text: ' - '),
                                  TextSpan(
                                      text: match.guest.team.name,
                                      style: match.guest.team == data
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
        });
  }

  handleSelectedMatch(TeamMatch match, BuildContext context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MatchSequence(match)));
  }
}
