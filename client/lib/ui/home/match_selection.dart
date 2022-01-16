import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/data/team.dart';
import 'package:wrestling_scoreboard/data/team_match.dart';
import 'package:wrestling_scoreboard/ui/components/consumer.dart';
import 'package:wrestling_scoreboard/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard/ui/components/info.dart';
import 'package:wrestling_scoreboard/ui/match/match_sequence.dart';
import 'package:wrestling_scoreboard/ui/team/edit_team.dart';

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
            editPage: EditTeam(
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
          builder: (BuildContext context, List<ClientTeamMatch> data) {
            return ListGroup(
              header: HeadingItem(title: localizations.matches),
              items: data.map(
                (e) => ContentItem(
                  title: '${e.home.team.name} - ${e.guest.team.name}',
                  icon: Icons.event,
                  onTap: () => handleSelectedMatch(e, context),
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
