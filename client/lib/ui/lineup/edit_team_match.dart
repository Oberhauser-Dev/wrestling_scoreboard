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
            header: HeadingItem(localizations.match),
            items: [
              ContentItem(localizations.details, icon: Icons.description, onTab: () {}),
              ContentItem(localizations.weightClass, icon: Icons.fitness_center, onTab: () {}),
              ContentItem(localizations.durations, icon: Icons.timer, onTab: () {}),
            ],
          ),
          ListGroup(
            header: HeadingItem(localizations.persons),
            items: [
              ContentItem(localizations.referee, icon: Icons.sports, onTab: () {}),
              ContentItem(localizations.matPresident, icon: Icons.manage_accounts, onTab: () {}),
              ContentItem(localizations.timeKeeper, icon: Icons.pending_actions, onTab: () {}),
              ContentItem(localizations.transcriptionWriter, icon: Icons.history_edu, onTab: () {}),
              ContentItem(localizations.steward, icon: Icons.security, onTab: () {}),
            ],
          ),
          ListGroup(
            header: HeadingItem(localizations.lineups + ' & ' + localizations.fights),
            items: [
              ...lineups.map((lineup) {
                return SingleConsumer<Lineup, ClientLineup>(
                  id: lineup.id!,
                  initialData: lineup,
                  builder: (context, lineup) => ContentItem(lineup.team.name,
                      icon: Icons.group, onTab: () => handleSelectedLineup(lineup, context)),
                );
              }),
              ContentItem(localizations.fights, icon: Icons.sports_kabaddi, onTab: () {})
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
            onSubmit: () async {
              await dataProvider.generateFights(match, true);
            },
          );
        },
      ),
    );
  }
}
