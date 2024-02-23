import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_match/league_weight_class_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/weight_class_overview.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class LeagueWeightClassOverview extends WeightClassOverview {
  static const route = 'league_weight_class';

  final int id;
  final LeagueWeightClass? leagueWeightClass;

  const LeagueWeightClassOverview({super.key, required this.id, this.leagueWeightClass});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    return SingleConsumer<LeagueWeightClass>(
      id: id,
      initialData: leagueWeightClass,
      builder: (context, data) {
        return buildOverview(context, ref,
            classLocale: localizations.weightClass,
            editPage: LeagueWeightClassEdit(
              leagueWeightClass: data,
              initialLeague: data.league,
            ),
            onDelete: () async => (await ref.read(dataManagerNotifierProvider)).deleteSingle<LeagueWeightClass>(data),
            tiles: [],
            dataId: data.weightClass.id!,
            initialData: data.weightClass);
      },
    );
  }
}