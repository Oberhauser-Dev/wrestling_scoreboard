import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wrestling_scoreboard/data/fight.dart';
import 'package:wrestling_scoreboard/data/fight_role.dart';
import 'package:wrestling_scoreboard/data/participant_status.dart';

class TechnicalPoints extends StatelessWidget {
  final double height;
  final FightRole role;
  final ParticipantStatus? pStatus;

  TechnicalPoints({required this.height, required this.role, required this.pStatus});

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
                Text((pStatus?.technicalPoints ?? 0).toString(), style: TextStyle(fontSize: fontSize)),
          ),
        ));
  }
}
