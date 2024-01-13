import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_client/data/bout_role.dart';
import 'package:wrestling_scoreboard_client/ui/components/consumer.dart';
import 'package:wrestling_scoreboard_client/ui/components/scaled_text.dart';
import 'package:wrestling_scoreboard_client/ui/components/themed.dart';
import 'package:wrestling_scoreboard_client/ui/display/bout/time_display.dart';
import 'package:wrestling_scoreboard_client/ui/models/participant_state_model.dart';
import 'package:wrestling_scoreboard_client/util/colors.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class TechnicalPoints extends StatelessWidget {
  final BoutRole role;
  final ParticipantStateModel pStatusModel;
  final Bout bout;

  const TechnicalPoints({required this.role, required this.pStatusModel, required this.bout, super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cellHeight = width / 6;
    return ThemedContainer(
      color: getColorFromBoutRole(role),
      height: cellHeight,
      child: Column(
        children: [
          Expanded(
            flex: 70,
            child: ManyStreamConsumer<BoutAction, Bout>(
              filterObject: bout,
              builder: (context, actions) {
                return FittedText(
                  (ParticipantState.getTechnicalPoints(actions, role)).toString(),
                  softWrap: false,
                );
              },
            ),
          ),
          if (pStatusModel.activityStopwatch != null)
            Expanded(
                flex: 40,
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  ScaledText(AppLocalizations.of(context)!.activityTimeAbbr, fontSize: 18),
                  TimeDisplay(pStatusModel.activityStopwatch!, white, fontSize: 18)
                ])),
          if (pStatusModel.isInjury)
            Expanded(
              flex: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ScaledText(AppLocalizations.of(context)!.injuryTimeShort, fontSize: 18),
                  TimeDisplay(pStatusModel.injuryStopwatch, white, fontSize: 18)
                ],
              ),
            ),
        ],
      ),
    );
  }
}
