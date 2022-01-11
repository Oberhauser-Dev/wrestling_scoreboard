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
  static final StreamController<String> onChangeWsUrl = StreamController.broadcast();
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
  String? _bellSound = Settings.getValue<String>(CustomSettingsScreen.keyBellSound, 'assets/audio/BoxingBell.mp3');

  @override
  Widget build(BuildContext context) {
    // var value = true;
    
    bool isDisplayInternational() {
      if (Localizations.localeOf(context).languageCode == 'en') return false;
      return true;
    }

    String getTranslationOfLocale([String? locale]) {
      switch (locale) {
        case 'de':
        case 'de_DE':
          return AppLocalizations.of(context)!.de_DE + (isDisplayInternational() ? ' | German' : '');
        case 'en':
        case 'en_US':
          return AppLocalizations.of(context)!.en_US + (isDisplayInternational() ? ' | English (US)' : '');
        default:
          return AppLocalizations.of(context)!.systemSetting + (isDisplayInternational() ? ' | System setting' : '');
      }
    }

    final Map<String?, String> languageSettingValues =
        CustomSettingsScreen.supportedLanguages.map((key, value) => MapEntry(key, getTranslationOfLocale(key)));
    languageSettingValues.addEntries([MapEntry(null, getTranslationOfLocale())]);

    return SettingsScreen(title: AppLocalizations.of(context)!.settings, children: [
      SettingsGroup(
        title: 'General',
        children: [
          DropDownSettingsTile<String>(
            settingKey: CustomSettingsScreen.keyLocale,
            title: AppLocalizations.of(context)!.language + (isDisplayInternational() ? ' | Language' : ''),
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
            title: AppLocalizations.of(context)!.apiUrl,
            settingKey: CustomSettingsScreen.keyApiUrl,
            // leading: const Icon(Icons.storage),
            initialValue: env(apiUrl, fallBack: 'http://localhost:8080/api'),
            onChange: (String? val) {
              if(val != null) CustomSettingsScreen.onChangeApiUrl.add(val);
            },
          ),
          TextInputSettingsTile(
            title: AppLocalizations.of(context)!.wsUrl,
            settingKey: CustomSettingsScreen.keyWsUrl,
            // leading: const Icon(Icons.storage),
            initialValue: env(webSocketUrl, fallBack: 'ws://localhost:8080/ws'),
            onChange: (String? val) {
              if(val != null) CustomSettingsScreen.onChangeWsUrl.add(val);
            },
          ),
          FutureBuilder<List<String>>(
            future: getAssetList(prefix: '', filetype: '.mp3'),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                final bellSoundValues = snapshot.data!;
                return DropDownSettingsTile<String>(
                  settingKey: CustomSettingsScreen.keyBellSound,
                  title: AppLocalizations.of(context)!.bellSound,
                  leading: const Icon(Icons.audiotrack),
                  selected: _bellSound,
                  values: bellSoundValues.asMap().map((key, value) => MapEntry(value, value.split('/').last.replaceAll('.mp3', ''))),
                  onChange: (String? val) {
                    setState(() {
                      _bellSound = val;
                    });
                    if (val != null) {
                      CustomSettingsScreen.onChangeBellSound.add(val);
                      HornSound().play();
                      HornSound().dispose();
                    }
                  },
                );
              }
              return const SizedBox();
          },),
        ],
      ),
    ]);
  }
}
