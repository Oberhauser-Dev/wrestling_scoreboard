import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/bout_utils.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';
import 'package:wrestling_scoreboard_client/localization/wrestling_style.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/competition/competition_bout_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_bout_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/auth.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class CompetitionBoutList<T extends DataObject?> extends StatelessWidget {
  final T? filterObject;

  const CompetitionBoutList({super.key, required this.filterObject});

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    return FilterableManyConsumer<CompetitionBout, T>(
      filterObject: filterObject,
      // Adding a bout should not be an option for memberships
      trailing:
          filterObject is Competition
              ? RestrictedAddButton(
                onPressed:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CompetitionBoutEdit(initialCompetition: filterObject as Competition),
                      ),
                    ),
              )
              : null,
      itemBuilder: (context, competitionBout) {
        final bout = competitionBout.bout;
        final weightCategory = competitionBout.weightCategory;
        final weightCategoryStr =
            '${weightCategory?.name}, ${weightCategory?.weightClass.style.abbreviation(context)} | ';
        return ListTile(
          title: Text.rich(
            TextSpan(
              text: '${competitionBout.competition.date.toDateString(context)}, $weightCategoryStr',
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
          onTap: () => handleSelectedCompetitionBout(competitionBout, context),
        );
      },
    );
  }

  handleSelectedCompetitionBout(CompetitionBout bout, BuildContext context) {
    context.push('/${CompetitionOverview.route}/${bout.competition.id}/${CompetitionBoutOverview.route}/${bout.id}');
  }
}
