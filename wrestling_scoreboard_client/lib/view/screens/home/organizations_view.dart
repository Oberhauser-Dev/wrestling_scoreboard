import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/organization_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/organization_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/auth.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class OrganizationsView extends StatelessWidget {
  const OrganizationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return ResponsiveContainer(
      child: ManyConsumer<Organization, Null>(
        builder: (BuildContext context, List<Organization> organizations) {
          return GroupedList(
            header: HeadingItem(
              title: localizations.organizations,
              trailing: RestrictedAddButton(
                onPressed: () =>
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const OrganizationEdit())),
              ),
            ),
            items: organizations.map(
              (e) => SingleConsumer<Organization>(
                id: e.id!,
                initialData: e,
                builder: (context, data) {
                  return ContentItem(
                    title: data.name,
                    icon: Icons.corporate_fare,
                    onTap: () => handleSelectedOrganization(data, context),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  handleSelectedOrganization(Organization organization, BuildContext context) {
    context.push('/${OrganizationOverview.route}/${organization.id}');
  }
}
