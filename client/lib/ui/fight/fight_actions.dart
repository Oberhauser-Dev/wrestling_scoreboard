import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard/data/fight_action.dart';
import 'package:wrestling_scoreboard/data/fight_role.dart';
import 'package:wrestling_scoreboard/ui/components/fitted_text.dart';
import 'package:wrestling_scoreboard/util/date_time.dart';

class ActionsWidget extends StatelessWidget {
  final List<FightAction> actions;

  ActionsWidget(this.actions) {
    actions.sort((a, b) => a.duration.compareTo(b.duration));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double padding = width / 100;
    double cellHeight = width / 18;

    return SingleChildScrollView(
      reverse: true,
      scrollDirection: Axis.horizontal,
      child: IntrinsicHeight(
        child: Row(
          children: [
            ...this.actions.map((e) {
              final color = getColorFromFightRole(e.role);
              return Tooltip(
                  message: durationToString(e.duration),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 1),
                    height: cellHeight,
                    padding: EdgeInsets.all(padding),
                    child: FittedText(e.toString()),
                    color: color,
                  ));
            }),
          ],
        ),
      ),
    );
  }
}
