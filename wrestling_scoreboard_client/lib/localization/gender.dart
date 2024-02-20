import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_common/common.dart';

extension GenderLocalization on Gender {
  localize(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    if (this == Gender.male) return localizations.genderMale;
    if (this == Gender.female) return localizations.genderFemale;
    return localizations.genderTransgender;
  }
}
