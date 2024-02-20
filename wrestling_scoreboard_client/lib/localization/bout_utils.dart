import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_client/localization/wrestling_style.dart';
import 'package:wrestling_scoreboard_common/common.dart';

extension BoutRoleLocalization on BoutRole {
  MaterialColor color() {
    return this == BoutRole.red ? Colors.red : Colors.blue;
  }
}

extension BoutLocalization on Bout {
  String title(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final weightClass = this.weightClass;
    return '${weightClass == null ? '' : '${weightClass.name}, ${weightClass.style.abbreviation(context)} | '}'
        '${r?.fullName(context) ?? localizations.participantVacant} vs. ${b?.fullName(context) ?? localizations.participantVacant}';
  }
}

extension ParticipantStateLocalization on ParticipantState {
  String fullName(BuildContext context) {
    return participation.membership.person.fullName;
  }
}
