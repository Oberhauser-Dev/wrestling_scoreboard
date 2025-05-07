import 'dart:js_interop';

import 'package:web/web.dart' as web;
import 'package:wrestling_scoreboard_client/platform/interface.dart';

getWindowStateManager({required Future<void> Function(WindowState newState) setWindowState}) =>
    WebWindowStateManager(setWindowState: setWindowState);

class WebWindowStateManager extends WindowStateManager {
  WebWindowStateManager({required super.setWindowState});

  @override
  void listenToWindowState() {
    web.document.addEventListener(
      'fullscreenchange',
      (web.Event event) {
        if (web.document.fullscreenElement != null) {
          setWindowState(WindowState.fullscreen);
        } else {
          setWindowState(WindowState.windowed);
        }
      }.toJS,
    );
  }

  @override
  Future<void> requestWindowState({required bool isFullscreen}) async {
    if (isFullscreen) {
      await web.document.documentElement?.requestFullscreen().toDart;
    } else {
      await web.document.exitFullscreen().toDart;
    }
  }
}
