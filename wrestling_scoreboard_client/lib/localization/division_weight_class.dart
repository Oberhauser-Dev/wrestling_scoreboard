import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/season.dart';
import 'package:wrestling_scoreboard_client/localization/wrestling_style.dart';
import 'package:wrestling_scoreboard_common/common.dart';

extension DivisionWeightClassLocalization on DivisionWeightClass {
  localize(BuildContext context) {
    return '$pos. ${weightClass.name} ${weightClass.style.localize(context)} ${seasonPartition == null ? '' : '(${seasonPartition!.asSeasonPartition(context, division.seasonPartitions)})'}';
  }
}
