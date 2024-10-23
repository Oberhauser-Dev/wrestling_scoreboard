extension InvertedDuration on Duration {
  Duration invertIf(bool isInverted, {required Duration max}) {
    return isInverted ? max - this : this;
  }
}
