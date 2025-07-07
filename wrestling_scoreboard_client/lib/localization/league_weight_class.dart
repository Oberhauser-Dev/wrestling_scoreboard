import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/season.dart';
import 'package:wrestling_scoreboard_client/localization/weight_class.dart';
import 'package:wrestling_scoreboard_common/common.dart';

extension LeagueWeightClassLocalization on LeagueWeightClass {
  localize(BuildContext context) {
    return '$pos. ${weightClass.localize(context)} ${seasonPartition == null ? '' : '(${seasonPartition!.asSeasonPartition(context, league.division.seasonPartitions)})'}';
  }
}
