import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_common/common.dart';

extension CompetitionBoutLocalization on CompetitionBout {
  roundDescription(BuildContext context) =>
      [roundType.localize(context), if (rank != null) displayRanks, '(R$displayRound)'].join(' ');
}

extension RoundTypeLocalization on RoundType {
  localize(BuildContext context) {
    final localizations = context.l10n;
    return switch (this) {
      RoundType.qualification => localizations.round,
      RoundType.elimination => localizations.elimination,
      RoundType.repechage => localizations.repechage,
      RoundType.semiFinals => localizations.semiFinals,
      RoundType.finals => localizations.finals,
    };
  }
}
