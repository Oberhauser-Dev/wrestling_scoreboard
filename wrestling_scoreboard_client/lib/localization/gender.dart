import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_common/common.dart';

extension GenderLocalization on Gender {
  localize(BuildContext context) {
    final localizations = context.l10n;
    if (this == Gender.male) return localizations.genderMale;
    if (this == Gender.female) return localizations.genderFemale;
    return localizations.genderTransgender;
  }
}
