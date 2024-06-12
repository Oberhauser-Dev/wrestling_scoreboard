import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_selector/file_selector.dart' as file_selector;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wrestling_scoreboard_client/localization/duration.dart';
import 'package:wrestling_scoreboard_client/platform/html.dart' if (dart.library.html) 'dart:html' as html;
import 'package:wrestling_scoreboard_client/provider/local_preferences.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/utils/asset.dart';
import 'package:wrestling_scoreboard_client/utils/environment.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaffold.dart';

class CustomSettingsScreen extends ConsumerWidget {
  static const route = 'settings';

  const CustomSettingsScreen({super.key});

  String getBellNameOfPath(String value) => value.split('/').last.replaceAll('.mp3', '');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    bool isDisplayInternational() {
      if (Localizations.localeOf(context).languageCode == 'en') return false;
      return true;
    }

    String getTranslationOfLocale([Locale? locale]) {
      switch (locale?.languageCode) {
        case 'de':
          return localizations.de_DE + (isDisplayInternational() ? ' | German' : '');
        case 'en':
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

    Future<(Locale?, ThemeMode, String?)> loadGeneralSettings() async {
      var results = await Future.wait([
        ref.watch(localeNotifierProvider),
        ref.watch(themeModeNotifierProvider),
        ref.watch(fontFamilyNotifierProvider)
      ]);

      return (results[0] as Locale?, results[1] as ThemeMode, results[2] as String?);
    }

    return WindowStateScaffold(
      appBarTitle: Text(localizations.settings),
      body: ResponsiveColumn(
        children: [
          LoadingBuilder<(Locale?, ThemeMode, String?)>(
              future: loadGeneralSettings(),
              builder: (context, generalSettings) {
                var locale = generalSettings.$1;
                var themeMode = generalSettings.$2;
                var fontFamily = generalSettings.$3;

                return SettingsSection(
                  title: localizations.general,
                  action: TextButton(
                    onPressed: () async {
                      locale = null;
                      await ref.read(localeNotifierProvider.notifier).setState(locale);

                      themeMode = ThemeMode.system;
                      await ref.read(themeModeNotifierProvider.notifier).setState(themeMode);

                      const defaultFontFamily = 'Roboto';
                      await ref.read(fontFamilyNotifierProvider.notifier).setState(defaultFontFamily);
                    },
                    child: Text(localizations.reset),
                  ),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.translate),
                      title: Text(localizations.language + (isDisplayInternational() ? ' | Language' : '')),
                      subtitle: Text(getTranslationOfLocale(locale)),
                      onTap: () async {
                        final val = await showDialog<Locale?>(
                          context: context,
                          builder: (BuildContext context) {
                            final List<MapEntry<Locale?, String>> languageSettingValues =
                                Preferences.supportedLanguages.map((locale) {
                              return MapEntry<Locale?, String>(locale, getTranslationOfLocale(locale));
                            }).toList();
                            languageSettingValues.insert(0, MapEntry(null, getTranslationOfLocale()));
                            return RadioDialog<Locale?>(values: languageSettingValues, initialValue: locale);
                          },
                        );
                        await ref.read(localeNotifierProvider.notifier).setState(val);
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
                          await ref.read(themeModeNotifierProvider.notifier).setState(val);
                        }
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.abc),
                      trailing: IconButton(
                        tooltip: 'Google Fonts',
                        icon: const Icon(Icons.link),
                        onPressed: () => launchUrl(Uri.parse('https://fonts.google.com/')),
                      ),
                      title: Text(localizations.fontFamily),
                      subtitle: Text(fontFamily ?? localizations.systemSetting),
                      onTap: () async {
                        final currentTextTheme = Theme.of(context).textTheme;
                        final val = await showDialog<String?>(
                          context: context,
                          builder: (BuildContext context) {
                            return FontDialog(currentTextTheme: currentTextTheme, fontFamily: fontFamily);
                          },
                        );
                        await ref.read(fontFamilyNotifierProvider.notifier).setState(val);
                      },
                    ),
                  ],
                );
              }),
          LoadingBuilder<String>(
            future: ref.watch(bellSoundNotifierProvider),
            builder: (context, bellSoundPath) {
              return SettingsSection(
                title: localizations.scoreboard,
                action: TextButton(
                  onPressed: () async {
                    bellSoundPath = Env.bellSoundPath.fromString();
                    await ref.read(bellSoundNotifierProvider.notifier).setState(bellSoundPath);
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
                            return RadioDialog<String>(
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
                          await ref.read(bellSoundNotifierProvider.notifier).setState(bellSoundPath);
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
          LoadingBuilder<Duration>(
            future: ref.watch(networkTimeoutNotifierProvider),
            builder: (context, networkTimeout) {
              return LoadingBuilder<String>(
                future: ref.watch(apiUrlNotifierProvider),
                builder: (context, apiUrl) {
                  return LoadingBuilder<String>(
                    future: ref.watch(webSocketUrlNotifierProvider),
                    builder: (context, wsUrl) {
                      return SettingsSection(
                        title: localizations.network,
                        action: TextButton(
                          onPressed: () async {
                            apiUrl = Env.apiUrl.fromString();
                            await ref.read(apiUrlNotifierProvider.notifier).setState(apiUrl);

                            wsUrl = Env.webSocketUrl.fromString();
                            await ref.read(webSocketUrlNotifierProvider.notifier).setState(wsUrl);

                            const defaultNetworkTimeout = Duration(seconds: 10);
                            await ref.read(networkTimeoutNotifierProvider.notifier).setState(defaultNetworkTimeout);
                          },
                          child: Text(localizations.reset),
                        ),
                        children: [
                          ListTile(
                            subtitle: Text(apiUrl),
                            title: Text(localizations.apiUrl),
                            leading: const Icon(Icons.link),
                            onTap: () async {
                              final val = await showDialog<String>(
                                context: context,
                                builder: (BuildContext context) {
                                  return TextInputDialog(initialValue: apiUrl);
                                },
                              );
                              if (val != null) {
                                await ref.read(apiUrlNotifierProvider.notifier).setState(val);
                              }
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.link),
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
                                await ref.read(webSocketUrlNotifierProvider.notifier).setState(val);
                              }
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.running_with_errors),
                            title: Text(localizations.networkTimeout),
                            subtitle: Text(networkTimeout.formatSecondsAndMilliseconds()),
                            onTap: () async {
                              final val = await showDialog<Duration?>(
                                context: context,
                                builder: (BuildContext context) {
                                  return DurationDialog(
                                    initialValue: networkTimeout,
                                    maxValue: const Duration(hours: 1),
                                  );
                                },
                              );
                              if (val != null) {
                                await ref.read(networkTimeoutNotifierProvider.notifier).setState(val);
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
          // SettingsSection(
          //   title: localizations.services,
          //   action: TextButton(
          //     onPressed: () {},
          //     child: Text(localizations.reset),
          //   ),
          //   children: [],
          // ),
          SettingsSection(
            title: localizations.database,
            children: [
              ListTile(
                leading: const Icon(Icons.cloud_download),
                title: Text(localizations.exportDatabase),
                onTap: () => catchAsync(context, () async {
                  final dataManager = await ref.read(dataManagerNotifierProvider);
                  final sqlString = await dataManager.exportDatabase();
                  final fileName =
                      '${DateTime.now().toIso8601String().replaceAll(':', '-').replaceAll(RegExp(r'\.[0-9]{3}'), '')}-'
                      'PostgreSQL-wrestling_scoreboard-dump.sql';

                  if (kIsWeb) {
                    void saveFile(String text, String fileName) {
                      html.AnchorElement()
                        ..href = '${Uri.dataFromString(text, mimeType: 'application/sql', encoding: utf8)}'
                        ..download = fileName
                        ..style.display = 'none'
                        ..click();
                    }

                    saveFile(sqlString, fileName);
                  } else {
                    String? outputPath = (await file_selector.getSaveLocation(suggestedName: fileName))?.path;
                    if (outputPath != null) {
                      final outputFile = File(outputPath);
                      await outputFile.writeAsString(sqlString, encoding: const Utf8Codec());
                    }
                  }
                }),
              ),
              ListTile(
                leading: const Icon(Icons.settings_backup_restore),
                title: Text(localizations.resetDatabase),
                onTap: () => catchAsync(context, () async {
                  final dataManager = await ref.read(dataManagerNotifierProvider);
                  await dataManager.resetDatabase();
                  if (context.mounted) {
                    await showOkDialog(context: context, child: Text(localizations.actionSuccessful));
                  }
                }),
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: Text(localizations.restoreDefaultDatabase),
                onTap: () => catchAsync(context, () async {
                  final dataManager = await ref.read(dataManagerNotifierProvider);
                  await dataManager.restoreDefaultDatabase();
                  if (context.mounted) {
                    await showOkDialog(context: context, child: Text(localizations.actionSuccessful));
                  }
                }),
              ),
              ListTile(
                leading: const Icon(Icons.cloud_upload),
                title: Text(localizations.restoreDatabase),
                onTap: () => catchAsync(context, () async {
                  const typeGroup = file_selector.XTypeGroup(
                    label: 'SQL',
                    extensions: <String>['sql'],
                  );
                  file_selector.XFile? fileSelectorResult =
                      await file_selector.openFile(acceptedTypeGroups: [typeGroup]);
                  if (fileSelectorResult != null) {
                    File file = File(fileSelectorResult.path);
                    final dataManager = await ref.read(dataManagerNotifierProvider);
                    await dataManager.restoreDatabase(await file.readAsString(encoding: const Utf8Codec()));
                    if (context.mounted) {
                      await showOkDialog(context: context, child: Text(localizations.actionSuccessful));
                    }
                  }
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FontDialog extends StatefulWidget {
  final TextTheme currentTextTheme;
  final String? fontFamily;

  const FontDialog({super.key, required this.currentTextTheme, required this.fontFamily});

  @override
  State<StatefulWidget> createState() => FontDialogState();
}

class FontDialogState extends State<FontDialog> {
  final List<String> fontStock = [];
  final List<String> fontFamilies = [];

  @override
  void initState() {
    super.initState();
    fontStock.addAll(GoogleFonts.asMap().keys);
    lazyLoadFonts(0);
  }

  void lazyLoadFonts(int counter) async {
    if (counter >= fontStock.length) return;

    setState(() => fontFamilies.add(fontStock[counter]));
    await Future.delayed(const Duration(microseconds: 300));

    lazyLoadFonts(counter+1);
  }

  @override
  Widget build(BuildContext context) {
    return RadioDialog<String?>(
      itemCount: fontFamilies.length,
      builder: (index) {
        final fontFamily = fontFamilies[index];
        return (
          fontFamily,
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(fontFamily),
            IconButton(
              onPressed: () => showOkDialog(
                context: context,
                child: Text(
                  'ABCDEFGHIJKLMNOPQRSTUVWXYZ\nabcdefghijklmnopqrstuvwxyz',
                  style: GoogleFonts.getTextTheme(fontFamily, widget.currentTextTheme).headlineMedium,
                ),
              ),
              icon: const Icon(Icons.visibility),
            ),
          ])
        );
      },
      initialValue: widget.fontFamily,
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
