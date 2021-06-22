import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/data/team_match.dart';
import 'package:wrestling_scoreboard/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard/ui/match/match_sequence.dart';

class MatchSelection extends StatelessWidget {
  final String title;
  final List<TeamMatch> matches;
  late List<ListItem> items;

  MatchSelection({required this.title, required this.matches});

  @override
  Widget build(BuildContext context) {
    items = [HeadingItem(AppLocalizations.of(context)!.match)]..addAll(matches.map((e) => ContentItem(
        '${e.home.team.name} - ${e.guest.team.name}',
        icon: Icons.event,
        onTab: () => handleSelectedMatch(e, context))));

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: GroupedList(items),
    );
  }

  handleSelectedMatch(TeamMatch match, BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MatchSequence(match)));
  }
}
