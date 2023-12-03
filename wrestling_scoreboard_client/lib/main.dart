import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/ui/router.dart';
import 'package:wrestling_scoreboard_client/ui/settings/preferences.dart';

void main() async {
  usePathUrlStrategy();
  // Add this option to provide a way to stack pages indefinitely with `context.push`.
  // The back button on the browser then behaves the same as the back button in the app.
  // This comes with the price that URLs may not reflect the current stack on deep links (pasted links).
  // The correct way would be to add all possible sub-routes of a base route.
  GoRouter.optionURLReflectsImperativeAPIs = true;
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

    Preferences.onChangeLocale.stream.distinct().listen((event) {
      setState(() {
        _locale = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    return MaterialApp.router(
      title: AppLocalizations.of(context)?.appName ?? 'Wrestling Scoreboard',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
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
  }
}
