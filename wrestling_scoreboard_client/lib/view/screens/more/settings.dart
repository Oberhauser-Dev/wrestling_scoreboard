import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_selector/file_selector.dart' as file_selector;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_duration_picker/material_duration_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/duration.dart';
import 'package:wrestling_scoreboard_client/models/backup.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/utils/asset.dart';
import 'package:wrestling_scoreboard_client/utils/environment.dart';
import 'package:wrestling_scoreboard_client/utils/export.dart';
import 'package:wrestling_scoreboard_client/utils/io.dart';
import 'package:wrestling_scoreboard_client/view/widgets/auth.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/duration_picker.dart';
import 'package:wrestling_scoreboard_client/view/widgets/form.dart';
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
    final localizations = context.l10n;

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
        ref.watch(fontFamilyNotifierProvider),
      ]);

      return (results[0] as Locale?, results[1] as ThemeMode, results[2] as String?);
    }

    Future<(Duration, String, String, String?)> loadNetworkSettings() async {
      final results = await Future.wait([
        ref.watch(networkTimeoutNotifierProvider),
        ref.watch(apiUrlNotifierProvider),
        ref.watch(webSocketUrlNotifierProvider),
        ref.watch(webClientUrlNotifierProvider),
      ]);

      return (results[0] as Duration, results[1] as String, results[2] as String, results[3] as String?);
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
                      final List<MapEntry<Locale?, String>> languageSettingValues =
                          Preferences.supportedLanguages.map((locale) {
                            return MapEntry<Locale?, String>(locale, getTranslationOfLocale(locale));
                          }).toList();
                      languageSettingValues.insert(0, MapEntry(null, getTranslationOfLocale()));
                      await showRadioDialog<Locale?>(
                        context: context,
                        initialValue: locale,
                        values: languageSettingValues,
                        onSuccess: (value) => ref.read(localeNotifierProvider.notifier).setState(value),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.brush),
                    title: Text(localizations.themeMode),
                    subtitle: Text(getTranslationOfThemeMode(themeMode)),
                    onTap: () async {
                      final List<MapEntry<ThemeMode, String>> themeModeValues =
                          ThemeMode.values
                              .map((value) => MapEntry<ThemeMode, String>(value, getTranslationOfThemeMode(value)))
                              .toList();
                      await showRadioDialog<ThemeMode>(
                        context: context,
                        initialValue: themeMode,
                        values: themeModeValues,
                        onSuccess: (value) => ref.read(themeModeNotifierProvider.notifier).setState(value),
                      );
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

                      final List<String?> fontFamilies = [null];
                      fontFamilies.addAll(GoogleFonts.asMap().keys.toList());
                      await showRadioDialog<String?>(
                        context: context,
                        initialValue: fontFamily,
                        shrinkWrap: false,
                        itemCount: fontFamilies.length,
                        itemBuilder: (index) {
                          final fontFamily = fontFamilies[index];
                          final fontStyle =
                              fontFamily != null
                                  ? GoogleFonts.getTextTheme(fontFamily, currentTextTheme).headlineMedium
                                  : Theme.of(context).textTheme
                                      .apply(fontFamily: Typography.material2021().white.headlineMedium?.fontFamily)
                                      .headlineMedium;
                          return (
                            fontFamily,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(fontFamily ?? localizations.systemFont, style: fontStyle),
                                IconButton(
                                  onPressed:
                                      () => showOkDialog(
                                        context: context,
                                        child: Text(
                                          'ABCDEFGHIJKLMNOPQRSTUVWXYZ\nabcdefghijklmnopqrstuvwxyz',
                                          style: fontStyle,
                                        ),
                                      ),
                                  icon: const Icon(Icons.abc),
                                ),
                              ],
                            ),
                          );
                        },
                        onSuccess: (value) => ref.read(fontFamilyNotifierProvider.notifier).setState(value),
                      );
                    },
                  ),
                ],
              );
            },
          ),
          LoadingBuilder<String>(
            future: ref.watch(bellSoundNotifierProvider),
            builder: (context, bellSoundPath) {
              return LoadingBuilder<bool>(
                future: ref.watch(timeCountDownNotifierProvider),
                builder: (context, isTimeCountDown) {
                  return SettingsSection(
                    title: localizations.scoreboard,
                    action: TextButton(
                      onPressed: () async {
                        bellSoundPath = Env.bellSoundPath.fromString();
                        await ref.read(bellSoundNotifierProvider.notifier).setState(bellSoundPath);

                        isTimeCountDown = Env.timeCountDown.fromBool();
                        await ref.read(timeCountDownNotifierProvider.notifier).setState(isTimeCountDown);
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
                          final List<MapEntry<String, String>> bellSoundValues =
                              bellSoundPaths
                                  .asMap()
                                  .map((key, value) => MapEntry<String, String>(value, getBellNameOfPath(value)))
                                  .entries
                                  .toList();
                          if (context.mounted) {
                            await showRadioDialog<String>(
                              context: context,
                              values: bellSoundValues,
                              initialValue: bellSoundPath,
                              onChanged: (value) async {
                                final ap = AudioPlayer();
                                await ap.play(AssetSource(value));
                              },
                              onSuccess: (value) => ref.read(bellSoundNotifierProvider.notifier).setState(value),
                            );
                          }
                        },
                      ),
                      SwitchListTile(
                        title: Text(localizations.timeCountDown),
                        secondary: const Icon(Icons.timer),
                        value: isTimeCountDown,
                        onChanged: (val) async {
                          await ref.read(timeCountDownNotifierProvider.notifier).setState(val);
                        },
                      ),
                      // TODO option to overwrite boutConfigs
                      // ContentItem(title: localizations.durations, icon: Icons.timer, onTap: null),
                    ],
                  );
                },
              );
            },
          ),
          LoadingBuilder<Duration>(
            future: ref.watch(proposeApiImportDurationNotifierProvider),
            builder: (context, proposeApiImportDuration) {
              return LoadingBuilder<String?>(
                future: ref.watch(appDataDirectoryNotifierProvider),
                builder: (context, appDataDirectory) {
                  return SettingsSection(
                    title: localizations.services,
                    action: TextButton(
                      onPressed: () async {
                        proposeApiImportDuration = const Duration(days: 2);
                        await ref
                            .read(proposeApiImportDurationNotifierProvider.notifier)
                            .setState(proposeApiImportDuration);

                        await ref.read(appDataDirectoryNotifierProvider.notifier).resetState();
                      },
                      child: Text(localizations.reset),
                    ),
                    children: [
                      Restricted(
                        privilege: UserPrivilege.write,
                        child: ListTile(
                          leading: const Icon(Icons.timelapse),
                          title: Text(localizations.proposeApiImportDuration),
                          subtitle: Text(proposeApiImportDuration.formatDaysHoursMinutes(context)),
                          onTap: () async {
                            final val = await showDurationDialog(
                              context: context,
                              initialDuration: proposeApiImportDuration,
                              // TODO: Allow days in duration picker
                              mode: DurationPickerMode.hm,
                              maxValue: const Duration(days: 365),
                            );
                            if (val != null) {
                              await ref.read(proposeApiImportDurationNotifierProvider.notifier).setState(val);
                            }
                          },
                        ),
                      ),
                      // App data is not supported on web
                      if (!kIsWeb)
                        ListTile(
                          leading: const Icon(Icons.folder),
                          title: Text(localizations.appDataDirectory),
                          subtitle: Text(appDataDirectory ?? localizations.noneSelected),
                          onTap: () async {
                            final String? dirPath = await file_selector.getDirectoryPath();
                            if (dirPath != null) {
                              await ref.read(appDataDirectoryNotifierProvider.notifier).setState(dirPath);
                            }
                          },
                          trailing:
                              appDataDirectory == null
                                  ? null
                                  : IconButton(
                                    icon: Icon(Icons.folder_open),
                                    onPressed: () => launchUrl(Uri.parse('file:$appDataDirectory')),
                                  ),
                        ),
                    ],
                  );
                },
              );
            },
          ),
          LoadingBuilder<(Duration, String, String, String?)>(
            future: loadNetworkSettings(),
            builder: (context, networkSettings) {
              var (networkTimeout, apiUrl, wsUrl, webClientUrl) = networkSettings;
              return SettingsSection(
                title: localizations.network,
                action: TextButton(
                  onPressed: () async {
                    const defaultNetworkTimeout = Duration(seconds: 10);
                    await ref.read(networkTimeoutNotifierProvider.notifier).setState(defaultNetworkTimeout);

                    apiUrl = Env.apiUrl.fromString();
                    await ref.read(apiUrlNotifierProvider.notifier).setState(apiUrl);

                    wsUrl = Env.webSocketUrl.fromString();
                    await ref.read(webSocketUrlNotifierProvider.notifier).setState(wsUrl);

                    webClientUrl = Env.webClientUrl.fromString();
                    if (webClientUrl != null && webClientUrl!.isEmpty) {
                      webClientUrl = null;
                    }
                    await ref.read(webClientUrlNotifierProvider.notifier).setState(webClientUrl);
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
                  if (!kIsWeb)
                    ListTile(
                      leading: const Icon(Icons.link),
                      title: Text(localizations.webClientUrl),
                      subtitle: Text(webClientUrl ?? '-'),
                      onTap: () async {
                        final val = await showDialog<String?>(
                          context: context,
                          builder: (BuildContext context) {
                            return TextInputDialog(initialValue: webClientUrl);
                          },
                        );
                        await ref.read(webClientUrlNotifierProvider.notifier).setState(val);
                      },
                    ),
                  ListTile(
                    leading: const Icon(Icons.running_with_errors),
                    title: Text(localizations.networkTimeout),
                    subtitle: Text(networkTimeout.formatSecondsAndMilliseconds()),
                    onTap: () async {
                      final val = await showDurationDialog(
                        context: context,
                        initialDuration: networkTimeout,
                        maxValue: const Duration(hours: 1),
                      );
                      if (val != null) {
                        await ref.read(networkTimeoutNotifierProvider.notifier).setState(val);
                      }
                    },
                  ),
                ],
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
                  onTap:
                      () => catchAsync(context, () async {
                        final dataManager = await ref.read(dataManagerNotifierProvider);
                        final sqlString = await dataManager.exportDatabase();
                        await exportSQL(
                          fileBaseName:
                              '${MockableDateTime.now().toFileNameDateTimeFormat()}_wrestling_scoreboard-dump',
                          sqlString: sqlString,
                        );
                      }),
                ),
                ListTile(
                  leading: const Icon(Icons.settings_backup_restore),
                  title: Text(localizations.resetDatabase),
                  onTap:
                      () => catchAsync(context, () async {
                        final result = await showOkCancelDialog(
                          context: context,
                          child: Text(localizations.warningOverrideDatabase),
                        );
                        if (result && context.mounted) {
                          final dataManager = await ref.read(dataManagerNotifierProvider);
                          await dataManager.resetDatabase();
                          if (context.mounted) {
                            await showOkDialog(context: context, child: Text(localizations.actionSuccessful));
                          }
                        }
                      }),
                ),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(localizations.restoreDefaultDatabase),
                  onTap:
                      () => catchAsync(context, () async {
                        final result = await showOkCancelDialog(
                          context: context,
                          child: Text(localizations.warningOverrideDatabase),
                        );
                        if (result && context.mounted) {
                          final dataManager = await ref.read(dataManagerNotifierProvider);
                          await dataManager.restoreDefaultDatabase();
                          if (context.mounted) {
                            await showOkDialog(context: context, child: Text(localizations.actionSuccessful));
                          }
                        }
                      }),
                ),
                ListTile(
                  leading: const Icon(Icons.cloud_upload),
                  title: Text(localizations.restoreDatabase),
                  onTap:
                      () => catchAsync(context, () async {
                        const typeGroup = file_selector.XTypeGroup(label: 'SQL', extensions: <String>['sql']);
                        final file_selector.XFile? fileSelectorResult = await file_selector.openFile(
                          acceptedTypeGroups: [typeGroup],
                        );
                        if (fileSelectorResult != null) {
                          final dataManager = await ref.read(dataManagerNotifierProvider);
                          await dataManager.restoreDatabase(
                            await fileSelectorResult.readAsString(encoding: const Utf8Codec()),
                          );
                          if (context.mounted) {
                            await showOkDialog(context: context, child: Text(localizations.actionSuccessful));
                          }
                        }
                      }),
                ),
                // Automatic Backup is not supported on web, as we cannot save it to the device
                if (!kIsWeb)
                  LoadingBuilder<bool>(
                    future: ref.watch(backupEnabledNotifierProvider),
                    builder: (context, isBackupEnabled) {
                      return LoadingBuilder<List<BackupRule>>(
                        future: ref.watch(backupRulesNotifierProvider),
                        builder: (context, backupRules) {
                          return ExpansionTile(
                            leading: const Icon(Icons.cloud_download),
                            title: Text(localizations.localBackup),
                            trailing: Switch(
                              value: isBackupEnabled,
                              onChanged: (enableBackup) async {
                                await ref.read(backupEnabledNotifierProvider.notifier).setState(enableBackup);
                              },
                            ),
                            children: [
                              ...backupRules.map(
                                (backupRule) => ListTile(
                                  title: Text(backupRule.name),
                                  subtitle: Text(
                                    '${localizations.saveEvery}: ${backupRule.period.formatDaysHoursMinutes(context)} | '
                                    '${localizations.deleteAfter}: ${backupRule.deleteAfter.formatDaysHoursMinutes(context)}',
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () async {
                                      await ref
                                          .read(backupRulesNotifierProvider.notifier)
                                          .setState(backupRules.where((element) => element != backupRule).toList());
                                    },
                                  ),
                                  onTap: () async {
                                    final newBackupRule = await showDialog<BackupRule>(
                                      context: context,
                                      builder:
                                          (BuildContext context) => BackupRuleEditDialog(initialBackupRule: backupRule),
                                    );
                                    if (newBackupRule != null) {
                                      await ref.read(backupRulesNotifierProvider.notifier).setState([
                                        ...backupRules.where((element) => element != backupRule),
                                        newBackupRule,
                                      ]);
                                    }
                                  },
                                ),
                              ),
                              ListTile(
                                leading: Icon(Icons.add),
                                title: Text(localizations.add),
                                onTap: () async {
                                  final newBackupRule = await showDialog<BackupRule>(
                                    context: context,
                                    builder: (BuildContext context) => BackupRuleEditDialog(),
                                  );
                                  if (newBackupRule != null) {
                                    await ref.read(backupRulesNotifierProvider.notifier).setState([
                                      ...backupRules,
                                      newBackupRule,
                                    ]);
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
              ],
            ),
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
    return Column(
      children: [
        ListTile(title: Text(title), trailing: action),
        Card(child: Column(children: ListTile.divideTiles(context: context, tiles: children).toList())),
      ],
    );
  }
}

class BackupRuleEditDialog extends StatefulWidget {
  final BackupRule? initialBackupRule;

  const BackupRuleEditDialog({super.key, this.initialBackupRule});

  @override
  State<BackupRuleEditDialog> createState() => _BackupRuleEditDialogState();
}

class _BackupRuleEditDialogState extends State<BackupRuleEditDialog> {
  late String _name;
  late Duration _period;
  late Duration _deleteAfter;

  @override
  void initState() {
    super.initState();
    _name = widget.initialBackupRule?.name ?? '';
    _period = widget.initialBackupRule?.period ?? Duration.zero;
    _deleteAfter = widget.initialBackupRule?.deleteAfter ?? Duration.zero;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    return OkCancelDialog<BackupRule>(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextInput(
            label: localizations.name,
            initialValue: _name,
            isMandatory: true,
            onChanged: (value) => _name = value,
          ),
          Padding(padding: const EdgeInsets.only(top: 8.0), child: Text(localizations.saveEvery)),
          DurationFormField(
            initialValue: _period,
            maxValue: Duration(days: 10000),
            onChange: (value) {
              if (value != null) _period = value;
            },
            showDays: true,
            showHours: true,
            showMinutes: true,
            showSeconds: false,
          ),
          Padding(padding: const EdgeInsets.only(top: 8.0), child: Text(localizations.deleteAfter)),
          DurationFormField(
            initialValue: _deleteAfter,
            maxValue: Duration(days: 10000),
            onChange: (value) {
              if (value != null) _deleteAfter = value;
            },
            showDays: true,
            showHours: true,
            showMinutes: true,
            showSeconds: false,
          ),
        ],
      ),
      getResult: () => BackupRule(name: _name, period: _period, deleteAfter: _deleteAfter),
    );
  }
}
