import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_common/common.dart';

extension PersonRoleLocalization on PersonRole {
  String localize(BuildContext context) {
    final localizations = context.l10n;
    return switch (this) {
      PersonRole.judge => localizations.judge,
      PersonRole.matChairman => localizations.matChairman,
      PersonRole.referee => localizations.referee,
      PersonRole.steward => localizations.steward,
      PersonRole.timeKeeper => localizations.timeKeeper,
      PersonRole.transcriptWriter => localizations.transcriptionWriter,
    };
  }
}
