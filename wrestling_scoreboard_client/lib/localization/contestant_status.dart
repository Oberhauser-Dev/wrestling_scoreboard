import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_common/common.dart';

extension ContestantStatusLocalization on ContestantStatus {
  localize(BuildContext context) {
    final localizations = context.l10n;
    return switch (this) {
      ContestantStatus.injured => localizations.injured,
      ContestantStatus.disqualified => localizations.disqualified,
      ContestantStatus.eliminated => localizations.eliminated,
    };
  }
}
