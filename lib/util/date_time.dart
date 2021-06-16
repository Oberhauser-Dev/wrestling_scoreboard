class MockableDateTime {
  static bool isMocked = false;
  static DateTime mockedDateTime = DateTime(2021, 6, 15);

  static now() => MockableDateTime.isMocked ? mockedDateTime : DateTime.now();
}

durationToString(Duration duration) {
  return '${duration.inMinutes.remainder(60)}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
}
