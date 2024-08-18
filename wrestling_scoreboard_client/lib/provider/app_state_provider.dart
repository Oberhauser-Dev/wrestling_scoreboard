import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wrestling_scoreboard_client/platform/interface.dart';
import 'package:wrestling_scoreboard_client/platform/none.dart'
    if (dart.library.io) 'package:wrestling_scoreboard_client/platform/io.dart'
    if (dart.library.js_interop) 'package:wrestling_scoreboard_client/platform/web.dart';

part 'app_state_provider.g.dart';

@Riverpod(keepAlive: true)
class WindowStateNotifier extends _$WindowStateNotifier {
  late WindowStateManager windowStateManager;

  @override
  Raw<Future<WindowState>> build() async {
    windowStateManager = getWindowStateManager(setWindowState: _setWindowState);
    return await windowStateManager.getInitialState();
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
    windowStateManager.requestWindowState(isFullscreen: isFullscreen);
  }

  Future<void> _setWindowState(WindowState newState) async {
    final currentState = await state;
    // Do not set a new state, if fullscreen and already is in fullscreen to avoid toggling Appbar with callback.
    if (newState != currentState && !(currentState.isFullscreen() && newState.isFullscreen())) {
      state = Future.value(newState);
    }
  }
}
