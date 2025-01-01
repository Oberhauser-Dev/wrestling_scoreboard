import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/bout_utils.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';
import 'package:wrestling_scoreboard_client/localization/wrestling_style.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_match/team_match_bout_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/team_match_bout_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/team_match_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/auth.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class BoutList<T extends DataObject?> extends StatelessWidget {
  final T? filterObject;

  const BoutList({super.key, required this.filterObject});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return FilterableManyConsumer<TeamMatchBout, T>(
      filterObject: filterObject,
      // Adding a bout should not be an option for memberships
      trailing: filterObject is TeamMatch
          ? RestrictedAddButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TeamMatchBoutEdit(
                    initialTeamMatch: filterObject as TeamMatch,
                  ),
                ),
              ),
            )
          : null,
      itemBuilder: (context, teamMatchBout) {
        final bout = teamMatchBout.bout;
        final weightClass = bout.weightClass;
        final weightClassStr =
            weightClass == null ? '' : '${weightClass.name}, ${weightClass.style.abbreviation(context)} | ';
        return ListTile(
          title: Text.rich(
            TextSpan(
              text: '${teamMatchBout.teamMatch.date.toDateString(context)}, $weightClassStr',
              children: [
                TextSpan(
                    text: bout.r?.fullName(context) ?? localizations.participantVacant,
                    style: filterObject is! Membership || bout.r?.participation.membership == filterObject
                        ? TextStyle(
                            color: bout.r == null ? Theme.of(context).disabledColor : Colors.red,
                            fontWeight: filterObject is! Membership ? null : FontWeight.bold)
                        : null),
                const TextSpan(text: ' - '),
                TextSpan(
                    text: bout.b?.fullName(context) ?? localizations.participantVacant,
                    style: filterObject is! Membership || bout.b?.participation.membership == filterObject
                        ? TextStyle(
                            color: bout.b == null ? Theme.of(context).disabledColor : Colors.blue,
                            fontWeight: filterObject is! Membership ? null : FontWeight.bold)
                        : null),
              ],
            ),
          ),
          leading: const Icon(Icons.sports_kabaddi),
          onTap: () => handleSelectedTeamMatchBout(teamMatchBout, context),
        );
      },
    );
  }

  handleSelectedTeamMatchBout(TeamMatchBout bout, BuildContext context) {
    context.push('/${TeamMatchOverview.route}/${bout.teamMatch.id}/${TeamMatchBoutOverview.route}/${bout.id}');
  }
}
