import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/bout_utils.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';
import 'package:wrestling_scoreboard_client/localization/weight_class.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_match/team_match_bout_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/team_match_bout_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/team_match_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/auth.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class TeamMatchBoutList<T extends DataObject?> extends StatelessWidget {
  final T? filterObject;

  const TeamMatchBoutList({super.key, required this.filterObject});

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    return FilterableManyConsumer<TeamMatchBout, T>(
      filterObject: filterObject,
      // Adding a bout should not be an option for memberships
      trailing:
          filterObject is TeamMatch
              ? RestrictedAddButton(
                onPressed:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TeamMatchBoutEdit(initialTeamMatch: filterObject as TeamMatch),
                      ),
                    ),
              )
              : null,
      itemBuilder: (context, teamMatchBout) {
        final bout = teamMatchBout.bout;
        final weightClass = teamMatchBout.weightClass;
        final weightClassStr = weightClass == null ? '' : '${weightClass.abbreviation(context)} | ';
        return ListTile(
          title: Text.rich(
            TextSpan(
              text: '${teamMatchBout.teamMatch.date.toDateString(context)}, $weightClassStr',
              children: [
                TextSpan(
                  text: bout.r?.fullName(context) ?? localizations.participantVacant,
                  style:
                      filterObject is! Membership || bout.r?.membership == filterObject
                          ? TextStyle(
                            color: bout.r == null ? Theme.of(context).disabledColor : Colors.red,
                            fontWeight: filterObject is! Membership ? null : FontWeight.bold,
                          )
                          : null,
                ),
                const TextSpan(text: ' - '),
                TextSpan(
                  text: bout.b?.fullName(context) ?? localizations.participantVacant,
                  style:
                      filterObject is! Membership || bout.b?.membership == filterObject
                          ? TextStyle(
                            color: bout.b == null ? Theme.of(context).disabledColor : Colors.blue,
                            fontWeight: filterObject is! Membership ? null : FontWeight.bold,
                          )
                          : null,
                ),
              ],
            ),
          ),
          leading: const Icon(Icons.sports_kabaddi),
          onTap: () => handleSelectedTeamMatchBout(teamMatchBout, context),
        );
      },
    );
  }

  void handleSelectedTeamMatchBout(TeamMatchBout bout, BuildContext context) {
    context.push('/${TeamMatchOverview.route}/${bout.teamMatch.id}/${TeamMatchBoutOverview.route}/${bout.id}');
  }
}
