import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/ui/components/scaled_text.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class CommonElements {
  static List<Widget> getTeamHeader(TeamMatch match, List<Bout> bouts, BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = width / 100;
    final edgeInsets = EdgeInsets.all(padding);
    return [
      Container(
          color: Colors.red.shade800,
          padding: edgeInsets,
          child: Center(
            child: ScaledText(
              match.home.team.name,
              fontSize: 28,
              minFontSize: 16,
            ),
          )),
      Row(
        children: [
          Expanded(
            child: Container(
              color: Colors.red.shade900,
              child: Center(
                child: ScaledText(
                  TeamMatch.getHomePoints(bouts).toString(),
                  fontSize: 28,
                  minFontSize: 16,
                  softWrap: false,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.blue.shade900,
              child: Center(
                child: ScaledText(
                  TeamMatch.getGuestPoints(bouts).toString(),
                  fontSize: 28,
                  minFontSize: 16,
                  softWrap: false,
                ),
              ),
            ),
          ),
        ],
      ),
      Container(
        color: Colors.blue.shade800,
        padding: edgeInsets,
        child: Center(
          child: ScaledText(
            match.guest.team.name,
            fontSize: 28,
            minFontSize: 16,
          ),
        ),
      ),
    ];
  }
}
