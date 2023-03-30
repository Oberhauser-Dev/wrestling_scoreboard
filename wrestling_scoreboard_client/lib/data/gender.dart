import 'package:common/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

genderToString(Gender? gender, BuildContext context) {
  final localizations = AppLocalizations.of(context)!;
  if (gender == Gender.male) return localizations.genderMale;
  if (gender == Gender.female) return localizations.genderFemale;
  return localizations.genderTransgender;
}
