import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:window_manager/window_manager.dart';
import 'package:wrestling_scoreboard_client/ui/more/settings/preferences.dart';
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

  runApp(const WrestlingScoreboardApp());
}

class WrestlingScoreboardApp extends StatefulWidget {
  const WrestlingScoreboardApp({super.key});

  @override
  State<StatefulWidget> createState() => WrestlingScoreboardAppState();
}

class WrestlingScoreboardAppState extends State<WrestlingScoreboardApp> {
  Locale? _locale;
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();

    // TODO: replace with provider state and unify with settings, e.g. by using riverpod.

    // Need to init to listen to changes of settings.
    AudioCache.instance = AudioCache(prefix: '');
    HornSound.init();

    Preferences.getString(Preferences.keyLocale).then((localeStr) {
      if (localeStr != null) {
        final splits = localeStr.split('_');
        setState(() {
          if (splits.length > 1) {
            _locale = Locale(splits[0], splits[1]);
          } else {
            _locale = Locale(splits[0]);
          }
        });
      }
    });

    Preferences.getString(Preferences.keyThemeMode).then((value) {
      if (value != null) {
        setState(() {
          _themeMode = ThemeMode.values.byName(value);
        });
      }
    });

    Preferences.onChangeLocale.stream.distinct().listen((event) {
      setState(() {
        _locale = event;
      });
    });

    Preferences.onChangeThemeMode.stream.distinct().listen((event) {
      setState(() {
        _themeMode = event;
      });
    });
  }

  ThemeData _buildTheme(brightness) {
    var baseTheme = ThemeData(brightness: brightness);
    return baseTheme.copyWith(
      textTheme: GoogleFonts.robotoTextTheme(baseTheme.textTheme),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    final materialApp = MaterialApp.router(
      title: AppLocalizations.of(context)?.appName ?? 'Wrestling Scoreboard',
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: _themeMode,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: Preferences.supportedLanguages.values,
      locale: _locale,
      routerConfig: router,
    );
    return Shortcuts(
      shortcuts: appShortcuts,
      child: Actions(actions: <Type, Action<Intent>>{
        AppActionIntent: CallbackAction<AppActionIntent>(
          onInvoke: (AppActionIntent intent) => intent.handle(context: context),
        )
      }, child: materialApp),
    );
  }
}
