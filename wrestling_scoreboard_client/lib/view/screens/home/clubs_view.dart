import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_match/league_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/league_overview.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class ClubsView extends StatelessWidget {
  const ClubsView({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return ResponsiveScrollView(
      child: ManyConsumer<League, Null>(
        builder: (BuildContext context, List<League> leagues) {
          return ListGroup(
            header: HeadingItem(
              title: localizations.leagues,
              trailing: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LeagueEdit())),
              ),
            ),
            items: leagues.map(
              (e) => SingleConsumer<League>(
                id: e.id!,
                initialData: e,
                builder: (context, data) {
                  return ContentItem(
                    title: data.name,
                    icon: Icons.emoji_events,
                    onTap: () => handleSelectedLeague(data, context),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  handleSelectedLeague(League league, BuildContext context) {
    context.push('/${LeagueOverview.route}/${league.id}');
  }
}
