import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaled_text.dart';
import 'package:wrestling_scoreboard_client/view/widgets/themed.dart';
import 'package:wrestling_scoreboard_client/view/shortcuts/app_shortcuts.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class CommonElements {
  static List<Widget> getTeamHeader(Team home, Team guest, List<Bout> bouts, BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = width / 100;
    final edgeInsets = EdgeInsets.all(padding);
    return [
      ThemedContainer(
          color: Colors.red.shade800,
          padding: edgeInsets,
          child: Center(
            child: ScaledText(
              home.name,
              fontSize: 28,
              minFontSize: 16,
            ),
          )),
      Row(
        children: [
          Expanded(
            child: ThemedContainer(
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
            child: ThemedContainer(
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
      ThemedContainer(
        color: Colors.blue.shade800,
        padding: edgeInsets,
        child: Center(
          child: ScaledText(
            guest.name,
            fontSize: 28,
            minFontSize: 16,
          ),
        ),
      ),
    ];
  }

  static Widget getFullScreenAction(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.fullscreen),
      onPressed: () => const AppActionIntent(type: AppAction.toggleFullScreen).handle(context, ref),
    );
  }
}
