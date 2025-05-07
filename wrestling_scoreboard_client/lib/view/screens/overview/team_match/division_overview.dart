import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';
import 'package:wrestling_scoreboard_client/localization/division_weight_class.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_match/division_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_match/division_weight_class_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_match/league_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/bout_config_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/division_weight_class_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/league_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class DivisionOverview extends BoutConfigOverview<Division> {
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
      builder: (context, data) {
        return buildOverview(
          context,
          ref,
          classLocale: localizations.division,
          details: '${data.name}, ${data.startDate.year}',
          editPage: DivisionEdit(division: data),
          onDelete: () async => (await ref.read(dataManagerNotifierProvider)).deleteSingle<Division>(data),
          tiles: [
            ContentItem(
              title: data.startDate.toDateString(context),
              subtitle: localizations.startDate, // Start date
              icon: Icons.event,
            ),
            ContentItem(
              title: data.endDate.toDateString(context),
              subtitle: localizations.endDate, // End date
              icon: Icons.event,
            ),
            ContentItem(
              title: data.seasonPartitions.toString(),
              subtitle: localizations.seasonPartitions,
              icon: Icons.sunny_snowing,
            ),
            ContentItem(
              title: data.organization.fullname,
              subtitle: localizations.organization,
              icon: Icons.corporate_fare,
            ),
            ContentItem(title: data.parent?.fullname ?? '-', subtitle: localizations.division, icon: Icons.inventory),
          ],
          dataId: data.boutConfig.id!,
          initialData: data.boutConfig,
          subClassData: data,
          buildRelations:
              (boutConfig) => {
                Tab(child: HeadingText(localizations.leagues)): FilterableManyConsumer<League, Division>.edit(
                  context: context,
                  editPageBuilder: (context) => LeagueEdit(initialDivision: data),
                  filterObject: data,
                  itemBuilder:
                      (context, item) => ContentItem(
                        title: '${item.fullname}, ${item.startDate.year}',
                        icon: Icons.emoji_events,
                        onTap: () => handleSelectedLeague(item, context),
                      ),
                ),
                Tab(
                  child: HeadingText(localizations.weightClasses),
                ): FilterableManyConsumer<DivisionWeightClass, Division>.edit(
                  context: context,
                  editPageBuilder: (context) => DivisionWeightClassEdit(initialDivision: data),
                  filterObject: data,
                  itemBuilder:
                      (context, item) => ContentItem(
                        title: item.localize(context),
                        icon: Icons.fitness_center,
                        onTap: () => handleSelectedWeightClass(item, context),
                      ),
                ),
                Tab(
                  child: HeadingText('${localizations.sub}-${localizations.divisions}'),
                ): FilterableManyConsumer<Division, Division>.edit(
                  context: context,
                  editPageBuilder: (context) => DivisionEdit(initialParent: data),
                  filterObject: data,
                  itemBuilder:
                      (context, item) => ContentItem(
                        title: data.fullname,
                        icon: Icons.inventory,
                        onTap: () => handleSelectedChildDivision(data, context),
                      ),
                ),
              },
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
