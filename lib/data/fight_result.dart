enum FightResult {
  VFA, // VICTORY BY FALL,              SCHULTERSIEG (SS)
  VIN, // VICTORY BY INJURY,            AUFGABESIEG WEGEN VERLETZUNG (AS)
  VCA, // 3 CAUTIONS "O" DUE TO ERROR AGAINST THE RULES,              SIEGER DURCH 3 VERWARNUNGEN / REGELWIDRIGKEIT (DV)
  VSU, // TECHNICAL SUPERIORITY - LOSER WITHOUT TECHNICAL POINTS,     TECHNISCHE ÜBERLEGENHEIT - VERLIERER OHNE TECHNISCHE PUNKTE (TÜ)
  VSU1, // TECHNICAL SUPERIORITY - LOSER WITH TECHNICAL POINTS,       TECHNISCHER ÜBERLEGENHEIT - VERLIERER HAT TECHNISCHE PUNKTE (TÜ)
  VPO, // VICTORY BY POINTS - THE LOSER WITHOUT ANY TECHNICAL POINTS, PUNKTSIEG - VERLIERER OHNE TECHNISCHE PUNKTE (PS)
  VPO1, // VICTORY BY POINTS - THE LOSER WITH TECHNICAL POINTS,       PUNKTSIEG - VERLIERER HAT TECHNISCHE PUNKTE (PS)
  VFO, // VICTORY BY FORFEIT - NO SHOW UP ON THE MAT,                 AUSSCHLUSS VOM WETTKAMPF WG. NICHTANTRITT (DN)
  DSQ, // DISQUALIFICAT. FROM THE WHOLE COMPET. DUE TO INFR. OF THE RULES, AUSSCHLUSS VOM WETTKAMPF WG. UNSPORTLICHK./TÄTLICHKEIT (DQ)
  DSQ2, // IN CASE BOTH WRESTLERS HAVE BEEN DISQ. DUE TO INFR. OF THE RULES, BEIDE RINGER DISQ. (UNSPORTLICHKEIT/ REGELWIDRIGKEIT (DQ2)
}
