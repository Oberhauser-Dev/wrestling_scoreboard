import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:wrestling_scoreboard/util/asset.dart';
import 'package:wrestling_scoreboard/util/audio/audio.dart';
import 'package:wrestling_scoreboard/util/environment.dart';

class CustomSettingsScreen extends StatefulWidget {
  static const keyLocale = 'locale';
  static const keyApiUrl = 'api-url';
  static const keyWsUrl = 'ws-url';
  static const keyBellSound = 'bell-sound';

  static final StreamController<Locale?> onChangeLocale = StreamController.broadcast();
  static final StreamController<String> onChangeApiUrl = StreamController.broadcast();
  static final StreamController<String> onChangeWsUrlWebSocket = StreamController.broadcast();
  static final StreamController<String> onChangeBellSound = StreamController.broadcast();

  static final supportedLanguages = {
    'en_US': const Locale('en', 'US'),
    'de_DE': const Locale('de', 'DE'),
  };

  const CustomSettingsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CustomSettingsScreenState();
}

class CustomSettingsScreenState extends State<CustomSettingsScreen> {
  String? _locale = Settings.getValue<String>(CustomSettingsScreen.keyLocale, null);
  String _bellSoundPath = Settings.getValue<String>(CustomSettingsScreen.keyBellSound, env(bellSoundPath))!;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    // var value = true;

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

    final Map<String?, String> languageSettingValues =
        CustomSettingsScreen.supportedLanguages.map((key, value) => MapEntry(key, getTranslationOfLocale(key)));
    languageSettingValues.addEntries([MapEntry(null, getTranslationOfLocale())]);

    return SettingsScreen(title: localizations.settings, children: [
      SettingsGroup(
        title: 'General',
        children: [
          DropDownSettingsTile<String>(
            settingKey: CustomSettingsScreen.keyLocale,
            title: localizations.language + (isDisplayInternational() ? ' | Language' : ''),
            subtitle: getTranslationOfLocale(_locale),
            leading: const Icon(Icons.translate),
            selected: _locale,
            values: languageSettingValues,
            onChange: (String? val) {
              CustomSettingsScreen.onChangeLocale.add(CustomSettingsScreen.supportedLanguages[val]);
              setState(() {
                _locale = val;
              });
            },
          ),
          // SwitchSettingsTile(
          //   title: 'Use fingerprint (Fake setting)',
          //   leading: const Icon(Icons.fingerprint),
          //   defaultValue: value,
          //   onChange: (bool? value) {},
          //   settingKey: 'key-fingerprint',
          // ),
          TextInputSettingsTile(
            title: localizations.apiUrl,
            settingKey: CustomSettingsScreen.keyApiUrl,
            // leading: const Icon(Icons.storage),
            initialValue: env(apiUrl),
            onChange: (String? val) {
              if (val != null) CustomSettingsScreen.onChangeApiUrl.add(val);
            },
          ),
          TextInputSettingsTile(
            title: localizations.wsUrl,
            settingKey: CustomSettingsScreen.keyWsUrl,
            // leading: const Icon(Icons.storage),
            initialValue: env(webSocketUrl),
            onChange: (String? val) {
              if (val != null) CustomSettingsScreen.onChangeWsUrlWebSocket.add(val);
            },
          ),
          FutureBuilder<List<String>>(
            future: getAssetList(prefix: '', filetype: '.mp3'),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                final bellSoundValues = snapshot.data!;
                return DropDownSettingsTile<String>(
                  settingKey: CustomSettingsScreen.keyBellSound,
                  title: localizations.bellSound,
                  leading: const Icon(Icons.audiotrack),
                  selected: _bellSoundPath,
                  values: bellSoundValues
                      .asMap()
                      .map((key, value) => MapEntry(value, value.split('/').last.replaceAll('.mp3', ''))),
                  onChange: (String? val) {
                    if (val != null) {
                      setState(() {
                        _bellSoundPath = val;
                      });
                      CustomSettingsScreen.onChangeBellSound.add(val);
                      HornSound().play();
                      HornSound().dispose();
                    }
                  },
                );
              }
              return const SizedBox();
            },
          ),
          TextButton(
              onPressed: () {
                setState(() {
                  _locale = null;
                  Settings.setValue<String>(CustomSettingsScreen.keyLocale, _locale);
                  CustomSettingsScreen.onChangeLocale.add(null);

                  final defaultApiUrl = env(apiUrl);
                  Settings.setValue<String>(CustomSettingsScreen.keyApiUrl, defaultApiUrl);
                  CustomSettingsScreen.onChangeApiUrl.add(defaultApiUrl);

                  final defaultWsUrl = env(webSocketUrl);
                  Settings.setValue<String>(CustomSettingsScreen.keyWsUrl, defaultWsUrl);
                  CustomSettingsScreen.onChangeWsUrlWebSocket.add(defaultWsUrl);

                  _bellSoundPath = env(bellSoundPath);
                  Settings.setValue<String>(CustomSettingsScreen.keyBellSound, _bellSoundPath);
                  CustomSettingsScreen.onChangeBellSound.add(_bellSoundPath);
                });
              },
              child: Text(localizations.reset)),
        ],
      ),
    ]);
  }
}
