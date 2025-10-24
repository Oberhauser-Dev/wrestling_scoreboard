import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';
import 'package:wrestling_scoreboard_client/localization/division_weight_class.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_match/division_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_match/division_weight_class_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_match/league_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/bout_config_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/organization_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/division_weight_class_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/league_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
import 'package:wrestling_scoreboard_client/view/widgets/tab_group.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class DivisionOverview extends ConsumerWidget with BoutConfigOverviewTab {
  static const route = 'division';

  static void navigateTo(BuildContext context, Division dataObject) {
    context.push('/$route/${dataObject.id}');
  }

  final int id;
  final Division? division;

  const DivisionOverview({super.key, required this.id, this.division});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = context.l10n;
    return SingleConsumer<Division>(
      id: id,
      initialData: division,
      builder: (context, division) {
        final (boutConfigTab, boutConfigTabContent) = buildTab(context, initialData: division.boutConfig);
        final description = InfoWidget(
          obj: division,
          editPage: DivisionEdit(division: division),
          onDelete: () async {
            await (await ref.read(dataManagerProvider)).deleteSingle<Division>(division);
            if (context.mounted) await super.onDelete(context, ref, single: division.boutConfig);
          },
          classLocale: localizations.division,
          children: [
            ContentItem(title: division.name, subtitle: localizations.name, icon: Icons.description),
            ContentItem(
              title: division.startDate.toDateString(context),
              subtitle: localizations.startDate, // Start date
              icon: Icons.event,
            ),
            ContentItem(
              title: division.endDate.toDateString(context),
              subtitle: localizations.endDate, // End date
              icon: Icons.event,
            ),
            ContentItem(
              title: division.seasonPartitions.toString(),
              subtitle: localizations.seasonPartitions,
              icon: Icons.sunny_snowing,
            ),
            ContentItem(
              title: division.organization.fullname,
              subtitle: localizations.organization,
              icon: Icons.corporate_fare,
              onTap: () => OrganizationOverview.navigateTo(context, division.organization),
            ),
            ContentItem(
              title: division.parent?.fullname ?? '-',
              subtitle: localizations.division,
              icon: Icons.inventory,
              onTap: division.parent == null ? null : () => DivisionOverview.navigateTo(context, division.parent!),
            ),
          ],
        );
        return FavoriteScaffold<Division>(
          dataObject: division,
          label: localizations.division,
          details: '${division.name}, ${division.startDate.year}',
          tabs: [
            Tab(child: HeadingText(localizations.info)),
            Tab(child: HeadingText(localizations.leagues)),
            Tab(child: HeadingText(localizations.weightClasses)),
            Tab(child: HeadingText('${localizations.sub}-${localizations.divisions}')),
            boutConfigTab,
          ],
          body: TabGroup(
            items: [
              description,
              FilterableManyConsumer<League, Division>.add(
                context: context,
                addPageBuilder: (context) => LeagueEdit(initialDivision: division),
                filterObject: division,
                itemBuilder:
                    (context, item) => ContentItem(
                      title: '${item.fullname}, ${item.startDate.year}',
                      icon: Icons.emoji_events,
                      onTap: () => LeagueOverview.navigateTo(context, item),
                    ),
              ),
              FilterableManyConsumer<DivisionWeightClass, Division>.add(
                context: context,
                addPageBuilder: (context) => DivisionWeightClassEdit(initialDivision: division),
                filterObject: division,
                itemBuilder:
                    (context, item) => ContentItem(
                      title: item.localize(context),
                      icon: Icons.fitness_center,
                      onTap: () => DivisionWeightClassOverview.navigateTo(context, item),
                    ),
              ),
              FilterableManyConsumer<Division, Division>.add(
                context: context,
                addPageBuilder: (context) => DivisionEdit(initialParent: division),
                filterObject: division,
                itemBuilder:
                    (context, item) => ContentItem(
                      title: division.fullname,
                      icon: Icons.inventory,
                      onTap: () => DivisionOverview.navigateTo(context, division),
                    ),
              ),
              boutConfigTabContent,
            ],
          ),
        );
      },
    );
  }
}
