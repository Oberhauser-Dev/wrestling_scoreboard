import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/organization_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/organization_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class OrganizationsView extends StatelessWidget {
  const OrganizationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    return ResponsiveContainer(
      child: FilterableManyConsumer<Organization, Null>.edit(
        context: context,
        editPageBuilder: (context) => const OrganizationEdit(),
        hintText: localizations.organizations,
        itemBuilder:
            (context, item) => ContentItem(
              title: item.name,
              icon: Icons.corporate_fare,
              onTap: () => handleSelectedOrganization(item, context),
            ),
      ),
    );
  }

  handleSelectedOrganization(Organization organization, BuildContext context) {
    context.push('/${OrganizationOverview.route}/${organization.id}');
  }
}
