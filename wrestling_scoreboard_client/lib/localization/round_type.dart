import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_common/common.dart';

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
