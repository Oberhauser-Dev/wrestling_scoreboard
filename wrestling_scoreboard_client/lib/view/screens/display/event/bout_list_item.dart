import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/bout_result.dart';
import 'package:wrestling_scoreboard_client/localization/bout_utils.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/duration.dart';
import 'package:wrestling_scoreboard_client/localization/wrestling_style.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/utils/duration.dart';
import 'package:wrestling_scoreboard_client/utils/units.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/competition_bout_display.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_overview.dart';
import 'package:wrestling_scoreboard_client/view/utils.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaffold.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaled_text.dart';
import 'package:wrestling_scoreboard_client/view/widgets/themed.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class BoutListItem extends ConsumerWidget {
  final BoutConfig boutConfig;
  final Bout bout;
  final WeightClass? weightClass;
  final List<BoutAction> actions;
  static const flexWidths = [17, 50, 30, 50];

  const BoutListItem({
    super.key,
    required this.boutConfig,
    required this.bout,
    required this.weightClass,
    required this.actions,
  });

  displayName({AthleteBoutState? pStatus, required BoutRole role, double? fontSize, required BuildContext context}) {
    return ThemedContainer(
      color: role.color(),
      child: Center(
        child: ScaledText(
          pStatus == null ? context.l10n.participantVacant : pStatus.membership.person.fullName,
          color: pStatus == null ? Colors.white.disabled() : Colors.white,
          fontSize: 17,
          minFontSize: 14,
        ),
      ),
    );
  }

  Widget displayParticipantState({AthleteBoutState? pState, required Bout bout, required BoutRole role}) {
    final color = (role == bout.winnerRole) ? role.color().shade800 : null;
    return NullableSingleConsumer<AthleteBoutState>(
      id: pState?.id,
      initialData: pState,
      builder: (context, pState) {
        final technicalPoints = AthleteBoutState.getTechnicalPoints(actions, role);
        return Column(
          children: [
            Expanded(
                flex: 70,
                child: ThemedContainer(
                  color: color,
                  child: Center(
                    child: bout.result != null
                        ? ScaledText(
                      pState?.classificationPoints?.toString() ?? '0',
                      fontSize: 15,
                    )
                        : null,
                  ),
                )),
            Expanded(
              flex: 50,
              child: ThemedContainer(
                color: color,
                child: Center(
                  child: bout.result != null ||
                      technicalPoints > 0 ||
                      bout.duration > Duration.zero ||
                      pState?.classificationPoints != null
                      ? ScaledText(
                    technicalPoints.toString(),
                    fontSize: 8,
                  )
                      : null,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final padding = width / 100;
    final edgeInsets = EdgeInsets.all(padding);
    return LoadingBuilder<bool>(
        future: ref.watch(timeCountDownNotifierProvider),
        builder: (context, isTimeCountDown) {
          return SingleConsumer<Bout>(
              initialData: bout,
              id: bout.id,
              builder: (context, bout) {
                final winnerRole = bout.winnerRole;
                return Row(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: edgeInsets,
                            child: weightClass == null
                                ? null
                                : Center(
                              child: ScaledText(
                                '${weightClass!.weight} $weightUnit',
                                softWrap: false,
                                minFontSize: 10,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: weightClass == null
                                ? null
                                : ScaledText(
                              weightClass!.style.abbreviation(context),
                              minFontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    displayName(pStatus: bout.r, role: BoutRole.red, context: context),
                    Row(
                      children: [
                        Expanded(
                          flex: 50,
                          child: displayParticipantState(pState: bout.r, role: BoutRole.red, bout: bout),
                        ),
                        Expanded(
                          flex: 100,
                          child: Column(
                            children: [
                              Expanded(
                                  flex: 70,
                                  child: ThemedContainer(
                                    color: winnerRole?.color().shade800,
                                    child: Center(
                                      child: ScaledText(bout.result?.abbreviation(context) ?? '', fontSize: 12),
                                    ),
                                  )),
                              Expanded(
                                flex: 50,
                                child: Center(
                                  child: bout.result != null || bout.duration > Duration.zero
                                      ? ScaledText(
                                      bout.duration
                                          .invertIf(isTimeCountDown, max: boutConfig.totalPeriodDuration)
                                          .formatMinutesAndSeconds(),
                                      fontSize: 8)
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 50,
                          child: displayParticipantState(pState: bout.b, role: BoutRole.blue, bout: bout),
                        ),
                      ],
                    ),
                    displayName(pStatus: bout.b, role: BoutRole.blue, context: context),
                  ]
                      .asMap()
                      .entries
                      .map((entry) => Expanded(flex: flexWidths[entry.key], child: entry.value))
                      .toList(),
                );
              });
        });
  }
}
