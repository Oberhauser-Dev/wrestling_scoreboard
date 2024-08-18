abstract class WindowStateManager {
  final Future<void> Function(WindowState newState) setWindowState;

  WindowStateManager({
    required this.setWindowState,
  }) {
    listenToWindowState();
  }

  void listenToWindowState();

  Future<WindowState> getInitialState() async {
    return WindowState.windowed;
  }

  Future<void> requestWindowState({required bool isFullscreen});
}

enum WindowState {
  windowed,
  fullscreen,
  fullscreenAppbar;

  bool isFullscreen() {
    return this == WindowState.fullscreen || this == WindowState.fullscreenAppbar;
  }
}
