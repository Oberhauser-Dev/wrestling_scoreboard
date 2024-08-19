import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/platform/interface.dart';
import 'package:wrestling_scoreboard_client/provider/app_state_provider.dart';
import 'package:wrestling_scoreboard_client/view/utils.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';

class PreferredSizeImpl extends StatelessWidget implements PreferredSizeWidget {
  final Widget child;
  @override
  final Size preferredSize;

  const PreferredSizeImpl({super.key, required this.child, required this.preferredSize});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class WindowStateScaffold extends ConsumerWidget {
  const WindowStateScaffold({
    super.key,
    this.appBarTitle,
    this.appBarBottom,
    required this.body,
    this.actions,
    this.hideAppBarOnFullscreen = false,
  });

  final Widget? appBarTitle;
  final PreferredSizeWidget? appBarBottom;
  final bool hideAppBarOnFullscreen;
  final Widget body;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final alwaysShowAppBar = !hideAppBarOnFullscreen || isMobile;
    return LoadingBuilder<WindowState>(
        future: ref.watch(windowStateNotifierProvider),
        builder: (BuildContext context, WindowState data) {
          final hideAppBar = data == WindowState.fullscreen;
          final appBar = AppBar(
            title: appBarTitle,
            bottom: appBarBottom,
            actions: [
              ...?actions,
              IconButton(
                icon: data.isFullscreen() ? const Icon(Icons.fullscreen_exit) : const Icon(Icons.fullscreen),
                onPressed: () => ref.read(windowStateNotifierProvider.notifier).requestToggleFullScreen(),
                tooltip: localizations.toggleFullscreen,
              ),
            ],
          );
          if (alwaysShowAppBar) {
            return Scaffold(
              appBar: appBar,
              body: body,
            );
          }
          return Stack(
            alignment: AlignmentDirectional.topStart,
            children: [
              Scaffold(
                appBar: hideAppBar
                    ? null
                    : PreferredSizeImpl(
                        preferredSize: const Size.fromHeight(kToolbarHeight),
                        child: MouseRegion(
                          onEnter: (event) async {
                            if (data == WindowState.fullscreenAppbar) {
                              // Also call onEnter, to ensure AppBar is not disappearing when exiting and entering it again.
                              await ref.read(windowStateNotifierProvider.notifier).setFullscreenState(showAppbar: true);
                            }
                          },
                          onExit: (event) async {
                            if (data == WindowState.fullscreenAppbar) {
                              await ref
                                  .read(windowStateNotifierProvider.notifier)
                                  .setFullscreenState(showAppbar: false);
                            }
                          },
                          child: appBar,
                        )),
                body: body,
              ),
              if (hideAppBar)
                // Add a one pixel trigger at the top of the screen.
                // Must be on the bottom of the stack, to register mouse inputs
                MouseRegion(
                  cursor: SystemMouseCursors.allScroll,
                  child: Container(
                    height: 1,
                  ),
                  onEnter: (event) async {
                    await ref.read(windowStateNotifierProvider.notifier).setFullscreenState(showAppbar: true);
                  },
                  // On Exit is called via the AppBar, to ensure AppBar is not disappearing, if still pointing to it.
                ),
            ],
          );
        });
  }
}
