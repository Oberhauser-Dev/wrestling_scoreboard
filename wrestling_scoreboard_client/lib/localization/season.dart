import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';

extension SeasonLocalization on int {
  String asSeasonPartition(BuildContext context, int? seasonPartitions) {
    final localizations = context.l10n;
    if (seasonPartitions == 2) {
      if (this == 0) {
        return localizations.seasonFirstHalf;
      } else {
        return localizations.seasonSecondHalf;
      }
    }
    return (this + 1).toString();
  }
}
