import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_client/ui/components/consumer.dart';
import 'package:wrestling_scoreboard_client/ui/edit/league_weight_class_edit.dart';
import 'package:wrestling_scoreboard_client/ui/overview/weight_class_overview.dart';
import 'package:wrestling_scoreboard_client/util/network/data_provider.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class LeagueWeightClassOverview extends WeightClassOverview {
  static const route = 'league_weight_class';

  final int id;
  final LeagueWeightClass? leagueWeightClass;

  const LeagueWeightClassOverview({super.key, required this.id, this.leagueWeightClass});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return SingleConsumer<LeagueWeightClass>(
      id: id,
      initialData: leagueWeightClass,
      builder: (context, data) {
        return buildOverview(context,
            classLocale: localizations.weightClass,
            editPage: LeagueWeightClassEdit(
              leagueWeightClass: data,
              initialLeague: data.league,
            ),
            onDelete: () => dataProvider.deleteSingle<LeagueWeightClass>(data),
            tiles: [],
            dataId: data.weightClass.id!,
            initialData: data.weightClass);
      },
    );
  }
}
