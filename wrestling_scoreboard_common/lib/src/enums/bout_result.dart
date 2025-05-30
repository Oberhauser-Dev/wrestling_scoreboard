/// The result of a single bout.
enum BoutResult {
  /// Victory by fall
  /// Schultersieg (SS)
  vfa,

  /// Victory by injury
  /// Aufgabesieg wegen Verletzung (AS)
  vin,

  /// Double injury - Both wrestlers are injured (2VIN)
  bothVin,

  /// Victory by cautions - the opponent received 3 cautions "O" due to error against the rules
  /// Sieger durch 3 Verwarnungen / Regelwidrigkeit des Gegners (DV)
  vca,

  /// Technical superiority
  /// Technische Überlegenheit (TÜ)
  vsu,

  /// Victory by points
  /// Punktsieg (PS)
  vpo,

  /// Victory by forfeit - no show up on the mat
  /// - If an athlete doesn’t show up on the mat
  /// - If an athlete doesn’t attend or fail the weigh-in
  /// Sieger durch Ausschluss des Gegners vom Wettkampf wegen Nichtantritt (DN)
  vfo,

  /// Double forfeit - None of wrestlers pass the weight or show up on the mat (2VFO)
  bothVfo,

  /// Victory by disqualification of the opponent from the whole competition due to infringement of the rules
  /// Sieger durch Ausschluss des Gegners vom Wettkampf wegen Unsportlichkeit / Tätlichkeit (DQ)
  dsq,

  /// In case both wrestlers have been disqualified due to infringement of the rules
  /// Beide Ringer disqualifiziert wegen Unsportlichkeit / Regelwidrigkeit (DQ2)
  bothDsq;

  bool affectsBoth() {
    return this == BoutResult.bothVfo || this == BoutResult.bothVin || this == BoutResult.bothDsq;
  }
}
