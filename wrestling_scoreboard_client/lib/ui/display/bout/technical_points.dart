import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wrestling_scoreboard_client/data/bout_role.dart';
import 'package:wrestling_scoreboard_client/ui/components/scaled_text.dart';
import 'package:wrestling_scoreboard_client/ui/components/themed.dart';
import 'package:wrestling_scoreboard_client/ui/display/bout/time_display.dart';
import 'package:wrestling_scoreboard_client/ui/models/participant_state_model.dart';
import 'package:wrestling_scoreboard_client/util/colors.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class TechnicalPoints extends StatelessWidget {
  final BoutRole role;
  final ParticipantStateModel pStatusModel;

  const TechnicalPoints({required this.role, required this.pStatusModel, super.key});

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
            child: Consumer<List<BoutAction>>(
              builder: (context, data, child) => FittedText(
                (ParticipantState.getTechnicalPoints(data, role)).toString(),
                softWrap: false,
              ),
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
