import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/season.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_match/league_weight_class_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/weight_class_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class LeagueWeightClassOverview extends ConsumerWidget with WeightClassOverview<LeagueWeightClass> {
  static const route = 'league_weight_class';

  final int id;
  final LeagueWeightClass? leagueWeightClass;

  const LeagueWeightClassOverview({super.key, required this.id, this.leagueWeightClass});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = context.l10n;
    return SingleConsumer<LeagueWeightClass>(
      id: id,
      initialData: leagueWeightClass,
      builder: (context, data) {
        return buildOverview(
          context,
          ref,
          classLocale: localizations.weightClass,
          editPage: LeagueWeightClassEdit(leagueWeightClass: data, initialLeague: data.league),
          onDelete: () async => (await ref.read(dataManagerNotifierProvider)).deleteSingle<LeagueWeightClass>(data),
          tiles: [
            ContentItem(
              title: data.seasonPartition?.asSeasonPartition(context, data.league.division.seasonPartitions) ?? '-',
              subtitle: localizations.seasonPartition,
              icon: Icons.sunny_snowing,
            ),
          ],
          dataId: data.weightClass.id!,
          initialData: data.weightClass,
          subClassData: data,
        );
      },
    );
  }
}
