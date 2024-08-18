import 'package:wrestling_scoreboard_client/platform/interface.dart';

getWindowStateManager({required Future<void> Function(WindowState newState) setWindowState}) => NoneWindowStateManager(
      setWindowState: setWindowState,
    );

class NoneWindowStateManager {
  final Future<void> Function(WindowState newState) setWindowState;

  NoneWindowStateManager({
    required this.setWindowState,
  }) {
    listenToWindowState();
  }

  void listenToWindowState() {
    throw UnimplementedError('No default implementation given');
  }

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
