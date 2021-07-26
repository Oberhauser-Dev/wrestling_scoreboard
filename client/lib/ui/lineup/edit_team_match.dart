import 'package:common/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/data/membership.dart';
import 'package:wrestling_scoreboard/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard/ui/lineup/edit_lineup.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';

class EditTeamMatch extends StatelessWidget {
  final String title;
  final TeamMatch match;
  late List<ListGroup> items;

  EditTeamMatch({required this.title, required this.match});

  @override
  Widget build(BuildContext context) {
    items = [
      ListGroup(
        HeadingItem(AppLocalizations.of(context)!.match),
        [
          ContentItem('Details', icon: Icons.description, onTab: () {}),
          ContentItem(AppLocalizations.of(context)!.weightClass, icon: Icons.fitness_center, onTab: () {}),
          ContentItem('Durations', icon: Icons.timer, onTab: () {}),
        ],
      ),
      ListGroup(
        HeadingItem(AppLocalizations.of(context)!.person),
        [
          ContentItem(AppLocalizations.of(context)!.referee, icon: Icons.sports, onTab: () {}),
          ContentItem('Mat president', icon: Icons.manage_accounts, onTab: () {}),
          ContentItem('Time Keeper', icon: Icons.pending_actions, onTab: () {}),
          ContentItem('Transcription Writer', icon: Icons.history_edu, onTab: () {}),
          ContentItem('Steward', icon: Icons.security, onTab: () {}),
        ],
      ),
      ListGroup(HeadingItem(AppLocalizations.of(context)!.lineup + ' & ' + AppLocalizations.of(context)!.fight), [
        ...match.lineups
            .map((e) => ContentItem(e.team.name, icon: Icons.group, onTab: () => handleSelectedLineup(e, context))),
        ContentItem(AppLocalizations.of(context)!.fight, icon: Icons.sports_kabaddi, onTab: () {})
      ]),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: GroupedList(items),
    );
  }

  handleSelectedLineup(Lineup lineup, BuildContext context) async {
    final participations = await dataProvider.readMany<Participation>(filterObject: lineup);
    final memberships = await dataProvider.readMany<ClientMembership>(filterObject: lineup.team.club);
    final title = AppLocalizations.of(context)!.edit + ' ' + AppLocalizations.of(context)!.lineup;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditLineup(
                  title: title,
                  weightClasses: match.weightClasses,
                  lineup: lineup,
                  participations: participations,
                  memberships: memberships,
                )));
  }
}
