import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
        return GroupedList(
          header: HeadingItem(
            trailing: RestrictedAddButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => TeamMatchEdit(
                            initialHomeTeam: filterObject is Team ? filterObject as Team : null,
                            initialGuestTeam: filterObject is Team ? filterObject as Team : null,
                            initialLeague: filterObject is League ? filterObject as League : null,
                          ),
                    ),
                  ),
            ),
          ),
          initialItemIndex: firstFutureMatchIndex >= 0 ? firstFutureMatchIndex : (math.max(matches.length - 1, 0)),
          itemCount: matches.length,
          itemBuilder:
              (context, index) => SingleConsumer<TeamMatch>(
                id: matches[index].id!,
                initialData: matches[index],
                builder: (context, match) {
                  return ListTile(
                    title: Text.rich(
                      style: match.date.compareTo(today) < 0 ? TextStyle(color: Theme.of(context).disabledColor) : null,
                      TextSpan(
                        text: '${match.date.toDateString(context)}, ${match.no ?? 'no ID'}, ',
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
                    onTap: () => handleSelectedMatch(match, context),
                    trailing: IconButton(
                      icon: const Icon(Icons.tv),
                      onPressed: () => handleSelectedMatchSequence(match, context),
                    ),
                  );
                },
              ),
        );
      },
    );
  }

  handleSelectedMatch(TeamMatch match, BuildContext context) async {
    context.push('/${TeamMatchOverview.route}/${match.id}');
  }

  handleSelectedMatchSequence(TeamMatch match, BuildContext context) {
    context.push('/${TeamMatchOverview.route}/${match.id}/${MatchDisplay.route}');
  }
}
