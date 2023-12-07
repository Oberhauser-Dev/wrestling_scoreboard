import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_common/common.dart';

String getFullNameFromBoutResult(BoutResult? result, BuildContext context) {
  return '${getAbbreviationFromBoutResult(result, context)} | ${getDescriptionFromBoutResult(result, context)}';
}

String getDescriptionFromBoutResult(BoutResult? result, BuildContext context) {
  AppLocalizations loc = AppLocalizations.of(context)!;
  switch (result) {
    case BoutResult.vfa:
      return loc.boutResultVfa;
    case BoutResult.vin:
      return loc.boutResultVin;
    case BoutResult.vca:
      return loc.boutResultVca;
    case BoutResult.vsu:
      return loc.boutResultVsu;
    case BoutResult.vsu1:
      return loc.boutResultVsu1;
    case BoutResult.vpo:
      return loc.boutResultVpo;
    case BoutResult.vpo1:
      return loc.boutResultVpo1;
    case BoutResult.vfo:
      return loc.boutResultVfo;
    case BoutResult.dsq:
      return loc.boutResultDsq;
    case BoutResult.dsq2:
      return loc.boutResultDsq2;
    default:
      return '';
  }
}

String getAbbreviationFromBoutResult(BoutResult? result, BuildContext context) {
  AppLocalizations loc = AppLocalizations.of(context)!;
  switch (result) {
    case BoutResult.vfa:
      return loc.boutResultVfaAbbr;
    case BoutResult.vin:
      return loc.boutResultVinAbbr;
    case BoutResult.vca:
      return loc.boutResultVcaAbbr;
    case BoutResult.vsu:
      return loc.boutResultVsuAbbr;
    case BoutResult.vsu1:
      return loc.boutResultVsu1Abbr;
    case BoutResult.vpo:
      return loc.boutResultVpoAbbr;
    case BoutResult.vpo1:
      return loc.boutResultVpo1Abbr;
    case BoutResult.vfo:
      return loc.boutResultVfoAbbr;
    case BoutResult.dsq:
      return loc.boutResultDsqAbbr;
    case BoutResult.dsq2:
      return loc.boutResultDsq2Abbr;
    default:
      return '';
  }
}
