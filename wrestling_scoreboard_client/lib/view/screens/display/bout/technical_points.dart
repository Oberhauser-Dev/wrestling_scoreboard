import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/bout_utils.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/utils/colors.dart';
import 'package:wrestling_scoreboard_client/view/models/participant_state_model.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/bout_action_controls.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/time_display.dart';
import 'package:wrestling_scoreboard_client/view/utils.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaled_text.dart';
import 'package:wrestling_scoreboard_client/view/widgets/themed.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class ResponsiveTechnicalPoints extends StatelessWidget {
  final BoutRole role;
  final ParticipantStateModel pStatusModel;
  final Bout bout;
  final BoutConfig boutConfig;
  final WrestlingStyle? wrestlingStyle;
  final Function(Intent)? actionCallback;

  const ResponsiveTechnicalPoints({
    required this.role,
    required this.pStatusModel,
    required this.bout,
    required this.boutConfig,
    required this.wrestlingStyle,
    required this.actionCallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isHorizontal = !context.isMediumScreenOrLarger;
    final technicalPoints = TechnicalPoints(pStatusModel: pStatusModel, role: role, bout: bout, boutConfig: boutConfig);
    final boutActionControls = BoutActionControls(
      role,
      boutConfig,
      (role == BoutRole.red && bout.r == null) || (role == BoutRole.blue && bout.b == null) ? null : actionCallback,
      wrestlingStyle: wrestlingStyle,
      isHorizontal: isHorizontal,
    );
    return Expanded(
      flex: 33,
      child:
          isHorizontal
              ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [technicalPoints, boutActionControls])
              : Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children:
                    role == BoutRole.red
                        ? [Expanded(child: technicalPoints), boutActionControls]
                        : [boutActionControls, Expanded(child: technicalPoints)],
              ),
    );
  }
}

class TechnicalPoints extends StatelessWidget {
  final BoutRole role;
  final ParticipantStateModel pStatusModel;
  final Bout bout;
  final BoutConfig boutConfig;
  final timerFontSize = 32.0;
  final _timerMinFontSize = 12.0;

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
    final cellHeight = context.isMediumScreenOrLarger ? (width / 6) : (width / 3);
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
                  // The smaller the height value, the bigger the text.
                  style: const TextStyle(height: 1.1, fontWeight: FontWeight.bold),
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
                      ScaledText(
                        context.l10n.activityTimeAbbr,
                        minFontSize: _timerMinFontSize,
                        fontSize: timerFontSize,
                      ),
                      TimeDisplay(
                        activityStopwatch,
                        white,
                        fontSize: timerFontSize,
                        minFontSize: _timerMinFontSize,
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
                        ScaledText(
                          context.l10n.injuryTimeShort,
                          minFontSize: _timerMinFontSize,
                          fontSize: timerFontSize,
                        ),
                        TimeDisplay(
                          pStatusModel.injuryStopwatch,
                          white,
                          fontSize: timerFontSize,
                          minFontSize: _timerMinFontSize,
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
                        ScaledText(
                          context.l10n.bleedingInjuryTimeShort,
                          minFontSize: _timerMinFontSize,
                          fontSize: timerFontSize,
                        ),
                        TimeDisplay(
                          pStatusModel.bleedingInjuryStopwatch,
                          white,
                          fontSize: timerFontSize,
                          minFontSize: _timerMinFontSize,
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
