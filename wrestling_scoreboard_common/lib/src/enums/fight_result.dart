/// The result of a single fight.
enum FightResult {
  /// Victory by fall
  /// Schultersieg (SS)
  vfa,

  /// Victory by injury
  /// Aufgabesieg wegen Verletzung (AS)
  vin,

  /// Victory by cautions - the opponent received 3 cautions "O" due to error against the rules
  /// Sieger durch 3 Verwarnungen / Regelwidrigkeit des Gegners (DV)
  vca,

  /// Technical superiority - loser without technical points
  /// Technische Überlegenheit - Verlierer ohne Technische Punkte (TÜ)
  vsu,

  /// Technical superiority - loser with technical points
  /// Technische Überlegenheit - Verlierer hat Technische Punkte (TÜ1)
  vsu1,

  /// Victory by points - the loser without any technical points
  /// Punktsieg - Verlierer ohne Technische Punkte (PS)
  vpo,

  /// Victory by points - the loser with technical points
  /// Punktsieg - Verlierer hat Technische Punkte (PS1)
  vpo1,

  /// Victory by forfeit - no show up on the mat
  /// Sieger durch Ausschluss des Gegners vom Wettkampf wegen Nichtantritt (DN)
  vfo,

  /// Victory by disqualification of the opponent from the whole competition due to infringement of the rules
  /// Sieger durch Ausschluss des Gegners vom Wettkampf wegen Unsportlichkeit / Tätlichkeit (DQ)
  dsq,

  /// In case both wrestlers have been disqualified due to infringement of the rules
  /// Beide Ringer disqualifiziert wegen Unsportlichkeit / Regelwidrigkeit (DQ2)
  dsq2,
}

extension FightResultParser on FightResult {
  String get name =>
      toString()
          .split('.')
          .last;

  static FightResult valueOf(String name) => FightResult.values.singleWhere((element) => element.name == name);
}
