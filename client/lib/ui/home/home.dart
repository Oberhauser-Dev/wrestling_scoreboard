import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/data/club.dart';
import 'package:wrestling_scoreboard/data/league.dart';
import 'package:wrestling_scoreboard/ui/club/edit_club.dart';
import 'package:wrestling_scoreboard/ui/components/consumer.dart';
import 'package:wrestling_scoreboard/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard/ui/home/team_selection.dart';
import 'package:wrestling_scoreboard/ui/league/edit_league.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(localizations.home),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.foundation)),
              Tab(icon: Icon(Icons.emoji_events)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ManyConsumer<Club, ClientClub>(
              builder: (BuildContext context, List<ClientClub> clubs) {
                return ListGroup(
                  header: HeadingItem(
                    title: localizations.clubs,
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => handleEditClub(context),
                    ),
                  ),
                  items: clubs.map(
                    (e) => ContentItem(
                      title: e.name,
                      icon: Icons.foundation,
                      onTap: () => handleSelectedClub(e, context),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            content: Text('${localizations.remove} ${localizations.club}?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'Cancel'),
                                child: Text(localizations.cancel),
                              ),
                              TextButton(
                                onPressed: () {
                                  dataProvider.deleteSingle(e);
                                  Navigator.pop(context, 'OK');
                                },
                                child: Text(localizations.ok),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            ManyConsumer<League, ClientLeague>(
              builder: (BuildContext context, List<ClientLeague> leagues) {
                return ListGroup(
                  header: HeadingItem(
                    title: localizations.leagues,
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => handleEditLeague(context),
                    ),
                  ),
                  items: leagues.map(
                    (e) => ContentItem(
                      title: e.name,
                      icon: Icons.emoji_events,
                      onTap: () => handleSelectedLeague(e, context),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            content: Text('${localizations.remove} ${localizations.league}?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'Cancel'),
                                child: Text(localizations.cancel),
                              ),
                              TextButton(
                                onPressed: () {
                                  dataProvider.deleteSingle(e);
                                  Navigator.pop(context, 'OK');
                                },
                                child: Text(localizations.ok),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
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

  handleEditClub(BuildContext context) {
    final title = AppLocalizations.of(context)!.edit + ' ' + AppLocalizations.of(context)!.club;
    Navigator.push(context, MaterialPageRoute(builder: (context) => EditClub(title: title)));
  }

  handleEditLeague(BuildContext context) {
    final title = AppLocalizations.of(context)!.edit + ' ' + AppLocalizations.of(context)!.league;
    Navigator.push(context, MaterialPageRoute(builder: (context) => EditLeague(title: title)));
  }
}
