import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/season.dart';
import 'package:wrestling_scoreboard_client/localization/weight_class.dart';
import 'package:wrestling_scoreboard_common/common.dart';

extension DivisionWeightClassLocalization on DivisionWeightClass {
  localize(BuildContext context) {
    return '${pos + 1}. ${weightClass.localize(context)} ${seasonPartition == null ? '' : '(${seasonPartition!.asSeasonPartition(context, division.seasonPartitions)})'}';
  }
}
