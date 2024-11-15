import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
import 'package:wrestling_scoreboard_client/view/widgets/auth.dart';
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
    final localizations = AppLocalizations.of(context)!;
    return SingleConsumer<Division>(
      id: id,
      initialData: division,
      builder: (context, data) {
        return buildOverview(
          context,
          ref,
          classLocale: localizations.division,
          details: '${data.name}, ${data.startDate.year}',
          editPage: DivisionEdit(
            division: data,
          ),
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
            ContentItem(
              title: data.parent?.fullname ?? '-',
              subtitle: localizations.division,
              icon: Icons.inventory,
            ),
          ],
          dataId: data.boutConfig.id!,
          initialData: data.boutConfig,
          subClassData: data,
          buildRelations: (boutConfig) => {
            Tab(child: HeadingText(localizations.leagues)): ManyConsumer<League, Division>(
              filterObject: data,
              builder: (BuildContext context, List<League> leagues) {
                return GroupedList(
                  header: HeadingItem(
                    trailing: RestrictedAddButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LeagueEdit(
                            initialDivision: data,
                          ),
                        ),
                      ),
                    ),
                  ),
                  items: leagues.map(
                    (e) => SingleConsumer<League>(
                        id: e.id,
                        initialData: e,
                        builder: (context, data) {
                          return ContentItem(
                            title: '${data.fullname}, ${data.startDate.year}',
                            icon: Icons.emoji_events,
                            onTap: () => handleSelectedLeague(data, context),
                          );
                        }),
                  ),
                );
              },
            ),
            Tab(child: HeadingText(localizations.weightClasses)): ManyConsumer<DivisionWeightClass, Division>(
              filterObject: data,
              builder: (BuildContext context, List<DivisionWeightClass> divisionWeightClasses) {
                return GroupedList(
                  header: HeadingItem(
                    trailing: RestrictedAddButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DivisionWeightClassEdit(initialDivision: data),
                        ),
                      ),
                    ),
                  ),
                  items: divisionWeightClasses.map((e) {
                    return SingleConsumer<DivisionWeightClass>(
                      id: e.id,
                      initialData: e,
                      builder: (context, data) {
                        return ContentItem(
                            title: data.localize(context),
                            icon: Icons.fitness_center,
                            onTap: () => handleSelectedWeightClass(data, context));
                      },
                    );
                  }),
                );
              },
            ),
            Tab(child: HeadingText('${localizations.sub}-${localizations.divisions}')):
                ManyConsumer<Division, Division>(
              filterObject: data,
              builder: (BuildContext context, List<Division> childDivisions) {
                return GroupedList(
                  header: HeadingItem(
                    trailing: RestrictedAddButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DivisionEdit(
                            initialParent: data,
                          ),
                        ),
                      ),
                    ),
                  ),
                  items: childDivisions.map(
                    (e) => SingleConsumer<Division>(
                        id: e.id,
                        initialData: e,
                        builder: (context, data) {
                          return ContentItem(
                            title: data.fullname,
                            icon: Icons.inventory,
                            onTap: () => handleSelectedChildDivision(data, context),
                          );
                        }),
                  ),
                );
              },
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
