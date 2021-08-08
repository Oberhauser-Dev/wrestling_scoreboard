enum WrestlingStyle {
  free, // free style
  greco, // greco-roman style
}

extension WrestlingStyleParser on WrestlingStyle {
  String get name => toString().split('.').last;

  static WrestlingStyle valueOf(String name) => WrestlingStyle.values.singleWhere((element) => element.name == name);
}
