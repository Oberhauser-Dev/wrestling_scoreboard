import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:window_manager/window_manager.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/ui/components/loading_builder.dart';
import 'package:wrestling_scoreboard_client/ui/router.dart';
import 'package:wrestling_scoreboard_client/ui/shortcuts/app_shortcuts.dart';
import 'package:wrestling_scoreboard_client/ui/utils.dart';
import 'package:wrestling_scoreboard_client/util/audio/audio.dart';
import 'package:wrestling_scoreboard_client/util/environment.dart';

late PackageInfo packageInfo;

void main() async {
  // Use [HashUrlStrategy] by default to support Single Page Application without configuring the server.
  if (Env.usePathUrlStrategy.fromBool()) {
    usePathUrlStrategy();
  }

  // Add this option to provide a way to stack pages indefinitely with `context.push`.
  // The back button on the browser then behaves the same as the back button in the app.
  // This comes with the price that URLs may not reflect the current stack on deep links (pasted links).
  // The correct way would be to add all possible sub-routes of a base route.
  GoRouter.optionURLReflectsImperativeAPIs = true;

  WidgetsFlutterBinding.ensureInitialized();
  packageInfo = await PackageInfo.fromPlatform();

  if (isDesktop) {
    // Support fullscreen on Desktop
    await windowManager.ensureInitialized();
  }

  runApp(const ProviderScope(child: WrestlingScoreboardApp()));
}

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
    HornSound.init();
  }

  ThemeData _buildTheme(brightness) {
    var baseTheme = ThemeData(brightness: brightness);
    return baseTheme.copyWith(
      textTheme: GoogleFonts.robotoTextTheme(baseTheme.textTheme),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Locale?>(
      future: ref.watch(localeNotifierProvider),
      builder: (context, localeSnapshot) {
        return LoadingBuilder<ThemeMode>(
          future: ref.watch(themeModeNotifierProvider),
          builder: (context, themeMode) {
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
            final materialApp = MaterialApp.router(
              title: AppLocalizations.of(context)?.appName ?? 'Wrestling Scoreboard',
              theme: _buildTheme(Brightness.light),
              darkTheme: _buildTheme(Brightness.dark),
              themeMode: themeMode,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: Preferences.supportedLanguages.values,
              locale: localeSnapshot.data,
              routerConfig: router,
            );
            return Shortcuts(
              shortcuts: appShortcuts,
              child: Consumer(
                builder: (context, ref, child) {
                  return Actions(actions: <Type, Action<Intent>>{
                    AppActionIntent: CallbackAction<AppActionIntent>(
                      onInvoke: (AppActionIntent intent) => intent.handle(context, ref),
                    )
                  }, child: materialApp);
                },
              ),
            );
          },
        );
      },
    );
  }
}
