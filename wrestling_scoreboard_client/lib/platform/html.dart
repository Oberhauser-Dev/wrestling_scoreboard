/// Dummy html document to replace html package.
class HTMLDocument {
  get fullscreenElement => null;

  get documentElement => null;

  void addEventListener(String type, void Function(dynamic event) listener) {}

  void exitFullscreen() {}
}

final document = HTMLDocument();

class AnchorElement {
  set href(String str) {}

  set download(String str) {}

  dynamic get style => throw UnimplementedError();

  void click() {}
}
