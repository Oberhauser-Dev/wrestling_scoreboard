import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/event/match_display.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_match/team_match_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/team_match_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/auth.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class MatchList<T extends DataObject?> extends StatelessWidget {
  final T? filterObject;

  const MatchList({super.key, required this.filterObject});

  @override
  Widget build(BuildContext context) {
    return ManyConsumer<TeamMatch, T>(
      filterObject: filterObject,
      builder: (BuildContext context, List<TeamMatch> matches) {
        final today = DateTime.now().copyWith(hour: 0, minute: 0, millisecond: 0, microsecond: 0);
        final firstFutureMatchIndex = matches.indexWhere((match) => match.date.compareTo(today) >= 0);
        return SearchableGroupedList(
          trailing: RestrictedAddButton(
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      if (filterObject is Team) {
                        final team = filterObject as Team;
                        return TeamMatchEdit(
                          initialHomeTeam: team,
                          initialGuestTeam: team,
                          initialOrganization: team.organization!,
                        );
                      } else if (filterObject is League) {
                        final league = filterObject as League;
                        return TeamMatchEdit(initialLeague: league, initialOrganization: league.organization!);
                      } else {
                        return TeamMatchEdit();
                      }
                    },
                  ),
                ),
          ),
          initialItemIndex: firstFutureMatchIndex >= 0 ? firstFutureMatchIndex : (math.max(matches.length - 1, 0)),
          items: matches,
          itemBuilder:
              (context, match) => SingleConsumer<TeamMatch>(
                id: match.id!,
                initialData: match,
                builder: (context, match) {
                  return ListTile(
                    title: Text.rich(
                      style: match.date.compareTo(today) < 0 ? TextStyle(color: Theme.of(context).disabledColor) : null,
                      TextSpan(
                        text: '${match.date.toDateString(context)} | ',
                        children: [
                          TextSpan(
                            text: match.home.team.name,
                            style:
                                filterObject is! Team || match.home.team == filterObject
                                    ? TextStyle(
                                      color: Colors.red,
                                      fontWeight: filterObject is! Team ? null : FontWeight.bold,
                                    )
                                    : null,
                          ),
                          const TextSpan(text: ' - '),
                          TextSpan(
                            text: match.guest.team.name,
                            style:
                                filterObject is! Team || match.guest.team == filterObject
                                    ? TextStyle(
                                      color: Colors.blue,
                                      fontWeight: filterObject is! Team ? null : FontWeight.bold,
                                    )
                                    : null,
                          ),
                        ],
                      ),
                    ),
                    leading: const Icon(Icons.event),
                    onTap: () => TeamMatchOverview.navigateTo(context, match),
                    trailing: IconButton(
                      icon: const Icon(Icons.tv),
                      onPressed: () => MatchDisplay.navigateTo(context, match),
                    ),
                  );
                },
              ),
        );
      },
    );
  }
}
