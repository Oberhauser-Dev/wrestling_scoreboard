import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wrestling_scoreboard/data/team_match.dart';
import 'package:wrestling_scoreboard/ui/components/fitted_text.dart';

class CommonElements {
  static List<Widget> getTeamHeader(ClientTeamMatch match, BuildContext context) {
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
                child: Consumer<ClientTeamMatch>(
                    builder: (context, data, child) => FittedText(
                          data.homePoints.toString(),
                        )),
              ))),
      Expanded(
          flex: 10,
          child: Container(
              height: cellHeight,
              color: Colors.blue.shade900,
              padding: EdgeInsets.all(padding),
              child: Center(
                child: Consumer<ClientTeamMatch>(
                    builder: (context, data, child) => FittedText(
                          data.guestPoints.toString(),
                        )),
              ))),
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
