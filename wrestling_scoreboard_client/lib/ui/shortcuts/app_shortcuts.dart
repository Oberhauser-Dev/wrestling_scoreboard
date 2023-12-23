import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/provider/app_state_provider.dart';

enum AppAction {
  toggleFullScreen,
  closeFullScreen,
}

class AppActionIntent extends Intent {
  const AppActionIntent({required this.type});

  const AppActionIntent.closeFullscreen() : type = AppAction.closeFullScreen;

  const AppActionIntent.toggleFullscreen() : type = AppAction.toggleFullScreen;

  final AppAction type;

  Future<void> handle(BuildContext? context, WidgetRef ref) async {
    switch (type) {
      case AppAction.closeFullScreen:
        await ref.read(windowStateNotifierProvider.notifier).requestState(WindowState.windowed);
        break;
      case AppAction.toggleFullScreen:
        await ref.read(windowStateNotifierProvider.notifier).requestToggleFullScreen();
        break;
    }
  }
}

final appShortcuts = <ShortcutActivator, Intent>{
  LogicalKeySet(LogicalKeyboardKey.escape): const AppActionIntent.closeFullscreen(),
  LogicalKeySet(LogicalKeyboardKey.f11): const AppActionIntent.toggleFullscreen(),
};
