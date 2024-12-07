import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_common/common.dart';

extension BoutResultLocalization on BoutResult {
  String fullName(BuildContext context) {
    return '${abbreviation(context)} | ${description(context)}';
  }

  String abbreviation(BuildContext context) {
    AppLocalizations loc = AppLocalizations.of(context)!;
    switch (this) {
      case BoutResult.vfa:
        return loc.boutResultVfaAbbr;
      case BoutResult.vin:
        return loc.boutResultVinAbbr;
      case BoutResult.vca:
        return loc.boutResultVcaAbbr;
      case BoutResult.vsu:
        return loc.boutResultVsuAbbr;
      case BoutResult.vpo:
        return loc.boutResultVpoAbbr;
      case BoutResult.vfo:
        return loc.boutResultVfoAbbr;
      case BoutResult.dsq:
        return loc.boutResultDsqAbbr;
      case BoutResult.bothDsq:
        return loc.boutResultBothDsqAbbr;
      case BoutResult.bothVfo:
        return loc.boutResultBothVfoAbbr;
      case BoutResult.bothVin:
        return loc.boutResultBothVinAbbr;
    }
  }

  String description(BuildContext context) {
    AppLocalizations loc = AppLocalizations.of(context)!;
    switch (this) {
      case BoutResult.vfa:
        return loc.boutResultVfa;
      case BoutResult.vin:
        return loc.boutResultVin;
      case BoutResult.vca:
        return loc.boutResultVca;
      case BoutResult.vsu:
        return loc.boutResultVsu;
      case BoutResult.vpo:
        return loc.boutResultVpo;
      case BoutResult.vfo:
        return loc.boutResultVfo;
      case BoutResult.dsq:
        return loc.boutResultDsq;
      case BoutResult.bothDsq:
        return loc.boutResultBothDsq;
      case BoutResult.bothVfo:
        return loc.boutResultBothVfo;
      case BoutResult.bothVin:
        return loc.boutResultBothVin;
    }
  }
}
