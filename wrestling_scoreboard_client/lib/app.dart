import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/routes/router.dart';
import 'package:wrestling_scoreboard_client/services/network/remote/web_socket.dart';
import 'package:wrestling_scoreboard_client/view/shortcuts/app_shortcuts.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';

class WrestlingScoreboardApp extends ConsumerStatefulWidget {
  const WrestlingScoreboardApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => WrestlingScoreboardAppState();
}

class WrestlingScoreboardAppState extends ConsumerState<WrestlingScoreboardApp> {
  @override
  void initState() {
    super.initState();

    // Need to init to listen to changes of settings.
    AudioCache.instance = AudioCache(prefix: '');
  }

  ThemeData _buildTheme(Brightness brightness, String? fontFamily) {
    final baseTheme = ThemeData(brightness: brightness);
    if (fontFamily != null) {
      return baseTheme.copyWith(
        textTheme: GoogleFonts.getTextTheme(fontFamily, baseTheme.textTheme),
      );
    }
    return baseTheme;
  }

  @override
  Widget build(BuildContext context) {
    return LoadingBuilder<Locale?>(
      future: ref.watch(localeNotifierProvider),
      builder: (context, locale) {
        return LoadingBuilder<ThemeMode>(
          future: ref.watch(themeModeNotifierProvider),
          builder: (context, themeMode) {
            return LoadingBuilder<String?>(
              future: ref.watch(fontFamilyNotifierProvider),
              builder: (context, fontFamily) {
                return MaterialApp.router(
                  //debugShowCheckedModeBanner: false,
                  title: AppLocalizations.of(context)?.appName ?? 'Wrestling Scoreboard',
                  theme: _buildTheme(Brightness.light, fontFamily),
                  darkTheme: _buildTheme(Brightness.dark, fontFamily),
                  themeMode: themeMode,
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: Preferences.supportedLanguages,
                  builder: (context, child) => GlobalWidget(child: child ?? const CircularProgressIndicator()),
                  locale: locale,
                  routerConfig: getRouter(),
                );
              },
            );
          },
        );
      },
    );
  }
}

/// Widget to handle global functionality.
class GlobalWidget extends ConsumerStatefulWidget {
  final Widget child;

  const GlobalWidget({required this.child, super.key});

  @override
  ConsumerState<GlobalWidget> createState() => _GlobalWidgetState();
}

class _GlobalWidgetState extends ConsumerState<GlobalWidget> {
  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: appShortcuts,
      child: Actions(
        actions: <Type, Action<Intent>>{
          AppActionIntent: CallbackAction<AppActionIntent>(
            onInvoke: (AppActionIntent intent) {
              return intent.handle(context, ref);
            },
          )
        },
        child: widget.child,
      ),
    );
  }
}

class ConnectionWidget extends ConsumerStatefulWidget {
  final Widget child;

  const ConnectionWidget({required this.child, super.key});

  @override
  ConsumerState<ConnectionWidget> createState() => _ConnectionWidgetState();
}

class _ConnectionWidgetState extends ConsumerState<ConnectionWidget> {
  @override
  void initState() {
    super.initState();

    // Start listening
    void onRetry() async {
      (await ref.read(webSocketManagerNotifierProvider))
          .onWebSocketConnection
          .sink
          .add(WebSocketConnectionState.connecting);
    }

    // Listen to the websocket provider as soon as possible to not miss any state changes.
    ref.listenManual(webSocketStateStreamProvider.future, (previous, next) async {
      await catchAsync(
        context,
        () async {
          final connectionState = await next;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && connectionState == WebSocketConnectionState.disconnected) {
              final localizations = AppLocalizations.of(context)!;
              showExceptionDialog(
                  context: context, exception: localizations.noWebSocketConnection, stackTrace: null, onRetry: onRetry);
            }
          });
        },
        onRetry: onRetry,
      );
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
