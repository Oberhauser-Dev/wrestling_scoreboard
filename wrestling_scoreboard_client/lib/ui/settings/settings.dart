import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:wrestling_scoreboard_client/ui/components/ok_dialog.dart';
import 'package:wrestling_scoreboard_client/ui/settings/preferences.dart';
import 'package:wrestling_scoreboard_client/util/asset.dart';
import 'package:wrestling_scoreboard_client/util/audio/audio.dart';
import 'package:wrestling_scoreboard_client/util/environment.dart';

class CustomSettingsScreen extends StatefulWidget {
  const CustomSettingsScreen({super.key});

  @override
  State<StatefulWidget> createState() => CustomSettingsScreenState();
}

class CustomSettingsScreenState extends State<CustomSettingsScreen> {
  String? _locale;
  ThemeMode _themeMode = ThemeMode.system;
  String _wsUrl = Env.webSocketUrl.fromString();
  String _apiUrl = Env.apiUrl.fromString();
  String _bellSoundPath = Env.bellSoundPath.fromString();

  @override
  void initState() {
    Preferences.getString(Preferences.keyLocale).then((value) {
      if (value != null) {
        setState(() {
          _locale = value;
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
    Preferences.getString(Preferences.keyBellSound).then((value) {
      if (value != null) {
        setState(() {
          _bellSoundPath = value;
        });
      }
    });
    Preferences.getString(Preferences.keyApiUrl).then((value) {
      if (value != null) {
        setState(() {
          _apiUrl = value;
        });
      }
    });
    Preferences.getString(Preferences.keyWsUrl).then((value) {
      if (value != null) {
        setState(() {
          _wsUrl = value;
        });
      }
    });
    super.initState();
  }

  String getBellNameOfPath(String value) => value.split('/').last.replaceAll('.mp3', '');

  @override
  Widget build(BuildContext context) {
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
      body: SettingsList(
          platform: Theme.of(context).platform == TargetPlatform.windows
              ? DevicePlatform.web
              : null, // Use web theme for windows
          sections: [
            SettingsSection(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(localizations.general),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _locale = null;
                          Preferences.setString(Preferences.keyLocale, _locale);
                          Preferences.onChangeLocale.add(null);

                          _themeMode = ThemeMode.system;
                          Preferences.setString(Preferences.keyThemeMode, _themeMode.name);
                          Preferences.onChangeThemeMode.add(_themeMode);

                          _apiUrl = Env.apiUrl.fromString();
                          Preferences.setString(Preferences.keyApiUrl, _apiUrl);
                          Preferences.onChangeApiUrl.add(_apiUrl);

                          _wsUrl = Env.webSocketUrl.fromString();
                          Preferences.setString(Preferences.keyWsUrl, _wsUrl);
                          Preferences.onChangeWsUrlWebSocket.add(_wsUrl);

                          _bellSoundPath = Env.bellSoundPath.fromString();
                          Preferences.setString(Preferences.keyBellSound, _bellSoundPath);
                          Preferences.onChangeBellSound.add(_bellSoundPath);
                        });
                      },
                      child: Text(localizations.reset))
                ],
              ),
              tiles: [
                SettingsTile.navigation(
                  title: Text(localizations.language + (isDisplayInternational() ? ' | Language' : '')),
                  leading: const Icon(Icons.translate),
                  value: Text(getTranslationOfLocale(_locale)),
                  onPressed: (context) async {
                    final val = await showDialog<String?>(
                      context: context,
                      builder: (BuildContext context) {
                        final List<MapEntry<String?, String>> languageSettingValues = Preferences.supportedLanguages
                            .map((key, value) => MapEntry<String?, String>(key, getTranslationOfLocale(key)))
                            .entries
                            .toList();
                        languageSettingValues.add(MapEntry(null, getTranslationOfLocale()));
                        return RadioDialog<String>(values: languageSettingValues, initialValue: _locale);
                      },
                    );
                    Preferences.onChangeLocale.add(Preferences.supportedLanguages[val]);
                    await Preferences.setString(Preferences.keyLocale, val);
                    setState(() {
                      _locale = val;
                    });
                  },
                ),
                SettingsTile.navigation(
                  title: Text(localizations.themeMode),
                  leading: const Icon(Icons.brush),
                  value: Text(getTranslationOfThemeMode(_themeMode)),
                  onPressed: (context) async {
                    final val = await showDialog<ThemeMode>(
                      context: context,
                      builder: (BuildContext context) {
                        final List<MapEntry<ThemeMode, String>> themeModeValues = ThemeMode.values
                            .map((value) => MapEntry<ThemeMode, String>(value, getTranslationOfThemeMode(value)))
                            .toList();
                        return RadioDialog<ThemeMode>(values: themeModeValues, initialValue: _themeMode);
                      },
                    );
                    if (val != null) {
                      Preferences.onChangeThemeMode.add(val);
                      await Preferences.setString(Preferences.keyThemeMode, val.name);
                      setState(() {
                        _themeMode = val;
                      });
                    }
                  },
                ),
                SettingsTile.navigation(
                  title: Text(localizations.apiUrl),
                  leading: const Icon(Icons.storage),
                  value: Text(_apiUrl),
                  onPressed: (context) async {
                    final val = await showDialog<String>(
                      context: context,
                      builder: (BuildContext context) {
                        return TextInputDialog(initialValue: _apiUrl);
                      },
                    );
                    if (val != null) {
                      Preferences.onChangeApiUrl.add(val);
                      await Preferences.setString(Preferences.keyApiUrl, val);
                      setState(() {
                        _apiUrl = val;
                      });
                    }
                  },
                ),
                SettingsTile.navigation(
                  title: Text(localizations.wsUrl),
                  leading: const Icon(Icons.storage),
                  value: Text(_wsUrl),
                  onPressed: (context) async {
                    final val = await showDialog<String?>(
                      context: context,
                      builder: (BuildContext context) {
                        return TextInputDialog(initialValue: _wsUrl);
                      },
                    );
                    if (val != null) {
                      Preferences.onChangeWsUrlWebSocket.add(val);
                      await Preferences.setString(Preferences.keyWsUrl, val);
                      setState(() {
                        _wsUrl = val;
                      });
                    }
                  },
                ),
                SettingsTile.navigation(
                  title: Text(localizations.bellSound),
                  leading: const Icon(Icons.audiotrack),
                  value: Text(getBellNameOfPath(_bellSoundPath)),
                  onPressed: (context) async {
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
                            initialValue: _bellSoundPath,
                            onChanged: (value) async {
                              if (value != null) {
                                await HornSound.source(value).play();
                              }
                            },
                          );
                        },
                      );
                      if (val != null) {
                        Preferences.onChangeBellSound.add(val);
                        await Preferences.setString(Preferences.keyBellSound, val);
                        setState(() {
                          _bellSoundPath = val;
                        });
                      }
                    }
                  },
                ),
                // TODO option to overwrite boutConfigs
                // ContentItem(title: localizations.durations, icon: Icons.timer, onTap: null),
              ],
            ),
          ]),
    );
  }
}

