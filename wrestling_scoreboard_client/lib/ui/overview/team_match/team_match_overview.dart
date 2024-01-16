import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/data/bout_utils.dart';
import 'package:wrestling_scoreboard_client/ui/components/consumer.dart';
import 'package:wrestling_scoreboard_client/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard_client/ui/components/info.dart';
import 'package:wrestling_scoreboard_client/ui/display/match/match_display.dart';
import 'package:wrestling_scoreboard_client/ui/edit/lineup_edit.dart';
import 'package:wrestling_scoreboard_client/ui/edit/team_match/team_match_bout_edit.dart';
import 'package:wrestling_scoreboard_client/ui/edit/team_match/team_match_edit.dart';
import 'package:wrestling_scoreboard_client/ui/overview/common.dart';
import 'package:wrestling_scoreboard_client/ui/overview/team_match/team_match_bout_overview.dart';
import 'package:wrestling_scoreboard_client/util/date_time.dart';
import 'package:wrestling_scoreboard_client/util/network/data_provider.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class TeamMatchOverview extends StatelessWidget {
  static const route = 'match';

  final int id;
  final TeamMatch? match;

  const TeamMatchOverview({required this.id, this.match, super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);

    return SingleConsumer<TeamMatch>(
        id: id,
        initialData: match,
        builder: (context, match) {
          return Scaffold(
            appBar: AppBar(
              title: AppBarTitle(
                label: localizations.match,
                details: '${match.home.team.name} - ${match.guest.team.name}',
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.tv),
                    onPressed: () => handleSelectedMatchSequence(match, context),
                    label: Text(localizations.display),
                  ),
                )
              ],
            ),
            body: SingleConsumer<Lineup>(
              id: match.home.id!,
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
                        onDelete: () => dataProvider.deleteSingle<TeamMatch>(match),
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
                            title: match.date.toDateTimeString(context),
                            subtitle: localizations.date,
                            icon: Icons.date_range,
                          ),
                          ContentItem(
                            title: homeLineup.team.name,
                            subtitle: '${localizations.team} ${localizations.red}',
                            icon: Icons.group,
                          ),
                          ContentItem(
                            title: guestLineup.team.name,
                            subtitle: '${localizations.team} ${localizations.blue}',
                            icon: Icons.group,
                          ),
                          ContentItem(
                            title: match.league?.name ?? '-',
                            subtitle: localizations.league,
                            icon: Icons.emoji_events,
                          ),
                        ]),
                    ListGroup(
                      header: HeadingItem(title: localizations.persons),
                      items: [
                        ContentItem(
                          title: match.referee?.fullName ?? '-',
                          subtitle: localizations.referee,
                          icon: Icons.sports,
                        ),
                        ContentItem(
                          title: match.matChairman?.fullName ?? '-',
                          subtitle: localizations.matChairman,
                          icon: Icons.manage_accounts,
                        ),
                        ContentItem(
                          title: match.judge?.fullName ?? '-',
                          subtitle: localizations.judge,
                          icon: Icons.manage_accounts,
                        ),
                        ContentItem(
                          title: match.timeKeeper?.fullName ?? '-',
                          subtitle: localizations.timeKeeper,
                          icon: Icons.pending_actions,
                        ),
                        ContentItem(
                          title: match.transcriptWriter?.fullName ?? '-',
                          subtitle: localizations.transcriptionWriter,
                          icon: Icons.history_edu,
                        ),
                        ContentItem(
                          title: '-', // Multiple stewards
                          subtitle: localizations.steward,
                          icon: Icons.security,
                        ),
                      ],
                    ),
                    ListGroup(
                      header: HeadingItem(title: localizations.lineups),
                      items: [
                        ContentItem(
                            title: homeLineup.team.name,
                            icon: Icons.view_list,
                            onTap: () => handleSelectedLineup(
                                  homeLineup,
                                  match.league ?? League.outOfCompetition,
                                  match,
                                  navigator,
                                )),
                        ContentItem(
                            title: guestLineup.team.name,
                            icon: Icons.view_list,
                            onTap: () => handleSelectedLineup(
                                  guestLineup,
                                  match.league ?? League.outOfCompetition,
                                  match,
                                  navigator,
                                )),
                      ],
                    ),
                    ManyConsumer<TeamMatchBout, TeamMatch>(
                      filterObject: match,
                      builder: (BuildContext context, List<TeamMatchBout> teamMatchBouts) {
                        return ListGroup(
                          header: HeadingItem(
                            title: localizations.bouts,
                            trailing: IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TeamMatchBoutEdit(
                                    initialTeamMatch: match,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          items: teamMatchBouts.map(
                            (bout) => SingleConsumer<TeamMatchBout>(
                              id: bout.id,
                              initialData: bout,
                              builder: (context, teamMatchBout) => ContentItem(
                                title: getBoutTitle(context, teamMatchBout.bout),
                                icon: Icons.sports_kabaddi,
                                onTap: () => handleSelectedBout(teamMatchBout, context),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ];
                  return GroupedList(items: items);
                },
              ),
            ),
          );
        });
  }

  handleSelectedBout(TeamMatchBout bout, BuildContext context) {
    context.push('/${TeamMatchBoutOverview.route}/${bout.id}');
  }

  handleSelectedMatchSequence(TeamMatch match, BuildContext context) {
    context.push('/${TeamMatchOverview.route}/${match.id}/${MatchDisplay.route}');
  }

  handleSelectedLineup(Lineup lineup, League league, TeamMatch match, NavigatorState navigator) async {
    final participations = await dataProvider.readMany<Participation, Lineup>(filterObject: lineup);
    final weightClasses = await dataProvider.readMany<WeightClass, League>(filterObject: league);
    navigator.push(
      MaterialPageRoute(
        builder: (context) {
          return LineupEdit(
            weightClasses: weightClasses,
            participations: participations,
            lineup: lineup,
            onSubmitGenerate: () {
              dataProvider.generateBouts<TeamMatch>(match, false);
            },
          );
        },
      ),
    );
  }
}