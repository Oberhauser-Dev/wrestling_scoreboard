import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/theme/role_colors.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_common/common.dart';

extension MatchResultRoleLocalization on MatchResultRole {
  MaterialColor color(BuildContext context) {
    return switch (this) {
      MatchResultRole.home => context.roleColors.red,
      MatchResultRole.guest => context.roleColors.blue,
      MatchResultRole.tie => Colors.grey,
    };
  }

  String localize(BuildContext context) {
    final localizations = context.l10n;
    return switch (this) {
      MatchResultRole.home => localizations.home,
      MatchResultRole.guest => localizations.guest,
      MatchResultRole.tie => localizations.tie,
    };
  }
}
