import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/provider/app_state_provider.dart';
import 'package:wrestling_scoreboard_client/provider/data_provider.dart';

enum AppAction { toggleFullScreen, closeFullScreen, refresh }

class AppActionIntent extends Intent {
  const AppActionIntent({required this.type});

  const AppActionIntent.closeFullscreen() : type = AppAction.closeFullScreen;

  const AppActionIntent.toggleFullscreen() : type = AppAction.toggleFullScreen;

  const AppActionIntent.refresh() : type = AppAction.refresh;

  final AppAction type;

  Future<void> handle(BuildContext? context, WidgetRef ref) async {
    switch (type) {
      case AppAction.closeFullScreen:
        await ref.read(windowStateProvider.notifier).requestWindowState(isFullscreen: false);
        break;
      case AppAction.toggleFullScreen:
        await ref.read(windowStateProvider.notifier).requestToggleFullScreen();
        break;
      case AppAction.refresh:
        // Invalidate all data families, so they get reloaded from the server.
        ref.invalidate(remoteConfigProvider);
        ref.invalidate(manyDataStreamProvider);
        ref.invalidate(singleDataStreamProvider);
        break;
    }
  }
}

final appShortcuts = <ShortcutActivator, Intent>{
  LogicalKeySet(LogicalKeyboardKey.escape): const AppActionIntent.closeFullscreen(),
  LogicalKeySet(LogicalKeyboardKey.f11): const AppActionIntent.toggleFullscreen(),
  LogicalKeySet(LogicalKeyboardKey.f5): const AppActionIntent.refresh(),
};
