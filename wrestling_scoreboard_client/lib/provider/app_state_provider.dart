import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web/web.dart' as web;
import 'package:window_manager/window_manager.dart';
import 'package:wrestling_scoreboard_client/view/utils.dart';

part 'app_state_provider.g.dart';

@Riverpod(keepAlive: true)
class WindowStateNotifier extends _$WindowStateNotifier with WindowListener {
  @override
  Raw<Future<WindowState>> build() async {
    if (kIsWeb) {
      web.document.addEventListener(
        'fullscreenchange',
        (web.Event event) {
          if (web.document.fullscreenElement != null) {
            _setWindowState(WindowState.fullscreen);
          } else {
            _setWindowState(WindowState.windowed);
          }
        }.toJS,
      );
    } else if (isDesktop) {
      windowManager.addListener(this);
    } else {
      await SystemChrome.setSystemUIChangeCallback((systemOverlaysAreVisible) async {
        await _setWindowState(systemOverlaysAreVisible ? WindowState.windowed : WindowState.fullscreen);
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
    _setWindowState(WindowState.fullscreen);
  }

  /// For Desktop only.
  @override
  void onWindowLeaveFullScreen() {
    // FIXME: canvas state is not redrawn, if exiting fullscreen mode.
    // Therefore, the state is updated after the window finished adapting.
    // Unfortunately, no state is provided, when the window finished leaving fullscreen mode.
    Future.delayed(const Duration(milliseconds: 400)).then((value) {
      _setWindowState(WindowState.windowed);
    });
  }

  Future<void> requestToggleFullScreen() async {
    final currentState = await state;
    if (currentState.isFullscreen()) {
      await requestWindowState(isFullscreen: false);
    } else {
      await requestWindowState(isFullscreen: true);
    }
  }

  // Save datetime as id for last action.
  final _lastWindowStateAction = <DateTime>[];
  final _appBarHideDuration = const Duration(seconds: 1);

  // Only calls Appbar if in fullscreen state.
  Future<void> setFullscreenState({required bool showAppbar}) async {
    final actionId = DateTime.now();
    _lastWindowStateAction.add(actionId);
    if (!showAppbar) {
      await Future.delayed(_appBarHideDuration);
    }
    // Skip, if it's not the last action
    if (actionId == _lastWindowStateAction.last) {
      final currentState = await state;
      if (currentState.isFullscreen()) {
        final newState = showAppbar ? WindowState.fullscreenAppbar : WindowState.fullscreen;
        if (currentState != newState) {
          state = Future.value(newState);
        }
      }
    }
    if (showAppbar) {
      Future.delayed(_appBarHideDuration).then((value) {
        // Need to wait removing the last showAppBar action to ensure the check still is valid.
        return _lastWindowStateAction.remove(actionId);
      });
    } else {
      _lastWindowStateAction.remove(actionId);
    }
  }

  Future<void> requestWindowState({required bool isFullscreen}) async {
    if (isFullscreen) {
      if (kIsWeb) {
        await web.document.documentElement?.requestFullscreen().toDart;
      } else if (isDesktop) {
        await windowManager.setFullScreen(true);
      } else {
        await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      }
    } else {
      if (kIsWeb) {
        await web.document.exitFullscreen().toDart;
      } else if (isDesktop) {
        await windowManager.setFullScreen(false);
      } else {
        await SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.manual,
          overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
        );
      }
    }
  }

  Future<void> _setWindowState(WindowState newState) async {
    final currentState = await state;
    // Do not set a new state, if fullscreen and already is in fullscreen to avoid toggling Appbar with callback.
    if (newState != currentState && !(currentState.isFullscreen() && newState.isFullscreen())) {
      state = Future.value(newState);
    }
  }
}

enum WindowState {
  windowed,
  fullscreen,
  fullscreenAppbar;

  bool isFullscreen() {
    return this == WindowState.fullscreen || this == WindowState.fullscreenAppbar;
  }
}
