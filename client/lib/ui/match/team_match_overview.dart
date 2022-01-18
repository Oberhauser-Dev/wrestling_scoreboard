import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/data/lineup.dart';
import 'package:wrestling_scoreboard/data/team_match.dart';
import 'package:wrestling_scoreboard/ui/components/consumer.dart';
import 'package:wrestling_scoreboard/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard/ui/lineup/edit_lineup.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';

class TeamMatchOverview extends StatelessWidget {
  final ClientTeamMatch match;

  const TeamMatchOverview({required this.match, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final lineups = match.lineups;

    final items = [
      ListGroup(
        header: HeadingItem(title: localizations.match),
        items: [
          ContentItem(title: localizations.details, icon: Icons.description, onTap: () {}),
          ContentItem(title: localizations.weightClass, icon: Icons.fitness_center, onTap: () {}),
          ContentItem(title: localizations.durations, icon: Icons.timer, onTap: () {}),
        ],
      ),
      ListGroup(
        header: HeadingItem(title: localizations.persons),
        items: [
          ContentItem(title: localizations.referee, icon: Icons.sports, onTap: () {}),
          ContentItem(title: localizations.matPresident, icon: Icons.manage_accounts, onTap: () {}),
          ContentItem(title: localizations.timeKeeper, icon: Icons.pending_actions, onTap: () {}),
          ContentItem(title: localizations.transcriptionWriter, icon: Icons.history_edu, onTap: () {}),
          ContentItem(title: localizations.steward, icon: Icons.security, onTap: () {}),
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
          ContentItem(title: localizations.fights, icon: Icons.sports_kabaddi, onTap: () {})
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('${localizations.info} ${localizations.match}'),
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
          return EditLineup(
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
