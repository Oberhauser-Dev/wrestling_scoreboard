import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_client/ui/components/consumer.dart';
import 'package:wrestling_scoreboard_client/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard_client/ui/components/info.dart';
import 'package:wrestling_scoreboard_client/ui/edit/lineup_edit.dart';
import 'package:wrestling_scoreboard_client/ui/edit/team_match_edit.dart';
import 'package:wrestling_scoreboard_client/util/date_time.dart';
import 'package:wrestling_scoreboard_client/util/network/data_provider.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class TeamMatchOverview extends StatelessWidget {
  final TeamMatch match;

  const TeamMatchOverview({required this.match, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);

    return SingleConsumer<TeamMatch>(
        id: match.id!,
        initialData: match,
        builder: (context, match) {
          return Scaffold(
            appBar: AppBar(
              title: Text('${localizations.match} ${localizations.details}'),
            ),
            body: SingleConsumer<Lineup>(
              id: match!.home.id!,
              initialData: match.home,
              builder: (context, homeLineup) => SingleConsumer<Lineup>(
                id: match.guest.id!,
                initialData: match.guest,
                builder: (context, guestLineup) {
                  final items = [
                    InfoWidget(
                        obj: match,
                        editPage: TeamMatchEdit(
                          teamMatch: match,
                        ),
                        onDelete: () => dataProvider.deleteSingle(match),
                        classLocale: localizations.match,
                        children: [
                          ContentItem(
                            title: match.no ?? '-',
                            subtitle: localizations.matchNumber,
                            icon: Icons.tag,
                          ),
                          ContentItem(
                            title: match.location ?? 'no location',
                            subtitle: localizations.place,
                            icon: Icons.place,
                          ),
                          ContentItem(
                            title: match.date?.toDateTimeString(context) ?? 'no date',
                            subtitle: localizations.date,
                            icon: Icons.date_range,
                          ),
                          ContentItem(
                            title: homeLineup!.team.name,
                            subtitle: '${localizations.team} ${localizations.red}',
                            icon: Icons.group,
                          ),
                          ContentItem(
                            title: guestLineup!.team.name,
                            subtitle: '${localizations.team} ${localizations.blue}',
                            icon: Icons.group,
                          ),
                          ContentItem(title: localizations.weightClass, icon: Icons.fitness_center, onTap: null),
                        ]),
                    ListGroup(
                      header: HeadingItem(title: localizations.persons),
                      items: [
                        ContentItem(title: localizations.referee, icon: Icons.sports, onTap: null),
                        ContentItem(title: localizations.matChairman, icon: Icons.manage_accounts, onTap: null),
                        ContentItem(title: localizations.timeKeeper, icon: Icons.pending_actions, onTap: null),
                        ContentItem(title: localizations.transcriptionWriter, icon: Icons.history_edu, onTap: null),
                        ContentItem(title: localizations.steward, icon: Icons.security, onTap: null),
                      ],
                    ),
                    ListGroup(
                      header: HeadingItem(title: '${localizations.lineups} & ${localizations.fights}'),
                      items: [
                        ContentItem(
                            title: homeLineup.team.name,
                            icon: Icons.view_list,
                            onTap: () =>
                                handleSelectedLineup(homeLineup, match.league ?? League.outOfCompetition, navigator)),
                        ContentItem(
                            title: guestLineup.team.name,
                            icon: Icons.view_list,
                            onTap: () =>
                                handleSelectedLineup(guestLineup, match.league ?? League.outOfCompetition, navigator)),
                        ContentItem(title: localizations.fights, icon: Icons.sports_kabaddi, onTap: null)
                      ],
                    ),
                  ];
                  return GroupedList(items: items);
                },
              ),
            ),
          );
        });
  }

  handleSelectedLineup(Lineup lineup, League league, NavigatorState navigator) async {
    final participations = await dataProvider.readMany<Participation, Lineup>(filterObject: lineup);
    final weightClasses = await dataProvider.readMany<WeightClass, League>(filterObject: league);
    navigator.push(
      MaterialPageRoute(
        builder: (context) {
          return LineupEdit(
            weightClasses: weightClasses,
            participations: participations,
            lineup: lineup,
            onSubmit: () {
              dataProvider.generateFights<TeamMatch>(match, false);
            },
          );
        },
      ),
    );
  }
}
