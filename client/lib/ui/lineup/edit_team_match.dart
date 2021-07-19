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
  late List<ListItem> items;

  EditTeamMatch({required this.title, required this.match});

  @override
  Widget build(BuildContext context) {
    items = [HeadingItem(AppLocalizations.of(context)!.lineup)]..addAll(match.lineups
        .map((e) => ContentItem(e.team.name, icon: Icons.group, onTab: () => handleSelectedLineup(e, context))));

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: GroupedList(items),
    );
  }

  handleSelectedLineup(Lineup lineup, BuildContext context) async {
    final participations = await dataProvider.fetchMany<Participation>(filterObject: lineup);
    final memberships = await dataProvider.fetchMany<ClientMembership>(filterObject: lineup.team.club);
    final title =
        AppLocalizations.of(context)!.edit + ' ' + AppLocalizations.of(context)!.lineup + ': ' + lineup.team.name;
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
