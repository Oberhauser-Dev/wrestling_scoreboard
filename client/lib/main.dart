import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:wrestling_scoreboard/ui/appNavigation.dart';
import 'package:wrestling_scoreboard/ui/settings/settings.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  await Settings.init(cacheProvider: SharePreferenceCache());
  runApp(const WrestlingScoreboardApp());
}

class WrestlingScoreboardApp extends StatefulWidget {
  const WrestlingScoreboardApp({Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() => WrestlingScoreboardAppState();
}

class WrestlingScoreboardAppState extends State<WrestlingScoreboardApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    final localeStr = Settings.getValue<String>(CustomSettingsScreen.keyLocale, null);
    if (localeStr != null) {
      final splits = localeStr.split('_');
      if (splits.length > 1) {
        _locale = Locale(splits[0], splits[1]);
      } else {
        _locale = Locale(splits[0]);
      }
    }
    CustomSettingsScreen.onChangeLocale.stream.listen((event) {
      setState(() {
        _locale = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
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
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: CustomSettingsScreen.supportedLanguages.values,
      locale: _locale,
      home: const AppNavigation(),
    );
  }
}
