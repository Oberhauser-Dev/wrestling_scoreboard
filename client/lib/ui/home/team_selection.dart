import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/data/team.dart';
import 'package:wrestling_scoreboard/ui/components/consumer.dart';
import 'package:wrestling_scoreboard/ui/components/grouped_list.dart';

import 'match_selection.dart';

class TeamSelection extends StatelessWidget {
  final String title;
  final DataObject filterObject;

  const TeamSelection({Key? key, required this.title, required this.filterObject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: GroupedList(items: [
        ManyConsumer<Team, ClientTeam>(
          filterObject: filterObject,
          builder: (BuildContext context, List<ClientTeam> data) {
            return ListGroup(
              header: HeadingItem(AppLocalizations.of(context)!.team),
              items:
                  data.map((e) => ContentItem(e.name, icon: Icons.group, onTab: () => handleSelectedTeam(e, context))),
            );
          },
        ),
      ]),
    );
  }

  handleSelectedTeam(ClientTeam team, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MatchSelection(
          title: team.name,
          filterObject: team,
        ),
      ),
    );
  }
}
