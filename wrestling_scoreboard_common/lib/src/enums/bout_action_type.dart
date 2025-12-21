enum BoutActionType {
  points,
  passivity, // 'P' (in greco) or 'A' (in free style german)
  verbal, // Verbal admonition 'V'
  caution, // yellow card 'O'
  dismissal, // red card 'D'
  legFoul; // 'L'

  bool get isCaution => this == caution || this == legFoul;
}
