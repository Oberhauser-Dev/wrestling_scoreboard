import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard/ui/components/fitted_text.dart';

class CommonElements {
  static List<Widget> getTeamHeader(TeamMatch match, List<Fight> fights, BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double padding = width / 75;
    double cellHeight = width / 15;
    return [
      Expanded(
          flex: 50,
          child: Container(
            height: cellHeight,
            padding: EdgeInsets.all(padding),
            color: Colors.red.shade800,
            child: Center(child: FittedText(match.home.team.name)),
          )),
      Expanded(
        flex: 10,
        child: Container(
          height: cellHeight,
          color: Colors.red.shade900,
          padding: EdgeInsets.all(padding),
          child: Center(
            child: FittedText(
              TeamMatch.getHomePoints(fights).toString(),
            ),
          ),
        ),
      ),
      Expanded(
        flex: 10,
        child: Container(
          height: cellHeight,
          color: Colors.blue.shade900,
          padding: EdgeInsets.all(padding),
          child: Center(
            child: FittedText(
              TeamMatch.getGuestPoints(fights).toString(),
            ),
          ),
        ),
      ),
      Expanded(
          flex: 50,
          child: Container(
            height: cellHeight,
            padding: EdgeInsets.all(padding),
            color: Colors.blue.shade800,
            child: Center(child: FittedText(match.guest.team.name)),
          ))
    ];
  }
}
