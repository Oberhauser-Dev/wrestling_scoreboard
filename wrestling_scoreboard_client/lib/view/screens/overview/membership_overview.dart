import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/membership_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/person_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class MembershipOverview extends PersonOverview {
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
        return buildOverview(
          context,
          ref,
          dataId: membership.person.id!,
          initialData: membership.person,
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
            )
          ],
        );
      },
    );
  }
}
