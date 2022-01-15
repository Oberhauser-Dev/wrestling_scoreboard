import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/data/club.dart';
import 'package:wrestling_scoreboard/data/league.dart';
import 'package:wrestling_scoreboard/ui/components/consumer.dart';
import 'package:wrestling_scoreboard/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard/ui/home/team_selection.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.home),
      ),
      body: GroupedList(
        items: [
          ManyConsumer<Club, ClientClub>(
            builder: (BuildContext context, List<ClientClub> clubs) {
              return ListGroup(
                header: HeadingItem(AppLocalizations.of(context)!.clubs),
                items: clubs.map(
                  (e) => ContentItem(
                    e.name,
                    icon: Icons.foundation,
                    onTab: () => handleSelectedClub(e, context),
                  ),
                ),
              );
            },
          ),
          ManyConsumer<League, ClientLeague>(
            builder: (BuildContext context, List<ClientLeague> leagues) {
              return ListGroup(
                header: HeadingItem(AppLocalizations.of(context)!.leagues),
                items: leagues.map(
                  (e) => ContentItem(
                    e.name,
                    icon: Icons.emoji_events,
                    onTab: () => handleSelectedLeague(e, context),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  handleSelectedClub(ClientClub club, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeamSelection(
          title: club.name,
          filterObject: club,
        ),
      ),
    );
  }

  handleSelectedLeague(ClientLeague league, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeamSelection(
          title: league.name,
          filterObject: league,
        ),
      ),
    );
  }
}
