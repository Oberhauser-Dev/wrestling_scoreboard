enum BoutActionType {
  points,
  passivity, // P
  verbal, // V admonition
  caution, // yellow card
  dismissal // red card
}

extension BoutActionTypeParser on BoutActionType {
  String get name => toString().split('.').last;

  static BoutActionType valueOf(String name) => BoutActionType.values.singleWhere((element) => element.name == name);
}
