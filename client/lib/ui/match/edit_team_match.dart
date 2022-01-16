import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/data/lineup.dart';
import 'package:wrestling_scoreboard/data/membership.dart';
import 'package:wrestling_scoreboard/data/team_match.dart';
import 'package:wrestling_scoreboard/ui/components/consumer.dart';
import 'package:wrestling_scoreboard/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard/ui/lineup/edit_lineup.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';

class EditTeamMatch extends StatelessWidget {
  final String title;
  final ClientTeamMatch match;

  const EditTeamMatch({required this.title, required this.match, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final lineups = match.lineups;

    return SingleConsumer<TeamMatch, ClientTeamMatch>(
      id: match.id!,
      initialData: match,
      builder: (BuildContext context, ClientTeamMatch match) {
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
            title: Text(title),
          ),
          body: GroupedList(items: items),
        );
      },
    );
  }

  handleSelectedLineup(ClientLineup lineup, BuildContext context) async {
    final participations = await dataProvider.readMany<Participation, Participation>(filterObject: lineup);
    final memberships = await dataProvider.readMany<Membership, ClientMembership>(filterObject: lineup.team.club);
    final title = AppLocalizations.of(context)!.edit + ' ' + AppLocalizations.of(context)!.lineup;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return EditLineup(
            title: title,
            weightClasses: match.weightClasses,
            lineup: lineup,
            participations: participations,
            memberships: memberships,
            onSubmit: () {
              dataProvider.generateFights(match, true);
            },
          );
        },
      ),
    );
  }
}
