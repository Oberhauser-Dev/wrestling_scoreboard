import 'dart:math';

class MockableRandom {
  static int seed = 0;
  static bool isMocked = false;

  static Random create() => MockableRandom.isMocked ? Random(seed) : Random();

  static Random secure() => MockableRandom.isMocked ? Random(seed) : Random.secure();
}
