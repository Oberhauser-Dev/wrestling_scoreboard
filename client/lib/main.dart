import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:wrestling_scoreboard/ui/appNavigation.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(WrestlingScoreboardApp());
}

class WrestlingScoreboardApp extends StatelessWidget {
  Locale _locale = Locale('en');

  WrestlingScoreboardApp() {
    (() async {
      await Settings.init(cacheProvider: SharePreferenceCache());
    })();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return MaterialApp(
      title: AppLocalizations.of(context)?.appName ?? 'Wrestling Scoreboard',
      theme: ThemeData(
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      themeMode: ThemeMode.dark,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('de', ''),
      ],
      locale: _locale,
      home: AppNavigation(),
    );
  }
}
