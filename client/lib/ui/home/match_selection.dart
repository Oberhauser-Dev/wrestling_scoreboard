import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/data/team_match.dart';
import 'package:wrestling_scoreboard/ui/components/consumer.dart';
import 'package:wrestling_scoreboard/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard/ui/match/match_sequence.dart';

class MatchSelection extends StatelessWidget {
  final String title;
  final DataObject filterObject;

  const MatchSelection({Key? key, required this.title, required this.filterObject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: GroupedList(items: [
        ManyConsumer<TeamMatch, ClientTeamMatch>(
          filterObject: filterObject,
          builder: (BuildContext context, List<ClientTeamMatch> data) {
            return ListGroup(
              header: HeadingItem(AppLocalizations.of(context)!.match),
              items: data.map(
                (e) => ContentItem(
                  '${e.home.team.name} - ${e.guest.team.name}',
                  icon: Icons.event,
                  onTab: () => handleSelectedMatch(e, context),
                ),
              ),
            );
          },
        ),
      ]),
    );
  }

  handleSelectedMatch(ClientTeamMatch match, BuildContext context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MatchSequence(match)));
  }
}
