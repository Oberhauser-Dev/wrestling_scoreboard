class MockableDateTime {
  static bool isMocked = false;
  static DateTime mockedDateTime = DateTime(2021, 6, 15);

  static now() => MockableDateTime.isMocked ? mockedDateTime : DateTime.now();
}
