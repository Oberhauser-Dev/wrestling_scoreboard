import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/person_role.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/team_match_bout_display.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/event/bout_list_item.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/team_match_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaffold.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaled_text.dart';
import 'package:wrestling_scoreboard_client/view/widgets/themed.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class MatchDisplay extends ConsumerWidget {
  static const route = 'display';

  static void navigateTo(BuildContext context, TeamMatch match) {
    context.push('/${TeamMatchOverview.route}/${match.id}/$route');
  }

  final int id;
  final TeamMatch? teamMatch;

  const MatchDisplay({required this.id, this.teamMatch, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = context.l10n;
    final double width = MediaQuery.of(context).size.width;
    final double padding = width / 140;
    return LoadingBuilder(
      future: ref.watch(teamMatchChronologicalSortProvider),
      builder: (context, sortChronologically) {
        return SingleConsumer<TeamMatch>(
          id: id,
          initialData: teamMatch,
          builder: (context, match) {
            final chronologicalSortAction = ResponsiveScaffoldActionItem(
              label: sortChronologically ? localizations.sortedChronologically : localizations.sortedByWeightClass,
              icon: Icon(sortChronologically ? Icons.timeline : Icons.format_list_numbered),
              onTap:
                  () => ref
                      .read(teamMatchChronologicalSortProvider.notifier)
                      .setState(sortChronologically = !sortChronologically),
            );
            final infoAction = ResponsiveScaffoldActionItem(
              label: localizations.info,
              icon: const Icon(Icons.info),
              onTap: () => TeamMatchOverview.navigateTo(context, match),
            );
            final pdfAction = ResponsiveScaffoldActionItem(
              label: localizations.print,
              icon: const Icon(Icons.print),
              onTap: () => TeamMatchOverview.shareTeamMatchTranscript(context, ref, match),
            );
            return DisplayTheme(
              child: WindowStateScaffold(
                hideAppBarOnFullscreen: true,
                actions: [infoAction, pdfAction, chronologicalSortAction],
                body: ManyConsumer<TeamMatchPerson, TeamMatch>(
                  filterObject: match,
                  builder: (context, officials) {
                    return ManyConsumer<TeamMatchBout, TeamMatch>(
                      filterObject: match,
                      builder: (context, teamMatchBouts) {
                        if (sortChronologically) {
                          teamMatchBouts = TeamMatchBout.sortChronologically(teamMatchBouts);
                        }

                        final matchInfos = [match.league?.fullname, '${localizations.matchNumber}: ${match.id ?? ''}'];
                        final headerItems = <Widget>[
                          Padding(
                            padding: EdgeInsets.all(padding),
                            child: Center(
                              child: ScaledText(matchInfos.join('\n'), softWrap: false, fontSize: 12, minFontSize: 10),
                            ),
                          ),
                          ...CommonElements.getTeamHeader(
                            match.home.team,
                            match.guest.team,
                            teamMatchBouts.map((e) => e.bout).toList(),
                            context,
                          ),
                        ];
                        final column = Column(
                          children: [
                            IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children:
                                    headerItems
                                        .asMap()
                                        .entries
                                        .map(
                                          (entry) =>
                                              Expanded(flex: BoutListItem.flexWidths[entry.key], child: entry.value),
                                        )
                                        .toList(),
                              ),
                            ),
                            Expanded(
                              child: SafeArea(
                                child: ListView.builder(
                                  itemCount: teamMatchBouts.length,
                                  itemBuilder: (context, index) {
                                    return SingleConsumer<TeamMatchBout>(
                                      id: teamMatchBouts[index].id,
                                      initialData: teamMatchBouts[index],
                                      builder: (context, teamMatchBout) {
                                        return Column(
                                          children: [
                                            InkWell(
                                              onTap: () => TeamMatchBoutDisplay.navigateTo(context, teamMatchBout),
                                              child: IntrinsicHeight(
                                                child: BoutListItem(
                                                  boutConfig:
                                                      match.league?.division.boutConfig ?? TeamMatch.defaultBoutConfig,
                                                  bout: teamMatchBout.bout,
                                                  weightClass: teamMatchBout.weightClass,
                                                ),
                                              ),
                                            ),
                                            const Divider(height: 1),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                            Row(
                              children:
                                  officials
                                      .where(
                                        (official) =>
                                            official.role == PersonRole.referee ||
                                            official.role == PersonRole.matChairman ||
                                            official.role == PersonRole.judge,
                                      )
                                      .map(
                                        (tmp) => Expanded(
                                          child: Center(
                                            child: Text('${tmp.role.localize(context)}: ${tmp.person.fullName}'),
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),
                          ],
                        );
                        return column;
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
