import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:wrestling_scoreboard_client/localization/bout_utils.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/competition_bout_display.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/event/bout_list_item.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/formatter.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaffold.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaled_text.dart';
import 'package:wrestling_scoreboard_client/view/widgets/themed.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class CompetitionDisplay extends StatelessWidget {
  static const route = 'display';

  static void navigateTo(BuildContext context, Competition competition) {
    context.push('/${CompetitionOverview.route}/${competition.id}/$route');
  }

  final int id;
  final Competition? competition;

  const CompetitionDisplay({required this.id, this.competition, super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    final double width = MediaQuery.of(context).size.width;
    return SingleConsumer<Competition>(
      id: id,
      initialData: competition,
      builder: (context, competition) {
        final infoAction = DefaultResponsiveScaffoldActionItem(
          label: localizations.info,
          icon: const Icon(Icons.info),
          onTap: () => CompetitionOverview.navigateTo(context, competition),
        );

        Widget displayParticipant(AthleteBoutState? state, BoutRole role) {
          return Container(
            color: role.color(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: ScaledText(
                    state?.membership.person.fullName ?? localizations.participantVacant,
                    fontSize: 18,
                    minFontSize: 12,
                  ),
                ),
                Center(child: ScaledText(state?.membership.club.name ?? '', fontSize: 12, minFontSize: 12)),
              ],
            ),
          );
        }

        return DisplayTheme(
          child: WindowStateScaffold(
            hideAppBarOnFullscreen: true,
            actions: [infoAction],
            body: ManyConsumer<CompetitionBout, Competition>(
              filterObject: competition,
              builder: (context, competitionBouts) {
                final competitionInfos = [
                  '${localizations.competitionNumber}: ${competition.id ?? ''}',
                  '${localizations.date}: ${competition.date.toDateString(context)}',
                ];
                int initialScrollIndex = competitionBouts.indexWhere((element) => element.mat == null);
                if (initialScrollIndex < 0) {
                  // Scroll to last element if non is found
                  initialScrollIndex = math.max(0, competitionBouts.length - 1);
                }
                final column = Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          children:
                              competitionInfos
                                  .map(
                                    (e) => Center(child: ScaledText(e, softWrap: false, fontSize: 10, minFontSize: 8)),
                                  )
                                  .toList(),
                        ),
                        Expanded(
                          child: Center(
                            child: ScaledText(competition.name, softWrap: false, fontSize: 16, minFontSize: 12),
                          ),
                        ),
                        Center(child: ScaledText('Estimated end: TODO', softWrap: false, fontSize: 10, minFontSize: 8)),
                      ],
                    ),
                    Divider(),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: 12,
                        children:
                            Iterable.generate(competition.matCount, (index) {
                              // Either get the last bout of this mat, which has no bout result, or get the first bout which has a result.
                              final matCompetitionBouts = competitionBouts.where((element) => element.mat == index);
                              CompetitionBout? matCompetitionBout =
                                  matCompetitionBouts.where((element) => element.bout.result == null).firstOrNull;
                              matCompetitionBout ??=
                                  matCompetitionBouts.where((element) => element.bout.result != null).lastOrNull;
                              Widget matDisplay;
                              if (matCompetitionBout != null) {
                                matDisplay = InkWell(
                                  onTap: () => CompetitionBoutDisplay.navigateTo(context, matCompetitionBout!),
                                  child: SingleConsumer<Bout>(
                                    id: matCompetitionBout.bout.id,
                                    initialData: matCompetitionBout.bout,
                                    builder: (context, bout) {
                                      Widget column = Column(
                                        children: [
                                          Center(
                                            child: ScaledText(
                                              matCompetitionBout!.weightCategory?.name ?? '---',
                                              fontSize: 12,
                                              minFontSize: 10,
                                            ),
                                          ),
                                          displayParticipant(bout.r, BoutRole.red),
                                          SizedBox(
                                            height: width / 30,
                                            child: SmallBoutStateDisplay(
                                              bout: bout,
                                              boutConfig: competition.boutConfig,
                                            ),
                                          ),
                                          displayParticipant(bout.b, BoutRole.blue),
                                        ],
                                      );

                                      if (bout.result != null) {
                                        column = Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            column,
                                            Container(
                                              color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.5),
                                            ),
                                          ],
                                        );
                                      }
                                      return column;
                                    },
                                  ),
                                );
                              } else {
                                matDisplay = Center(child: ScaledText('No bout'));
                              }
                              return Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Center(child: ScaledText('${localizations.mat}: ${index + 1}')),
                                    Expanded(child: matDisplay),
                                  ],
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                    Divider(height: 1),
                    Expanded(
                      child: SafeArea(
                        child: ScrollablePositionedList.builder(
                          // TODO: initialScrollIndex is not updated in ScrollablePositionedList, this also cannot properly be set via the itemScrollController
                          // ScrollablePositionedList currently is not maintained
                          key: ValueKey(competitionBouts),
                          initialScrollIndex: initialScrollIndex,
                          itemCount: competitionBouts.length,
                          itemBuilder: (context, index) {
                            if (index == -1) return Center(child: Text(localizations.noItems));
                            final competitionBout = competitionBouts[index];
                            return Column(
                              children: [
                                _CompetitionBoutListItem(competition: competition, competitionBout: competitionBout),
                                const Divider(height: 1),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
                return column;
              },
            ),
          ),
        );
      },
    );
  }
}

class _CompetitionBoutListItem extends ConsumerWidget {
  final Competition competition;
  final CompetitionBout competitionBout;

  const _CompetitionBoutListItem({required this.competition, required this.competitionBout});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => CompetitionBoutDisplay.navigateTo(context, competitionBout),
      child: IntrinsicHeight(
        child: DefaultTextStyle.merge(
          style: competitionBout.mat == null ? null : TextStyle(color: Theme.of(context).disabledColor),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(competitionBout.id.toString()),
              Expanded(
                child: BoutListItem(
                  boutConfig: competition.boutConfig,
                  bout: competitionBout.bout,
                  weightClass: competitionBout.weightCategory?.weightClass,
                  ageCategory: competitionBout.weightCategory?.competitionAgeCategory.ageCategory,
                ),
              ),
              SizedBox(
                width: 40,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  initialValue: competitionBout.mat == null ? null : (competitionBout.mat! + 1).toString(),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    NumericalRangeFormatter(min: 1, max: competition.matCount.toDouble() + 1),
                  ],
                  onFieldSubmitted: (value) async {
                    int? mat = int.tryParse(value);
                    if (mat != null) mat = mat - 1;
                    await catchAsync(
                      context,
                      () async => (await ref.read(
                        dataManagerProvider,
                      )).createOrUpdateSingle(competitionBout.copyWith(mat: mat)),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
