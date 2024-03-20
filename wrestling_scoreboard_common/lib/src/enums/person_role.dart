/// The role of the person.
enum PersonRole {
  referee,
  matChairman,
  judge,
  transcriptWriter,
  timeKeeper,
  steward;

  String get name => toString().split('.').last;
}
