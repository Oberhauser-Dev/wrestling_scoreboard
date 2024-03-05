extension DurationLocalization on Duration {
  String formatMinutesAndSeconds() {
    return '$inMinutes:${inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }

  String formatSecondsAndMilliseconds() {
    return '$inSeconds.${inMilliseconds.remainder(1000).toString().padLeft(3, '0')}s';
  }
}
