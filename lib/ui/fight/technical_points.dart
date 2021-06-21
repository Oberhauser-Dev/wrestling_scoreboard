import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wrestling_scoreboard/data/fight.dart';
import 'package:wrestling_scoreboard/data/fight_role.dart';
import 'package:wrestling_scoreboard/ui/components/FittedText.dart';
import 'package:wrestling_scoreboard/ui/fight/time_display.dart';
import 'package:wrestling_scoreboard/ui/models/participant_status_model.dart';
import 'package:wrestling_scoreboard/util/colors.dart';

class TechnicalPoints extends StatelessWidget {
  final double height;
  final FightRole role;
  final ParticipantStatusModel pStatusModel;

  TechnicalPoints({required this.height, required this.role, required this.pStatusModel});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: getColorFromFightRole(role),
        height: height,
        child: Column(children: [
          Expanded(
            flex: 70,
            child: Center(
              child: Consumer<Fight>(
                  builder: (context, cart, child) =>
                      FittedText((pStatusModel.pStatus?.technicalPoints ?? 0).toString())),
            ),
          ),
          if (pStatusModel.activityStopwatch != null)
            Expanded(
                flex: 50,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [FittedText('AT'), TimeDisplay(pStatusModel.activityStopwatch!, white)])),
          if (pStatusModel.isInjury)
            Expanded(
                flex: 50,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [FittedText('IT'), TimeDisplay(pStatusModel.injuryStopwatch, white)])),
        ]));
  }
}
