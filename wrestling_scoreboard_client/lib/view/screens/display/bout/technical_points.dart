import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/bout_utils.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/utils/colors.dart';
import 'package:wrestling_scoreboard_client/view/models/participant_state_model.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/time_display.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaled_text.dart';
import 'package:wrestling_scoreboard_client/view/widgets/themed.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class TechnicalPoints extends StatelessWidget {
  final BoutRole role;
  final ParticipantStateModel pStatusModel;
  final Bout bout;
  final BoutConfig boutConfig;
  final timerFontSize = 32.0;

  const TechnicalPoints({
    required this.role,
    required this.pStatusModel,
    required this.bout,
    required this.boutConfig,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cellHeight = width / 6;
    return ThemedContainer(
      color: role.color(),
      height: cellHeight,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 70,
            child: ManyConsumer<BoutAction, Bout>(
              filterObject: bout,
              builder: (context, actions) {
                return FittedText(
                  (AthleteBoutState.getTechnicalPoints(actions, role)).toString(),
                  softWrap: false,
                  style: const TextStyle(height: 1.2, fontWeight: FontWeight.bold),
                );
              },
            ),
          ),
          if (boutConfig.activityDuration != null)
            ValueListenableBuilder(
              valueListenable: pStatusModel.activityStopwatchNotifier,
              builder: (context, activityStopwatch, _) {
                if (activityStopwatch == null) return SizedBox.shrink();
                return Expanded(
                  flex: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ScaledText(context.l10n.activityTimeAbbr, fontSize: timerFontSize),
                      TimeDisplay(
                        activityStopwatch,
                        white,
                        fontSize: timerFontSize,
                        maxDuration: boutConfig.activityDuration!,
                      ),
                    ],
                  ),
                );
              },
            ),
          if (boutConfig.injuryDuration != null)
            ValueListenableBuilder(
              valueListenable: pStatusModel.isInjuryDisplayedNotifier,
              builder: (context, isInjuryDisplayed, _) {
                return Visibility(
                  visible: isInjuryDisplayed,
                  child: Expanded(
                    flex: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ScaledText(context.l10n.injuryTimeShort, fontSize: timerFontSize),
                        TimeDisplay(
                          pStatusModel.injuryStopwatch,
                          white,
                          fontSize: timerFontSize,
                          maxDuration: boutConfig.injuryDuration!,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          if (boutConfig.bleedingInjuryDuration != null)
            ValueListenableBuilder(
              valueListenable: pStatusModel.isBleedingInjuryDisplayedNotifier,
              builder: (context, isBleedingInjuryDisplayed, _) {
                return Visibility(
                  visible: isBleedingInjuryDisplayed,
                  child: Expanded(
                    flex: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ScaledText(context.l10n.bleedingInjuryTimeShort, fontSize: timerFontSize),
                        TimeDisplay(
                          pStatusModel.bleedingInjuryStopwatch,
                          white,
                          fontSize: timerFontSize,
                          maxDuration: boutConfig.bleedingInjuryDuration!,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
