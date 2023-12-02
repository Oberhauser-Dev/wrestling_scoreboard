import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_common/common.dart';

String getFullNameFromFightResult(FightResult? result, BuildContext context) {
  return '${getAbbreviationFromFightResult(result, context)} | ${getDescriptionFromFightResult(result, context)}';
}

String getDescriptionFromFightResult(FightResult? result, BuildContext context) {
  AppLocalizations loc = AppLocalizations.of(context)!;
  switch (result) {
    case FightResult.vfa:
      return loc.fightResultVfa;
    case FightResult.vin:
      return loc.fightResultVin;
    case FightResult.vca:
      return loc.fightResultVca;
    case FightResult.vsu:
      return loc.fightResultVsu;
    case FightResult.vsu1:
      return loc.fightResultVsu1;
    case FightResult.vpo:
      return loc.fightResultVpo;
    case FightResult.vpo1:
      return loc.fightResultVpo1;
    case FightResult.vfo:
      return loc.fightResultVfo;
    case FightResult.dsq:
      return loc.fightResultDsq;
    case FightResult.dsq2:
      return loc.fightResultDsq2;
    default:
      return '';
  }
}

String getAbbreviationFromFightResult(FightResult? result, BuildContext context) {
  AppLocalizations loc = AppLocalizations.of(context)!;
  switch (result) {
    case FightResult.vfa:
      return loc.fightResultVfaAbbr;
    case FightResult.vin:
      return loc.fightResultVinAbbr;
    case FightResult.vca:
      return loc.fightResultVcaAbbr;
    case FightResult.vsu:
      return loc.fightResultVsuAbbr;
    case FightResult.vsu1:
      return loc.fightResultVsu1Abbr;
    case FightResult.vpo:
      return loc.fightResultVpoAbbr;
    case FightResult.vpo1:
      return loc.fightResultVpo1Abbr;
    case FightResult.vfo:
      return loc.fightResultVfoAbbr;
    case FightResult.dsq:
      return loc.fightResultDsqAbbr;
    case FightResult.dsq2:
      return loc.fightResultDsq2Abbr;
    default:
      return '';
  }
}
