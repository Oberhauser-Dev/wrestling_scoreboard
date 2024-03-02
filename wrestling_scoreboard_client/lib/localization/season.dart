import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension SeasonLocalization on int {
  String asSeasonPartition(BuildContext context, int? seasonPartitions) {
    final localizations = AppLocalizations.of(context)!;
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
