import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_client/ui/components/consumer.dart';
import 'package:wrestling_scoreboard_client/ui/components/exception.dart';
import 'package:wrestling_scoreboard_client/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard_client/ui/edit/membership_edit.dart';
import 'package:wrestling_scoreboard_client/ui/overview/person_overview.dart';
import 'package:wrestling_scoreboard_client/util/network/data_provider.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class MembershipOverview extends PersonOverview {
  static const route = 'membership';

  final int id;
  final Membership? membership;

  const MembershipOverview({Key? key, required this.id, this.membership}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return SingleConsumer<Membership>(
      id: id,
      initialData: membership,
      builder: (context, membership) {
        if (membership == null) return ExceptionWidget(localizations.notFoundException);
        return buildOverview(
          context,
          dataId: membership.person.id!,
          initialData: membership.person,
          classLocale: localizations.membership,
          editPage: MembershipEdit(
            membership: membership,
            initialClub: membership.club,
          ),
          onDelete: () => dataProvider.deleteSingle(membership),
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
