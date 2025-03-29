enum CompetitionSystem {
  nordic,
  twoPools;

  String get name => toString().split('.').last;

  // TODO: should be hardcoded per mode
  // /// The maximum contestants which can be in one pool
  // @Default(100) int maxPoolContestants,
  // @Default(2) int maxPoolDefeats,
  //
  // /// The maximum contestants for wrestle in nordic mode
  // @Default(6) int maxNordicContestants,
}
