import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';
import 'package:wrestling_scoreboard_client/ui/utils.dart';

enum AppAction {
  toggleFullScreen,
  closeFullScreen,
}

class AppActionIntent extends Intent {
  const AppActionIntent({required this.type});

  const AppActionIntent.closeFullscreen() : type = AppAction.closeFullScreen;

  const AppActionIntent.toggleFullscreen() : type = AppAction.toggleFullScreen;

  final AppAction type;

  Future<void> handle({BuildContext? context}) async {
    switch (type) {
      case AppAction.closeFullScreen:
        if (isDesktop) {
          await windowManager.setFullScreen(false);
        } else {
          await SystemChrome.setEnabledSystemUIMode(
            SystemUiMode.manual,
            overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
          );
        }
        break;
      case AppAction.toggleFullScreen:
        if (isDesktop) {
          await windowManager.setFullScreen(!(await windowManager.isFullScreen()));
        } else {
          // TODO: add state and listen to [setSystemUIChangeCallback] to maintain toggle mode
          await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
        }
        break;
    }
  }
}

final appShortcuts = <ShortcutActivator, Intent>{
  LogicalKeySet(LogicalKeyboardKey.escape): const AppActionIntent.closeFullscreen(),
  LogicalKeySet(LogicalKeyboardKey.f11): const AppActionIntent.toggleFullscreen(),
};
