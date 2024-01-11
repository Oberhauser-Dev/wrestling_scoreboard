import 'package:wrestling_scoreboard_client/platform/html.dart' if (dart.library.html) 'dart:html'; // 

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:window_manager/window_manager.dart';
import 'package:wrestling_scoreboard_client/ui/utils.dart';

part 'app_state_provider.g.dart';

@Riverpod(keepAlive: true)
class WindowStateNotifier extends _$WindowStateNotifier with WindowListener {
  @override
  Raw<Future<WindowState>> build() async {
    if (kIsWeb) {
      document.addEventListener('fullscreenchange', (event) {
        if (document.fullscreenElement != null) {
          _setNewState(WindowState.fullscreen);
        } else {
          _setNewState(WindowState.windowed);
        }
      });
    } else if (isDesktop) {
      windowManager.addListener(this);
    } else {
      await SystemChrome.setSystemUIChangeCallback((systemOverlaysAreVisible) async {
        await _setNewState(systemOverlaysAreVisible ? WindowState.windowed : WindowState.fullscreen);
      });
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
        if (kIsWeb) {
          document.exitFullscreen();
        } else if (isDesktop) {
          await windowManager.setFullScreen(false);
        } else {
          await SystemChrome.setEnabledSystemUIMode(
            SystemUiMode.manual,
            overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
          );
        }
        break;
      case WindowState.fullscreen:
        if (kIsWeb) {
          document.documentElement?.requestFullscreen();
        } else if (isDesktop) {
          await windowManager.setFullScreen(true);
        } else {
          await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
        }
        break;
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
