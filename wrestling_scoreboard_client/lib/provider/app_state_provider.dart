import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:window_manager/window_manager.dart';
import 'package:wrestling_scoreboard_client/ui/utils.dart';

part 'app_state_provider.g.dart';

// TODO: check for web
@Riverpod(keepAlive: true)
class WindowStateNotifier extends _$WindowStateNotifier with WindowListener {
  @override
  Raw<Future<WindowState>> build() async {
    if (isMobile) {
      await SystemChrome.setSystemUIChangeCallback((systemOverlaysAreVisible) async {
        await _setNewState(systemOverlaysAreVisible ? WindowState.windowed : WindowState.fullscreen);
      });
    } else if (isDesktop) {
      windowManager.addListener(this);
    }

    if (isDesktop && await windowManager.isFullScreen()) {
      return WindowState.fullscreen;
    }
    return WindowState.windowed;
  }

  /// For Desktop only.
  @override
  void onWindowEnterFullScreen() {
    _setNewState(WindowState.fullscreen);
  }

  /// For Desktop only.
  @override
  void onWindowLeaveFullScreen() {
    // FIXME: canvas state is not redrawn, if exiting fullscreen mode.
    // Therefore, the state is updated after the window finished adapting.
    // Unfortunately, no state is provided, when the window finished leaving fullscreen mode.
    Future.delayed(const Duration(milliseconds: 400)).then((value) {
      _setNewState(WindowState.windowed);
    });
  }

  Future<void> requestToggleFullScreen() async {
    final currentState = await state;
    if (currentState == WindowState.fullscreen) {
      await requestState(WindowState.windowed);
    } else {
      await requestState(WindowState.fullscreen);
    }
  }

  Future<void> requestState(WindowState windowState) async {
    switch (windowState) {
      case WindowState.windowed:
        if (isDesktop) {
          await windowManager.setFullScreen(false);
        } else {
          await SystemChrome.setEnabledSystemUIMode(
            SystemUiMode.manual,
            overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
          );
        }
        break;
      case WindowState.fullscreen:
        if (isDesktop) {
          await windowManager.setFullScreen(true);
        } else {
          await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
        }
        break;
    }

    if (kIsWeb) {
      // Only need to set on web (not evaluated if it's working there), as we have listeners for the other platforms.
      await _setNewState(windowState);
    }
  }

  Future<void> _setNewState(WindowState newState) async {
    final currentState = await state;
    if (newState != currentState) {
      state = Future.value(newState);
    }
  }
}

enum WindowState {
  windowed,
  fullscreen,
}
