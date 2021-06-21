import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum FightResult {
  VFA, // VICTORY BY FALL,              SCHULTERSIEG (SS)
  VIN, // VICTORY BY INJURY,            AUFGABESIEG WEGEN VERLETZUNG (AS)
  VCA, // 3 CAUTIONS "O" DUE TO ERROR AGAINST THE RULES,              SIEGER DURCH 3 VERWARNUNGEN / REGELWIDRIGKEIT (DV)
  VSU, // TECHNICAL SUPERIORITY - LOSER WITHOUT TECHNICAL POINTS,     TECHNISCHE ÜBERLEGENHEIT - VERLIERER OHNE TECHNISCHE PUNKTE (TÜ)
  VSU1, // TECHNICAL SUPERIORITY - LOSER WITH TECHNICAL POINTS,       TECHNISCHE ÜBERLEGENHEIT - VERLIERER HAT TECHNISCHE PUNKTE (TÜ1)
  VPO, // VICTORY BY POINTS - THE LOSER WITHOUT ANY TECHNICAL POINTS, PUNKTSIEG - VERLIERER OHNE TECHNISCHE PUNKTE (PS)
  VPO1, // VICTORY BY POINTS - THE LOSER WITH TECHNICAL POINTS,       PUNKTSIEG - VERLIERER HAT TECHNISCHE PUNKTE (PS1)
  VFO, // VICTORY BY FORFEIT - NO SHOW UP ON THE MAT,                 AUSSCHLUSS VOM WETTKAMPF WG. NICHTANTRITT (DN)
  DSQ, // DISQUALIFICAT. FROM THE WHOLE COMPET. DUE TO INFR. OF THE RULES, AUSSCHLUSS VOM WETTKAMPF WG. UNSPORTLICHK./TÄTLICHKEIT (DQ)
  DSQ2, // IN CASE BOTH WRESTLERS HAVE BEEN DISQ. DUE TO INFR. OF THE RULES, BEIDE RINGER DISQ. (UNSPORTLICHKEIT/ REGELWIDRIGKEIT (DQ2)
}

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
