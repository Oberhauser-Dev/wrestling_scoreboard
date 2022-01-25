import 'package:common/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wrestling_scoreboard/data/fight_role.dart';
import 'package:wrestling_scoreboard/ui/components/fitted_text.dart';
import 'package:wrestling_scoreboard/ui/fight/time_display.dart';
import 'package:wrestling_scoreboard/ui/models/participant_state_model.dart';
import 'package:wrestling_scoreboard/util/colors.dart';

class TechnicalPoints extends StatelessWidget {
  final double height;
  final FightRole role;
  final ParticipantStateModel pStatusModel;

  const TechnicalPoints({required this.height, required this.role, required this.pStatusModel, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: getColorFromFightRole(role),
      height: height,
      child: Column(
        children: [
          Expanded(
            flex: 70,
            child: Center(
              child: Consumer<List<FightAction>>(
                  builder: (context, data, child) =>
                      FittedText((ParticipantState.getTechnicalPoints(data, role)).toString())),
            ),
          ),
          if (pStatusModel.activityStopwatch != null)
            Expanded(
                flex: 50,
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  FittedText(AppLocalizations.of(context)!.activityTimeAbbr),
                  TimeDisplay(pStatusModel.activityStopwatch!, white)
                ])),
          if (pStatusModel.isInjury)
            Expanded(
              flex: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FittedText(AppLocalizations.of(context)!.injuryTimeShort),
                  TimeDisplay(pStatusModel.injuryStopwatch, white)
                ],
              ),
            ),
        ],
      ),
    );
  }
}
