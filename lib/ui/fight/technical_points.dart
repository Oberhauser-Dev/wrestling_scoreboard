import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wrestling_scoreboard/data/fight.dart';
import 'package:wrestling_scoreboard/data/fight_role.dart';
import 'package:wrestling_scoreboard/ui/models/participant_status_model.dart';

class TechnicalPoints extends StatelessWidget {
  final double height;
  final FightRole role;
  final ParticipantStatusModel pStatusModel;

  TechnicalPoints({required this.height, required this.role, required this.pStatusModel});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double fontSize = width / 9;

    return Container(
        color: role == FightRole.red ? Colors.red : Colors.blue,
        height: height,
        child: Center(
          child: Consumer<Fight>(
            builder: (context, cart, child) =>
                Text((pStatusModel.pStatus?.technicalPoints ?? 0).toString(), style: TextStyle(fontSize: fontSize)),
          ),
        ));
  }
}
