enum BoutActionType {
  points,
  passivity, // P
  verbal, // V admonition
  caution, // yellow card
  dismissal; // red card

  String get name => toString().split('.').last;
}
