import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';
import 'package:wrestling_scoreboard_client/localization/division_weight_class.dart';
import 'package:wrestling_scoreboard_client/localization/duration.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_match/division_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_match/division_weight_class_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_match/league_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/division_weight_class_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/league_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class DivisionOverview extends ConsumerWidget {
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
        final description = InfoWidget(
          obj: data,
          editPage: DivisionEdit(
            division: data,
          ),
          onDelete: () async => (await ref.read(dataManagerNotifierProvider)).deleteSingle<Division>(data),
          classLocale: localizations.division,
          children: [
            ContentItem(
              title: data.startDate.toDateString(context),
              subtitle: localizations.date, // Start date
              icon: Icons.event,
            ),
            ContentItem(
              title: '${data.boutConfig.periodDuration.formatMinutesAndSeconds()} ✕ ${data.boutConfig.periodCount}',
              subtitle: localizations.periodDuration,
              icon: Icons.timelapse,
            ),
            ContentItem(
              title: data.boutConfig.breakDuration.formatMinutesAndSeconds(),
              subtitle: localizations.breakDuration,
              icon: Icons.timelapse,
            ),
            ContentItem(
              title: data.boutConfig.activityDuration.formatMinutesAndSeconds(),
              subtitle: localizations.activityDuration,
              icon: Icons.timelapse,
            ),
            ContentItem(
              title: data.boutConfig.injuryDuration.formatMinutesAndSeconds(),
              subtitle: localizations.injuryDuration,
              icon: Icons.timelapse,
            ),
            ContentItem(
              title: data.seasonPartitions.toString(),
              subtitle: localizations.seasonPartitions,
              icon: Icons.sunny_snowing,
            ),
          ],
        );
        return OverviewScaffold<Division>(
          dataObject: data,
          label: localizations.division,
          details: data.name,
          body: GroupedList(items: [
            description,
            ManyConsumer<Division, Division>(
              filterObject: data,
              builder: (BuildContext context, List<Division> childDivisions) {
                return ListGroup(
                  header: HeadingItem(
                    title: localizations.divisions,
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
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
            ManyConsumer<League, Division>(
              filterObject: data,
              builder: (BuildContext context, List<League> leagues) {
                return ListGroup(
                  header: HeadingItem(
                    title: localizations.leagues,
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
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
            ManyConsumer<DivisionWeightClass, Division>(
              filterObject: data,
              builder: (BuildContext context, List<DivisionWeightClass> divisionWeightClasses) {
                return ListGroup(
                  header: HeadingItem(
                    title: localizations.weightClasses,
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
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
          ]),
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
