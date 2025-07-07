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
            await (await ref.read(dataManagerNotifierProvider)).deleteSingle<Division>(division);
            if (context.mounted) await super.onDelete(context, ref, single: division.boutConfig);
          },
          classLocale: localizations.division,
          children: [
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
            ),
            ContentItem(
              title: division.parent?.fullname ?? '-',
              subtitle: localizations.division,
              icon: Icons.inventory,
            ),
          ],
        );
        return FavoriteScaffold<Division>(
          dataObject: division,
          label: localizations.division,
          details: '${division.name}, ${division.startDate.year}',
          tabs: [
            Tab(child: HeadingText(localizations.info)),
            boutConfigTab,
            Tab(child: HeadingText(localizations.leagues)),
            Tab(child: HeadingText(localizations.weightClasses)),
            Tab(child: HeadingText('${localizations.sub}-${localizations.divisions}')),
          ],
          body: TabGroup(
            items: [
              description,
              boutConfigTabContent,
              FilterableManyConsumer<League, Division>.edit(
                context: context,
                editPageBuilder: (context) => LeagueEdit(initialDivision: division),
                filterObject: division,
                itemBuilder:
                    (context, item) => ContentItem(
                      title: '${item.fullname}, ${item.startDate.year}',
                      icon: Icons.emoji_events,
                      onTap: () => handleSelectedLeague(item, context),
                    ),
              ),
              FilterableManyConsumer<DivisionWeightClass, Division>.edit(
                context: context,
                editPageBuilder: (context) => DivisionWeightClassEdit(initialDivision: division),
                filterObject: division,
                itemBuilder:
                    (context, item) => ContentItem(
                      title: item.localize(context),
                      icon: Icons.fitness_center,
                      onTap: () => handleSelectedWeightClass(item, context),
                    ),
              ),
              FilterableManyConsumer<Division, Division>.edit(
                context: context,
                editPageBuilder: (context) => DivisionEdit(initialParent: division),
                filterObject: division,
                itemBuilder:
                    (context, item) => ContentItem(
                      title: division.fullname,
                      icon: Icons.inventory,
                      onTap: () => handleSelectedChildDivision(division, context),
                    ),
              ),
            ],
          ),
        );
      },
    );
  }

  handleSelectedChildDivision(Division division, BuildContext context) {
    context.push('/${DivisionOverview.route}/${division.id}');
  }

  handleSelectedLeague(League league, BuildContext context) {
    context.push('/${LeagueOverview.route}/${league.id}');
  }

  handleSelectedWeightClass(DivisionWeightClass divisionWeightClass, BuildContext context) {
    context.push('/${DivisionWeightClassOverview.route}/${divisionWeightClass.id}');
  }
}
