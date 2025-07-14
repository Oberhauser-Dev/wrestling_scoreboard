import 'package:wrestling_scoreboard_client/platform/interface.dart';

WindowStateManager getWindowStateManager({required Future<void> Function(WindowState newState) setWindowState}) =>
    NoneWindowStateManager(setWindowState: setWindowState);

class NoneWindowStateManager extends WindowStateManager {
  NoneWindowStateManager({required super.setWindowState});

  @override
  void listenToWindowState() {
    throw UnimplementedError('No default implementation given');
  }

  @override
  Future<void> requestWindowState({required bool isFullscreen}) async {
    throw UnimplementedError('No default implementation given');
  }
}

class HTMLAnchorElement {
  set href(String str) {}

  set download(String str) {}

  dynamic get style => throw UnimplementedError();

  void click() {}
}
