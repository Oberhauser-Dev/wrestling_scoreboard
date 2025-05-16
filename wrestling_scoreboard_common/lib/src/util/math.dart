import 'dart:math';

class MockableRandom {
  static int seed = 0;
  static bool isMocked = false;

  static Random create() => MockableRandom.isMocked ? Random(seed) : Random();
}