class TextInputDialog extends StatelessWidget {
  final String? initialValue;

  const TextInputDialog({required this.initialValue, super.key});

  @override
  Widget build(BuildContext context) {
    String? result;
    return OkDialog(
        child: TextFormField(
          initialValue: initialValue,
          onChanged: (value) => result = value,
        ),
        getResult: () => result);
  }
}

class RadioDialog<T> extends StatefulWidget {
  final List<MapEntry<T?, String>> values;
  final T? initialValue;
  final void Function(T? value)? onChanged;

  const RadioDialog({
    super.key,
    required this.values,
    required this.initialValue,
    this.onChanged,
  });

  @override
  State<RadioDialog<T>> createState() => _RadioDialogState<T>();
}

class _RadioDialogState<T> extends State<RadioDialog<T>> {
  T? result;

  @override
  void initState() {
    result = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OkDialog<T?>(
        child: ListView.builder(
          key: Key(result.toString()),
          shrinkWrap: true,
          itemCount: widget.values.length,
          itemBuilder: (context, index) {
            final entry = widget.values[index];
            return RadioListTile<T?>(
              value: entry.key,
              groupValue: result,
              onChanged: (v) {
                if (widget.onChanged != null) widget.onChanged!(v);
                setState(() {
                  result = v;
                });
              },
              title: Text(entry.value),
            );
          },
        ),
        getResult: () => result);
  }
}
