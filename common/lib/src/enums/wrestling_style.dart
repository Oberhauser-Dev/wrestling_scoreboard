enum WrestlingStyle {
  free, // free style
  greco, // greco-roman style
}

WrestlingStyle wrestlingStyleDecode(String val) {
  return WrestlingStyle.values.singleWhere((element) => element.toString() == 'WrestlingStyle.' + val);
}