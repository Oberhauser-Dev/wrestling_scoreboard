enum WrestlingStyle {
  free, // free style
  greco, // greco-roman style
}

styleToString(WrestlingStyle style) {
  if (style == WrestlingStyle.free) return 'Freistil';
  return 'Gr.-Römisch';
}
