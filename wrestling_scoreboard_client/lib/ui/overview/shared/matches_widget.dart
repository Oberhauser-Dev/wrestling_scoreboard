import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/ui/components/consumer.dart';
import 'package:wrestling_scoreboard_client/ui/components/exception.dart';
import 'package:wrestling_scoreboard_client/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard_client/ui/edit/team_match_edit.dart';
import 'package:wrestling_scoreboard_client/ui/display/match/match_display.dart';
import 'package:wrestling_scoreboard_client/ui/overview/team_match_overview.dart';
import 'package:wrestling_scoreboard_client/util/date_time.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class MatchesWidget<T extends DataObject?> extends StatelessWidget {
  final T? filterObject;

  const MatchesWidget({super.key, required this.filterObject});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return ManyConsumer<TeamMatch, T>(
      filterObject: filterObject,
      builder: (BuildContext context, List<TeamMatch> matches) {
        return ListGroup(
          header: HeadingItem(
            title: localizations.matches,
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TeamMatchEdit(
                    initialHomeTeam: filterObject is Team ? filterObject as Team : null,
                    initialGuestTeam: filterObject is Team ? filterObject as Team : null,
                    initialLeague: filterObject is League ? filterObject as League : null,
                  ),
                ),
              ),
            ),
          ),
          items: matches.map(
            (e) => SingleConsumer<TeamMatch>(
              id: e.id!,
              initialData: e,
              builder: (context, match) {
                if (match == null) return ExceptionWidget(localizations.notFoundException);
                return ListTile(
                  title: Text.rich(
                    TextSpan(
                      text: '${match.date.toDateString(context)}, ${match.no ?? 'no ID'}, ',
                      children: [
                        TextSpan(
                            text: match.home.team.name,
                            style: match.home.team == filterObject
                                ? const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)
                                : null),
                        const TextSpan(text: ' - '),
                        TextSpan(
                            text: match.guest.team.name,
                            style: match.guest.team == filterObject
                                ? const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)
                                : null),
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
