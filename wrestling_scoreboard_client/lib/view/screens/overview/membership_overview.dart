import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/bout_utils.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';
import 'package:wrestling_scoreboard_client/localization/wrestling_style.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/membership_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/person_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/team_match_bout_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/team_match_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class MembershipOverview extends AbstractPersonOverview<Membership> {
  static const route = 'membership';

  final int id;
  final Membership? membership;

  const MembershipOverview({super.key, required this.id, this.membership});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    return SingleConsumer<Membership>(
      id: id,
      initialData: membership,
      builder: (context, membership) {
        return buildOverview(context, ref,
            dataId: membership.person.id!,
            initialData: membership.person,
            subClassData: membership,
            classLocale: localizations.membership,
            editPage: MembershipEdit(
              membership: membership,
              initialClub: membership.club,
            ),
            onDelete: () async => (await ref.read(dataManagerNotifierProvider)).deleteSingle<Membership>(membership),
            tiles: [
              ContentItem(
                title: membership.no ?? '-',
                subtitle: localizations.membershipNumber,
                icon: Icons.tag,
              ),
              ContentItem(
                title: membership.club.name,
                subtitle: localizations.club,
                icon: Icons.foundation,
              )
            ],
            buildRelations: (Person person) => {
                  Tab(child: HeadingText('${localizations.bouts} (${localizations.league})')):
                      ManyConsumer<TeamMatchBout, Membership>(
                    filterObject: membership,
                    builder: (BuildContext context, List<TeamMatchBout> teamMatchBouts) {
                      return GroupedList(
                        header: const HeadingItem(
                            // Adding a bout should not be an option here
                            ),
                        items: teamMatchBouts.map(
                          (e) => SingleConsumer<TeamMatchBout>(
                              id: e.id,
                              initialData: e,
                              builder: (context, teamMatchBout) {
                                final bout = teamMatchBout.bout;
                                final weightClass = bout.weightClass;
                                final weightClassStr = weightClass == null
                                    ? ''
                                    : '${weightClass.name}, ${weightClass.style.abbreviation(context)} | ';
                                return ListTile(
                                  title: Text.rich(
                                    TextSpan(
                                      text: '${teamMatchBout.teamMatch.date.toDateString(context)}, $weightClassStr',
                                      children: [
                                        TextSpan(
                                            text: bout.r?.fullName(context) ?? localizations.participantVacant,
                                            style: bout.r?.participation.membership == membership
                                                ? const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)
                                                : null),
                                        const TextSpan(text: ' - '),
                                        TextSpan(
                                            text: bout.b?.fullName(context) ?? localizations.participantVacant,
                                            style: bout.b?.participation.membership == membership
                                                ? const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)
                                                : null),
                                      ],
                                    ),
                                  ),
                                  leading: const Icon(Icons.sports_kabaddi),
                                  onTap: () => handleSelectedTeamMatchBout(teamMatchBout, context),
                                );
                              }),
                        ),
                      );
                    },
                  ),
                  // TODO: Add competition bouts
                });
      },
    );
  }

  handleSelectedTeamMatchBout(TeamMatchBout bout, BuildContext context) {
    context.push('/${TeamMatchOverview.route}/${bout.teamMatch.id}/${TeamMatchBoutOverview.route}/${bout.id}');
  }
}
