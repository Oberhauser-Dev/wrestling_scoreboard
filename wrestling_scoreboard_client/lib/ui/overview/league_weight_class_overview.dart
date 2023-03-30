import 'package:wrestling_scoreboard_common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_client/ui/components/consumer.dart';
import 'package:wrestling_scoreboard_client/ui/edit/league_weight_class_edit.dart';
import 'package:wrestling_scoreboard_client/ui/overview/weight_class_overview.dart';
import 'package:wrestling_scoreboard_client/util/network/data_provider.dart';

class LeagueWeightClassOverview extends WeightClassOverview {
  final LeagueWeightClass filterObject;

  LeagueWeightClassOverview({Key? key, required this.filterObject})
      : super(filterObject: filterObject.weightClass, key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return SingleConsumer<LeagueWeightClass>(
      id: filterObject.id!,
      initialData: filterObject,
      builder: (context, data) {
        return buildOverview(context,
            classLocale: localizations.weightClass,
            editPage: LeagueWeightClassEdit(
              leagueWeightClass: data,
              initialLeague: data!.league,
            ),
            onDelete: () => dataProvider.deleteSingle(data),
            tiles: []);
      },
    );
  }
}
