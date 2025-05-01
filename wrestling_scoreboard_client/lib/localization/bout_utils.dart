import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/wrestling_style.dart';
import 'package:wrestling_scoreboard_common/common.dart';

extension BoutRoleLocalization on BoutRole {
  MaterialColor color() {
    return this == BoutRole.red ? Colors.red : Colors.blue;
  }

  String localize(BuildContext context) {
    final localizations = context.l10n;
    return this == BoutRole.red ? localizations.red : localizations.blue;
  }
}

extension BoutLocalization on Bout {
  String title(BuildContext context) {
    final localizations = context.l10n;
    return '${r?.fullName(context) ?? localizations.participantVacant} vs. ${b?.fullName(context) ?? localizations.participantVacant}';
  }
}

extension TeamMatchBoutLocalization on TeamMatchBout {
  String title(BuildContext context) {
    final weightClass = this.weightClass;
    return '${weightClass == null ? '' : '${weightClass.name}, ${weightClass.style.abbreviation(context)} | '}'
        '${bout.title(context)}';
  }
}

extension AtheleteBoutStateLocalization on AthleteBoutState {
  String fullName(BuildContext context) {
    return membership.person.fullName;
  }
}
