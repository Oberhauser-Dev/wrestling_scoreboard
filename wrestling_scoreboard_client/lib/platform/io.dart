import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';
import 'package:wrestling_scoreboard_client/platform/interface.dart';
import 'package:wrestling_scoreboard_client/view/utils.dart';

IOWindowStateManager getWindowStateManager({required Future<void> Function(WindowState newState) setWindowState}) =>
    IOWindowStateManager(setWindowState: setWindowState);

class IOWindowStateManager extends WindowStateManager with WindowListener {
  IOWindowStateManager({required super.setWindowState});

  @override
  void listenToWindowState() async {
    if (isDesktop) {
      windowManager.addListener(this);
    } else {
      await SystemChrome.setSystemUIChangeCallback((systemOverlaysAreVisible) async {
        await setWindowState(systemOverlaysAreVisible ? WindowState.windowed : WindowState.fullscreen);
      });
    }
  }

  @override
  Future<WindowState> getInitialState() async {
    if (isDesktop && await windowManager.isFullScreen()) {
      return WindowState.fullscreen;
    }
    return super.getInitialState();
  }

  @override
  Future<void> requestWindowState({required bool isFullscreen}) async {
    if (isFullscreen) {
      if (isDesktop) {
        await windowManager.setFullScreen(true);
      } else {
        await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      }
    } else {
      if (isDesktop) {
        await windowManager.setFullScreen(false);
      } else {
        await SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.manual,
          overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
        );
      }
    }
  }

  /// For Desktop only.
  @override
  void onWindowEnterFullScreen() {
    setWindowState(WindowState.fullscreen);
  }

  /// For Desktop only.
  @override
  void onWindowLeaveFullScreen() {
    // FIXME: canvas state is not redrawn, if exiting fullscreen mode.
    // Therefore, the state is updated after the window finished adapting.
    // Unfortunately, no state is provided, when the window finished leaving fullscreen mode.
    Future.delayed(const Duration(milliseconds: 400)).then((value) {
      setWindowState(WindowState.windowed);
    });
  }
}
