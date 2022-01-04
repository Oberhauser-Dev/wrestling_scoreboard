import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/data/team.dart';
import 'package:wrestling_scoreboard/data/team_match.dart';
import 'package:wrestling_scoreboard/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';

import 'match_selection.dart';

class TeamSelection extends StatelessWidget {
  final String title;
  final Iterable<ClientTeam> teams;

  const TeamSelection({Key? key, required this.title, required this.teams}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = [
      ListGroup(HeadingItem(AppLocalizations.of(context)!.team),
          teams.map((e) => ContentItem(e.name, icon: Icons.group, onTab: () => handleSelectedTeam(e, context))))
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: GroupedList(items),
    );
  }

  handleSelectedTeam(ClientTeam team, BuildContext context) {
    dataProvider.readMany<ClientTeamMatch>(filterObject: team).then(
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
