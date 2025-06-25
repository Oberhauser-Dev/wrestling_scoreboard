class InvalidParameterException implements Exception {
  String message;

  InvalidParameterException(this.message);

  @override
  String toString() {
    return 'InvalidParameterException(message: "$message")';
  }
}
