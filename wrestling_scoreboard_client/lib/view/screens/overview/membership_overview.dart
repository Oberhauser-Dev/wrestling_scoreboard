import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/membership_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/person_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/shared/team_match_bout_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class MembershipOverview extends ConsumerWidget with AbstractPersonOverview<Membership> {
  static const route = 'membership';

  static void navigateTo(BuildContext context, Membership membership) {
    context.push('/$route/${membership.id}');
  }

  final int id;
  final Membership? membership;

  const MembershipOverview({super.key, required this.id, this.membership});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = context.l10n;
    return SingleConsumer<Membership>(
      id: id,
      initialData: membership,
      builder: (context, membership) {
        return buildOverview(
          context,
          ref,
          dataId: membership.person.id!,
          initialData: membership.person,
          subClassData: membership,
          classLocale: localizations.membership,
          editPage: MembershipPersonEdit(membership: membership),
          onDelete: () async => (await ref.read(dataManagerNotifierProvider)).deleteSingle<Membership>(membership),
          tiles: [
            ContentItem(title: membership.no ?? '-', subtitle: localizations.membershipNumber, icon: Icons.tag),
            ContentItem(title: membership.club.name, subtitle: localizations.club, icon: Icons.foundation),
          ],
          buildRelations:
              (Person person) => {
                Tab(child: HeadingText('${localizations.bouts} (${localizations.league})')): TeamMatchBoutList(
                  filterObject: membership,
                ),
                // TODO: Add competition bouts
              },
        );
      },
    );
  }
}
