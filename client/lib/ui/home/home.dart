import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/data/club.dart';
import 'package:wrestling_scoreboard/data/league.dart';
import 'package:wrestling_scoreboard/data/team.dart';
import 'package:wrestling_scoreboard/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard/ui/home/team_selection.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';

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
          StreamBuilder(
            stream: dataProvider.streamMany<ClientClub>(ClientClub),
            builder: (BuildContext context, AsyncSnapshot<ManyDataObject<ClientClub>> clubsSnap) {
              return ListGroup(
                  header: HeadingItem(AppLocalizations.of(context)!.club),
                  items: clubsSnap.hasData
                      ? (clubsSnap.data!.data.map(
                          (e) => ContentItem(
                            e.name,
                            icon: Icons.foundation,
                            onTab: () => handleSelectedClub(e, context),
                          ),
                        ))
                      : []);
            },
          ),
          StreamBuilder(
            stream: dataProvider.streamMany<ClientLeague>(ClientLeague),
            builder: (BuildContext context, AsyncSnapshot<ManyDataObject<ClientLeague>> leaguesSnap) {
              return ListGroup(
                  header: HeadingItem(AppLocalizations.of(context)!.league),
                  items: leaguesSnap.hasData
                      ? (leaguesSnap.data!.data.map(
                          (e) => ContentItem(
                            e.name,
                            icon: Icons.emoji_events,
                            onTab: () => handleSelectedLeague(e, context),
                          ),
                        ))
                      : []);
            },
          ),
        ],
      ),
    );
  }

  handleSelectedClub(ClientClub club, BuildContext context) {
    dataProvider.readMany<ClientTeam>(filterObject: club).then(
          (value) => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TeamSelection(
                      title: club.name,
                      teams: value,
                    )),
          ),
        );
  }

  handleSelectedLeague(ClientLeague league, BuildContext context) {
    dataProvider.readMany<ClientTeam>(filterObject: league).then(
          (value) => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TeamSelection(
                      title: league.name,
                      teams: value,
                    )),
          ),
        );
  }
}
