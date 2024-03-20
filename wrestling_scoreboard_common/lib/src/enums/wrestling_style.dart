enum WrestlingStyle {
  free, // free style
  greco; // greco-roman style

  String get name => toString().split('.').last;
}
