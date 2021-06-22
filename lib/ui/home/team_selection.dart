import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/data/team.dart';
import 'package:wrestling_scoreboard/mocks/mocks.dart';
import 'package:wrestling_scoreboard/ui/components/grouped_list.dart';

import 'match_selection.dart';

class TeamSelection extends StatelessWidget {
  final String title;
  final List<Team> teams;
  late List<ListItem> items;

  TeamSelection({required this.title, required this.teams});

  @override
  Widget build(BuildContext context) {
    items = [HeadingItem(AppLocalizations.of(context)!.team)]
      ..addAll(teams.map((e) => ContentItem(e.name, icon: Icons.group, onTab: () => handleSelectedTeam(e, context))));

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: GroupedList(items),
    );
  }

  handleSelectedTeam(Team team, BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MatchSelection(
                  title: team.name,
                  matches: getMatchesOfTeam(team),
                )));
  }
}
