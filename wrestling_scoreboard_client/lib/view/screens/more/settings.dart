import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_selector/file_selector.dart' as file_selector;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wrestling_scoreboard_client/localization/duration.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/utils/asset.dart';
import 'package:wrestling_scoreboard_client/utils/environment.dart';
import 'package:wrestling_scoreboard_client/utils/export.dart';
import 'package:wrestling_scoreboard_client/view/widgets/auth.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaffold.dart';
import 'package:wrestling_scoreboard_common/common.dart';

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
      final results = await Future.wait([
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
                var (locale, themeMode, fontFamily) = generalSettings;

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
                            return _FontSelectionDialog(currentTextTheme: currentTextTheme, fontFamily: fontFamily);
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
          Restricted(
            privilege: UserPrivilege.write,
            child: LoadingBuilder<Duration>(
                future: ref.watch(proposeApiImportDurationNotifierProvider),
                builder: (context, proposeApiImportDuration) {
                  return SettingsSection(
                    title: localizations.services,
                    action: TextButton(
                      onPressed: () async {
                        proposeApiImportDuration = const Duration(days: 2);
                        await ref
                            .read(proposeApiImportDurationNotifierProvider.notifier)
                            .setState(proposeApiImportDuration);
                      },
                      child: Text(localizations.reset),
                    ),
                    children: [
                      ListTile(
                        leading: const Icon(Icons.timelapse),
                        title: Text(localizations.proposeApiImportDuration),
                        subtitle: Text(proposeApiImportDuration.formatDaysHoursMinutes(context)),
                        onTap: () async {
                          final val = await showDialog<Duration?>(
                            context: context,
                            builder: (BuildContext context) {
                              // TODO: Allow days in duration picker
                              return DurationDialog(
                                initialValue: proposeApiImportDuration,
                                maxValue: const Duration(days: 365),
                              );
                            },
                          );
                          if (val != null) {
                            await ref.read(proposeApiImportDurationNotifierProvider.notifier).setState(val);
                          }
                        },
                      ),
                    ],
                  );
                }),
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
          Restricted(
            privilege: UserPrivilege.admin,
            child: SettingsSection(
              title: localizations.database,
              children: [
                ListTile(
                  leading: const Icon(Icons.cloud_download),
                  title: Text(localizations.exportDatabase),
                  onTap: () => catchAsync(context, () async {
                    final dataManager = await ref.read(dataManagerNotifierProvider);
                    final sqlString = await dataManager.exportDatabase();
                    final fileBaseName =
                        '${DateTime.now().toIso8601String().replaceAll(':', '-').replaceAll(RegExp(r'\.[0-9]{3}'), '')}-'
                        'PostgreSQL-wrestling_scoreboard-dump';
                    await exportSQL(fileBaseName: fileBaseName, sqlString: sqlString);
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
          ),
        ],
      ),
    );
  }
}

class _FontSelectionDialog extends StatelessWidget {
  final TextTheme currentTextTheme;
  final String? fontFamily;

  const _FontSelectionDialog({required this.currentTextTheme, required this.fontFamily});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final List<String?> fontFamilies = [null];
    fontFamilies.addAll(GoogleFonts.asMap().keys.toList());
    return RadioDialog<String?>(
      shrinkWrap: false,
      itemCount: fontFamilies.length,
      builder: (index) {
        final fontFamily = fontFamilies[index];
        final fontStyle = fontFamily != null
            ? GoogleFonts.getTextTheme(fontFamily, currentTextTheme).headlineMedium
            : Theme.of(context)
                .textTheme
                .apply(fontFamily: Typography.material2021().white.headlineMedium?.fontFamily)
                .headlineMedium;
        return (
          fontFamily,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(fontFamily ?? localizations.systemFont, style: fontStyle),
              IconButton(
                onPressed: () => showOkDialog(
                  context: context,
                  child: Text('ABCDEFGHIJKLMNOPQRSTUVWXYZ\nabcdefghijklmnopqrstuvwxyz', style: fontStyle),
                ),
                icon: const Icon(Icons.abc),
              ),
            ],
          ),
        );
      },
      initialValue: fontFamily,
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
