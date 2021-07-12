import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/data/team.dart';
import 'package:wrestling_scoreboard/data/team_match.dart';
import 'package:wrestling_scoreboard/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard/util/network/rest/rest.dart';

import 'match_selection.dart';

class TeamSelection extends StatelessWidget {
  final String title;
  final List<ClientTeam> teams;
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

  handleSelectedTeam(ClientTeam team, BuildContext context) {
    fetchMany<ClientTeamMatch>(prepend: '/team/${team.id}').then(
      (value) => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MatchSelection(
                  title: team.name,
                  matches: value,
                )),
      ),
    );
  }
}
