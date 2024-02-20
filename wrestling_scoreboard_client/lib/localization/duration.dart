extension DurationLocalization on Duration {
  String formatMinutesAndSeconds() {
    return '${inMinutes.remainder(60)}:${inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }
}
