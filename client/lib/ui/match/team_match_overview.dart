import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/data/lineup.dart';
import 'package:wrestling_scoreboard/data/team_match.dart';
import 'package:wrestling_scoreboard/ui/components/consumer.dart';
import 'package:wrestling_scoreboard/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard/ui/components/info.dart';
import 'package:wrestling_scoreboard/ui/lineup/lineup_edit.dart';
import 'package:wrestling_scoreboard/ui/match/team_match_edit.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';

class TeamMatchOverview extends StatelessWidget {
  final ClientTeamMatch match;

  const TeamMatchOverview({required this.match, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final lineups = match.lineups;

    final items = [
      InfoWidget(
          obj: match,
          editPage: TeamMatchEdit(
            teamMatch: match,
          ),
          children: [
            ContentItem(
              title: match.no ?? '-',
              subtitle: localizations.matchNumber,
              icon: Icons.tag,
            ),
            ContentItem(
              title: match.location ?? 'no location',
              subtitle: localizations.matchNumber,
              icon: Icons.place,
            ),
            ContentItem(
              title: match.date?.toIso8601String() ?? 'no date',
              subtitle: localizations.date,
              icon: Icons.date_range,
            ),
            ContentItem(
              title: match.home.team.name,
              subtitle: '${localizations.team} ${localizations.red}',
              icon: Icons.emoji_events,
            ),
            ContentItem(
              title: match.guest.team.name,
              subtitle: '${localizations.team} ${localizations.blue}',
              icon: Icons.emoji_events,
            ),
            ContentItem(title: localizations.weightClass, icon: Icons.fitness_center, onTap: null),
            ContentItem(title: localizations.durations, icon: Icons.timer, onTap: null),
          ],
          classLocale: localizations.match),
      ListGroup(
        header: HeadingItem(title: localizations.persons),
        items: [
          ContentItem(title: localizations.referee, icon: Icons.sports, onTap: null),
          ContentItem(title: localizations.matPresident, icon: Icons.manage_accounts, onTap: null),
          ContentItem(title: localizations.timeKeeper, icon: Icons.pending_actions, onTap: null),
          ContentItem(title: localizations.transcriptionWriter, icon: Icons.history_edu, onTap: null),
          ContentItem(title: localizations.steward, icon: Icons.security, onTap: null),
        ],
      ),
      ListGroup(
        header: HeadingItem(title: localizations.lineups + ' & ' + localizations.fights),
        items: [
          ...lineups.map((lineup) {
            return SingleConsumer<Lineup, ClientLineup>(
              id: lineup.id!,
              initialData: lineup,
              builder: (context, lineup) => ContentItem(
                  title: lineup.team.name, icon: Icons.group, onTap: () => handleSelectedLineup(lineup, context)),
            );
          }),
          ContentItem(title: localizations.fights, icon: Icons.sports_kabaddi, onTap: null)
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('${localizations.match} ${localizations.details}'),
      ),
      body: GroupedList(items: items),
    );
  }

  handleSelectedLineup(ClientLineup lineup, BuildContext context) async {
    final participations = await dataProvider.readMany<Participation, Participation>(filterObject: lineup);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return LineupEdit(
            weightClasses: match.weightClasses,
            participations: participations,
            lineup: lineup,
            onSubmit: () {
              dataProvider.generateFights(match, true);
            },
          );
        },
      ),
    );
  }
}
