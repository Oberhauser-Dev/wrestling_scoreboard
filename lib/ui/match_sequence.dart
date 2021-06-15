import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard/data/fight.dart';
import 'package:wrestling_scoreboard/data/team_match.dart';
import 'package:wrestling_scoreboard/data/wrestling_style.dart';

class MatchSequence extends StatelessWidget {
  late TeamMatch match;
  static double cellHeightHeader = 60;
  static double cellHeight = 50;
  static double cellWidthPoints = 50;

  MatchSequence(TeamMatch match) {
    this.match = match;
  }

  @override
  Widget build(BuildContext context) {
    var fights = match.fights;
    return Scaffold(
      body: Column(children: [
        Column(children: [
          Row(children: [
            Container(
              height: cellHeightHeader,
              width: 80,
            ),
            Container(
              height: cellHeightHeader,
              width: 50,
            ),
            Expanded(
                child: Container(
              height: cellHeightHeader,
              color: Colors.red.shade800,
              child: Center(child: Text(match.home.team.name)),
            )),
            Container(
              height: cellHeightHeader,
              width: cellWidthPoints,
              color: Colors.red.shade900,
              child: Center(
                  child: Text(
                match.homePoints.toString(),
                style: TextStyle(fontSize: 18),
              )),
            ),
            Container(
              height: cellHeightHeader,
              width: cellWidthPoints,
              color: Colors.blue.shade900,
              child: Center(
                  child: Text(
                match.guestPoints.toString(),
                style: TextStyle(fontSize: 18),
              )),
            ),
            Expanded(
                child: Container(
              height: cellHeightHeader,
              color: Colors.blue.shade800,
              child: Center(child: Text(match.guest.team.name)),
            ))
          ]),
          Divider(
            height: 1,
          ),
        ]),
        Expanded(
          child: ListView.builder(
              itemCount: fights.length,
              itemBuilder: (context, index) {
                var fight = fights[index];
                return Column(children: [
                  Row(children: [
                    Container(
                      height: cellHeight,
                      width: 80,
                      child: Center(child: Text('${fight.weightClass.weight} kg')),
                    ),
                    Container(
                      height: cellHeight,
                      width: 50,
                      child: Center(child: Text('${fight.weightClass.style == WrestlingStyle.free ? 'F' : 'G'}')),
                    ),
                    Expanded(
                        child: Container(
                      height: cellHeight,
                      color: Colors.red,
                      child: Center(
                          child: Text(
                        fight.r == null
                            ? 'Unbesetzt'
                            : '${fight.r?.participant.prename} ${fight.r?.participant.surname}',
                        style: TextStyle(color: fight.r == null ? Colors.white30 : Colors.white),
                      )),
                    )),
                    Container(
                      height: cellHeight,
                      width: cellWidthPoints,
                      color: fight.winner == FightRole.red ? Colors.red.shade800 : null,
                      child: Center(
                        child: Text(fight.r?.classificationPoints?.toString() ?? '-'),
                      ),
                    ),
                    Container(
                      height: cellHeight,
                      width: cellWidthPoints,
                      color: fight.winner == FightRole.blue ? Colors.blue.shade800 : null,
                      child: Center(
                        child: Text(fight.b?.classificationPoints?.toString() ?? '-'),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      height: cellHeight,
                      color: Colors.blue,
                      child: Center(
                          child: Text(
                        fight.b == null
                            ? 'Unbesetzt'
                            : '${fight.b?.participant.prename} ${fight.b?.participant.surname}',
                        style: TextStyle(color: fight.b == null ? Colors.white30 : Colors.white),
                      )),
                    ))
                  ]),
                  Divider(
                    height: 1,
                  ),
                ]);
              }),
        ),
      ]),
    );
  }
}
