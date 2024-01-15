import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/data/bout_utils.dart';
import 'package:wrestling_scoreboard_client/ui/components/scaled_text.dart';
import 'package:wrestling_scoreboard_client/ui/components/themed.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class ActionsWidget extends StatelessWidget {
  final List<BoutAction> actions;

  ActionsWidget(this.actions, {super.key}) {
    actions.sort((a, b) => a.duration.compareTo(b.duration));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double padding = width / 100;

    return SingleChildScrollView(
      reverse: true,
      scrollDirection: Axis.horizontal,
      child: IntrinsicHeight(
        child: Row(
          children: [
            ...actions.map((e) {
              final color = getColorFromBoutRole(e.role);
              return Tooltip(
                  message: durationToString(e.duration),
                  child: ThemedContainer(
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    padding: EdgeInsets.all(padding),
                    color: color,
                    child: ScaledText(
                      e.toString(),
                      fontSize: 22,
                      softWrap: false,
                    ),
                  ));
            }),
          ],
        ),
      ),
    );
  }
}
