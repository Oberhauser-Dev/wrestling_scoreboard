import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/bout_result.dart';
import 'package:wrestling_scoreboard_client/localization/bout_utils.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/duration.dart';
import 'package:wrestling_scoreboard_client/localization/wrestling_style.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/utils/duration.dart';
import 'package:wrestling_scoreboard_client/utils/units.dart';
import 'package:wrestling_scoreboard_client/view/utils.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaled_text.dart';
import 'package:wrestling_scoreboard_client/view/widgets/themed.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class BoutListItem extends ConsumerWidget {
  final BoutConfig boutConfig;
  final Bout bout;
  final WeightClass? weightClass;
  final AgeCategory? ageCategory;
  static const flexWidths = [17, 50, 30, 50];

  const BoutListItem({
    super.key,
    required this.boutConfig,
    required this.bout,
    required this.weightClass,
    this.ageCategory,
  });

  Widget displayName({
    AthleteBoutState? pStatus,
    required BoutRole role,
    double? fontSize,
    required BuildContext context,
  }) {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleConsumer<Bout>(
      initialData: bout,
      id: bout.id,
      builder: (context, bout) {
        return Row(
          children:
              [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          if (ageCategory != null) Center(child: ScaledText(ageCategory!.name, minFontSize: 8)),
                          if (weightClass != null)
                            Expanded(
                              child: Center(
                                child: ScaledText(
                                  '${weightClass!.weight} $weightUnit',
                                  softWrap: false,
                                  minFontSize: 10,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (weightClass != null)
                      Expanded(
                        child: Center(child: ScaledText(weightClass!.style.abbreviation(context), minFontSize: 12)),
                      ),
                  ],
                ),
                displayName(pStatus: bout.r, role: BoutRole.red, context: context),
                SmallBoutStateDisplay(bout: bout, boutConfig: boutConfig),
                displayName(pStatus: bout.b, role: BoutRole.blue, context: context),
              ].asMap().entries.map((entry) => Expanded(flex: flexWidths[entry.key], child: entry.value)).toList(),
        );
      },
    );
  }
}

class SmallBoutStateDisplay extends ConsumerWidget {
  final Bout bout;
  final BoutConfig boutConfig;

  const SmallBoutStateDisplay({super.key, required this.bout, required this.boutConfig});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleConsumer(
      initialData: bout,
      id: bout.id,
      builder: (context, bout) {
        return ManyConsumer<BoutAction, Bout>(
          filterObject: bout,
          builder:
              (context, actions) => Row(
                children: [
                  Expanded(
                    flex: 50,
                    child: displayParticipantState(pState: bout.r, role: BoutRole.red, bout: bout, actions: actions),
                  ),
                  Expanded(
                    flex: 100,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 70,
                          child: ThemedContainer(
                            color: bout.winnerRole?.color().shade800,
                            child: Center(child: ScaledText(bout.result?.abbreviation(context) ?? '', fontSize: 12)),
                          ),
                        ),
                        Expanded(
                          flex: 50,
                          child: Center(
                            child:
                                bout.result != null || bout.duration > Duration.zero
                                    ? LoadingBuilder<bool>(
                                      future: ref.watch(timeCountDownProvider),
                                      builder: (context, isTimeCountDown) {
                                        return ScaledText(
                                          bout.duration
                                              .invertIf(isTimeCountDown, max: boutConfig.totalPeriodDuration)
                                              .formatMinutesAndSeconds(),
                                          fontSize: 8,
                                        );
                                      },
                                    )
                                    : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 50,
                    child: displayParticipantState(pState: bout.b, role: BoutRole.blue, bout: bout, actions: actions),
                  ),
                ],
              ),
        );
      },
    );
  }

  Widget displayParticipantState({
    AthleteBoutState? pState,
    required Bout bout,
    required BoutRole role,
    required List<BoutAction> actions,
  }) {
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
                  child:
                      bout.result != null
                          ? ScaledText(pState?.classificationPoints?.toString() ?? '0', fontSize: 15)
                          : null,
                ),
              ),
            ),
            Expanded(
              flex: 50,
              child: ThemedContainer(
                color: color,
                child: Center(
                  child:
                      bout.result != null ||
                              technicalPoints > 0 ||
                              bout.duration > Duration.zero ||
                              pState?.classificationPoints != null
                          ? ScaledText(technicalPoints.toString(), fontSize: 8)
                          : null,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
