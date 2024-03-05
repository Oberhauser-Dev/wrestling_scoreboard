import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/routes/router.dart';
import 'package:wrestling_scoreboard_client/services/audio/audio.dart';
import 'package:wrestling_scoreboard_client/view/shortcuts/app_shortcuts.dart';
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
    HornSound.init();
  }

  ThemeData _buildTheme(Brightness brightness, String? fontFamily) {
    final baseTheme = ThemeData(brightness: brightness);
    if (fontFamily != null) {
      return baseTheme.copyWith(
        textTheme: GoogleFonts.getTextTheme(fontFamily),
      );
    }
    return baseTheme;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Locale?>(
      future: ref.watch(localeNotifierProvider),
      builder: (context, localeSnapshot) {
        return LoadingBuilder<ThemeMode>(
          future: ref.watch(themeModeNotifierProvider),
          builder: (context, themeMode) {
            return LoadingBuilder<String?>(
              future: ref.watch(fontFamilyNotifierProvider),
              builder: (context, fontFamily) {
                final materialApp = MaterialApp.router(
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
      },
    );
  }
}
