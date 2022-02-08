import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/ui/components/consumer.dart';
import 'package:wrestling_scoreboard/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard/ui/edit/membership_edit.dart';
import 'package:wrestling_scoreboard/ui/overview/person_overview.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';

class MembershipOverview extends PersonOverview {
  final Membership _filterObject;

  MembershipOverview({Key? key, required Membership filterObject})
      : _filterObject = filterObject,
        super(key: key, filterObject: filterObject.person);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return SingleConsumer<Membership>(
      id: _filterObject.id!,
      initialData: _filterObject,
      builder: (context, membership) => buildOverview(
        context,
        classLocale: localizations.membership,
        editPage: MembershipEdit(
          membership: membership,
          initialClub: membership!.club,
        ),
        onDelete: () => dataProvider.deleteSingle(membership),
        tiles: [
          ContentItem(
            title: membership.no ?? '-',
            subtitle: localizations.membershipNumber,
            icon: Icons.tag,
          )
        ],
      ),
    );
  }
}
