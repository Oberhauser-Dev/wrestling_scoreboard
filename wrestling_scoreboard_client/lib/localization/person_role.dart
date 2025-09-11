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
      PersonRole.timeKeeper => localizations.timeKeeper,
      PersonRole.transcriptWriter => localizations.transcriptionWriter,
      PersonRole.steward => localizations.steward,
    };
  }

  IconData get icon {
    return switch (this) {
      PersonRole.judge => Icons.manage_accounts,
      PersonRole.matChairman => Icons.manage_accounts,
      PersonRole.referee => Icons.sports,
      PersonRole.timeKeeper => Icons.pending_actions,
      PersonRole.transcriptWriter => Icons.history_edu,
      PersonRole.steward => Icons.security,
    };
  }
}
