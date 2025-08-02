import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/platform/interface.dart';
import 'package:wrestling_scoreboard_client/provider/app_state_provider.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/view/utils.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';

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
  final List<ResponsiveScaffoldActionItem>? actions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = context.l10n;
    final alwaysShowAppBar = !hideAppBarOnFullscreen || isMobile;
    return LoadingBuilder<String?>(
      future: ref.watch(webClientUrlNotifierProvider),
      builder: (BuildContext context, String? webClientUrl) {
        return LoadingBuilder<WindowState>(
          future: ref.watch(windowStateNotifierProvider),
          builder: (BuildContext context, WindowState data) {
            final hideAppBar = data == WindowState.fullscreen;
            final appBar = AppBar(
              // FIXME: For a scratch bout the route is nested in a ShellRoute, which does hide the back button.
              // https://github.com/flutter/flutter/issues/144687
              leading: context.canPop() ? BackButton(onPressed: () => Navigator.of(context).pop()) : null,
              title: appBarTitle,
              bottom: appBarBottom,
              actions: [
                ResponsiveScaffoldActions(
                  actionContents: [
                    ...?actions,
                    if (webClientUrl != null && !kIsWeb)
                      ResponsiveScaffoldActionItem(
                        icon: const Icon(Icons.share),
                        onTap: () async {
                          final shareUrl = Uri.parse(webClientUrl + GoRouterState.of(context).matchedLocation);
                          if (isDesktop) {
                            await launchUrl(shareUrl);
                          } else {
                            await SharePlus.instance.share(ShareParams(uri: shareUrl));
                          }
                        },
                        label: localizations.share,
                      ),
                    if (isOnDesktop)
                      ResponsiveScaffoldActionItem(
                        icon: data.isFullscreen() ? const Icon(Icons.fullscreen_exit) : const Icon(Icons.fullscreen),
                        onTap: () => ref.read(windowStateNotifierProvider.notifier).requestToggleFullScreen(),
                        label: localizations.toggleFullscreen,
                      ),
                  ],
                ),
              ],
            );
            if (alwaysShowAppBar) {
              return Scaffold(appBar: appBar, body: body);
            }
            return Stack(
              alignment: AlignmentDirectional.topStart,
              children: [
                Scaffold(
                  appBar:
                      hideAppBar
                          ? null
                          : PreferredSizeImpl(
                            preferredSize: const Size.fromHeight(kToolbarHeight),
                            child: MouseRegion(
                              onEnter: (event) async {
                                if (data == WindowState.fullscreenAppbar) {
                                  // Also call onEnter, to ensure AppBar is not disappearing when exiting and entering it again.
                                  await ref
                                      .read(windowStateNotifierProvider.notifier)
                                      .setFullscreenState(showAppbar: true);
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
                            ),
                          ),
                  body: body,
                ),
                if (hideAppBar)
                  // Add a one pixel trigger at the top of the screen.
                  // Must be on the bottom of the stack, to register mouse inputs
                  MouseRegion(
                    cursor: SystemMouseCursors.allScroll,
                    child: Container(height: 1),
                    onEnter: (event) async {
                      await ref.read(windowStateNotifierProvider.notifier).setFullscreenState(showAppbar: true);
                    },
                    // On Exit is called via the AppBar, to ensure AppBar is not disappearing, if still pointing to it.
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
