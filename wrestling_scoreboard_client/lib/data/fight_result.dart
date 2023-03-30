import 'package:common/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String getFullNameFromFightResult(FightResult? result, BuildContext context) {
  return '${getAbbreviationFromFightResult(result, context)} | ${getDescriptionFromFightResult(result, context)}';
}

String getDescriptionFromFightResult(FightResult? result, BuildContext context) {
  AppLocalizations loc = AppLocalizations.of(context)!;
  switch (result) {
    case FightResult.VFA:
      return loc.fightResultVfa;
    case FightResult.VIN:
      return loc.fightResultVin;
    case FightResult.VCA:
      return loc.fightResultVca;
    case FightResult.VSU:
      return loc.fightResultVsu;
    case FightResult.VSU1:
      return loc.fightResultVsu1;
    case FightResult.VPO:
      return loc.fightResultVpo;
    case FightResult.VPO1:
      return loc.fightResultVpo1;
    case FightResult.VFO:
      return loc.fightResultVfo;
    case FightResult.DSQ:
      return loc.fightResultDsq;
    case FightResult.DSQ2:
      return loc.fightResultDsq2;
    default:
      return '';
  }
}

String getAbbreviationFromFightResult(FightResult? result, BuildContext context) {
  AppLocalizations loc = AppLocalizations.of(context)!;
  switch (result) {
    case FightResult.VFA:
      return loc.fightResultVfaAbbr;
    case FightResult.VIN:
      return loc.fightResultVinAbbr;
    case FightResult.VCA:
      return loc.fightResultVcaAbbr;
    case FightResult.VSU:
      return loc.fightResultVsuAbbr;
    case FightResult.VSU1:
      return loc.fightResultVsu1Abbr;
    case FightResult.VPO:
      return loc.fightResultVpoAbbr;
    case FightResult.VPO1:
      return loc.fightResultVpo1Abbr;
    case FightResult.VFO:
      return loc.fightResultVfoAbbr;
    case FightResult.DSQ:
      return loc.fightResultDsqAbbr;
    case FightResult.DSQ2:
      return loc.fightResultDsq2Abbr;
    default:
      return '';
  }
}
