import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/utils/asset.dart';
import 'package:wrestling_scoreboard_client/utils/environment.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';

class CustomSettingsScreen extends ConsumerWidget {
  const CustomSettingsScreen({super.key});

  String getBellNameOfPath(String value) => value.split('/').last.replaceAll('.mp3', '');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    bool isDisplayInternational() {
      if (Localizations.localeOf(context).languageCode == 'en') return false;
      return true;
    }

    String getTranslationOfLocale([String? locale]) {
      switch (locale) {
        case 'de':
        case 'de_DE':
          return localizations.de_DE + (isDisplayInternational() ? ' | German' : '');
        case 'en':
        case 'en_US':
          return localizations.en_US + (isDisplayInternational() ? ' | English (US)' : '');
        default:
          return localizations.systemSetting + (isDisplayInternational() ? ' | System setting' : '');
      }
    }

    String getTranslationOfThemeMode(ThemeMode themeMode) {
      switch (themeMode) {
        case ThemeMode.light:
          return localizations.themeModeLight;
        case ThemeMode.dark:
          return localizations.themeModeDark;
        case ThemeMode.system:
          return localizations.systemSetting;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.settings),
      ),
      body: ResponsiveColumn(
        children: [
          FutureBuilder<Locale?>(
            future: ref.watch(localeNotifierProvider),
            builder: (context, localeSnapshot) {
              var locale = localeSnapshot.data;
              return LoadingBuilder<ThemeMode>(
                future: ref.watch(themeModeNotifierProvider),
                builder: (context, themeMode) {
                  return SettingsSection(
                    title: localizations.general,
                    action: TextButton(
                      onPressed: () {
                        locale = null;
                        Preferences.setString(Preferences.keyLocale, locale?.toLanguageTag());
                        Preferences.onChangeLocale.add(locale);

                        themeMode = ThemeMode.system;
                        Preferences.setString(Preferences.keyThemeMode, themeMode.name);
                        Preferences.onChangeThemeMode.add(themeMode);
                      },
                      child: Text(localizations.reset),
                    ),
                    children: [
                      ListTile(
                        leading: const Icon(Icons.translate),
                        title: Text(localizations.language + (isDisplayInternational() ? ' | Language' : '')),
                        subtitle: Text(getTranslationOfLocale(locale?.toLanguageTag())),
                        onTap: () async {
                          final val = await showDialog<String?>(
                            context: context,
                            builder: (BuildContext context) {
                              final List<MapEntry<String?, String>> languageSettingValues = Preferences
                                  .supportedLanguages
                                  .map((key, value) => MapEntry<String?, String>(key, getTranslationOfLocale(key)))
                                  .entries
                                  .toList();
                              languageSettingValues.add(MapEntry(null, getTranslationOfLocale()));
                              return RadioDialog<String>(
                                  values: languageSettingValues, initialValue: locale?.toLanguageTag());
                            },
                          );
                          Preferences.onChangeLocale.add(Preferences.supportedLanguages[val]);
                          await Preferences.setString(Preferences.keyLocale, val);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.brush),
                        title: Text(localizations.themeMode),
                        subtitle: Text(getTranslationOfThemeMode(themeMode)),
                        onTap: () async {
                          final val = await showDialog<ThemeMode>(
                            context: context,
                            builder: (BuildContext context) {
                              final List<MapEntry<ThemeMode, String>> themeModeValues = ThemeMode.values
                                  .map((value) => MapEntry<ThemeMode, String>(value, getTranslationOfThemeMode(value)))
                                  .toList();
                              return RadioDialog<ThemeMode>(values: themeModeValues, initialValue: themeMode);
                            },
                          );
                          if (val != null) {
                            Preferences.onChangeThemeMode.add(val);
                            await Preferences.setString(Preferences.keyThemeMode, val.name);
                          }
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          LoadingBuilder<String>(
            future: ref.watch(apiUrlNotifierProvider),
            builder: (context, apiUrl) {
              return LoadingBuilder<String>(
                future: ref.watch(webSocketUrlNotifierProvider),
                builder: (context, wsUrl) {
                  return SettingsSection(
                    title: localizations.network,
                    action: TextButton(
                      onPressed: () {
                        apiUrl = Env.apiUrl.fromString();
                        Preferences.setString(Preferences.keyApiUrl, apiUrl);
                        Preferences.onChangeApiUrl.add(apiUrl);

                        wsUrl = Env.webSocketUrl.fromString();
                        Preferences.setString(Preferences.keyWsUrl, wsUrl);
                        Preferences.onChangeWsUrlWebSocket.add(wsUrl);
                      },
                      child: Text(localizations.reset),
                    ),
                    children: [
                      ListTile(
                        subtitle: Text(apiUrl),
                        title: Text(localizations.apiUrl),
                        leading: const Icon(Icons.storage),
                        onTap: () async {
                          final val = await showDialog<String>(
                            context: context,
                            builder: (BuildContext context) {
                              return TextInputDialog(initialValue: apiUrl);
                            },
                          );
                          if (val != null) {
                            Preferences.onChangeApiUrl.add(val);
                            await Preferences.setString(Preferences.keyApiUrl, val);
                          }
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.storage),
                        title: Text(localizations.wsUrl),
                        subtitle: Text(wsUrl),
                        onTap: () async {
                          final val = await showDialog<String?>(
                            context: context,
                            builder: (BuildContext context) {
                              return TextInputDialog(initialValue: wsUrl);
                            },
                          );
                          if (val != null) {
                            Preferences.onChangeWsUrlWebSocket.add(val);
                            await Preferences.setString(Preferences.keyWsUrl, val);
                          }
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          LoadingBuilder<String>(
            future: ref.watch(bellSoundNotifierProvider),
            builder: (context, bellSoundPath) {
              return SettingsSection(
                title: localizations.scoreboard,
                action: TextButton(
                  onPressed: () {
                    bellSoundPath = Env.bellSoundPath.fromString();
                    Preferences.setString(Preferences.keyBellSound, bellSoundPath);
                    Preferences.onChangeBellSound.add(bellSoundPath);
                  },
                  child: Text(localizations.reset),
                ),
                children: [
                  ListTile(
                    leading: const Icon(Icons.audiotrack),
                    title: Text(localizations.bellSound),
                    subtitle: Text(getBellNameOfPath(bellSoundPath)),
                    onTap: () async {
                      final bellSoundPaths = await getAssetList(prefix: '', filetype: '.mp3');
                      // Convert to list of entries with <String, String>, e.g. <'AirHorn', '/assets/audio/AirHorn.mp3'>
                      final List<MapEntry<String, String>> bellSoundValues = bellSoundPaths
                          .asMap()
                          .map((key, value) => MapEntry<String, String>(value, getBellNameOfPath(value)))
                          .entries
                          .toList();
                      if (context.mounted) {
                        final val = await showDialog<String>(
                          context: context,
                          builder: (BuildContext context) {
                            return RadioDialog(
                              values: bellSoundValues,
                              initialValue: bellSoundPath,
                              onChanged: (value) async {
                                if (value != null) {
                                  final ap = AudioPlayer();
                                  await ap.play(AssetSource(value));
                                }
                              },
                            );
                          },
                        );
                        if (val != null) {
                          Preferences.onChangeBellSound.add(val);
                          await Preferences.setString(Preferences.keyBellSound, val);
                        }
                      }
                    },
                  ),
                  // TODO option to overwrite boutConfigs
                  // ContentItem(title: localizations.durations, icon: Icons.timer, onTap: null),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  final String title;
  final Widget? action;
  final List<Widget> children;

  const SettingsSection({required this.title, this.action, required this.children, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        title: Text(title),
        trailing: action,
      ),
      Card(
        child: Column(
          children: ListTile.divideTiles(
            context: context,
            tiles: children,
          ).toList(),
        ),
      ),
    ]);
  }
}
