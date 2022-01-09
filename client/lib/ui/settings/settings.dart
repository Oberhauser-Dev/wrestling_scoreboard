import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class CustomSettingsScreen extends StatefulWidget {
  static const keyLocale = 'locale';
  static const keyApiUrl = 'api-url';
  static const keyWsUrl = 'ws-url';

  static final StreamController<Locale?> onChangeLocale = StreamController.broadcast();
  static final StreamController<String> onChangeApiUrl = StreamController.broadcast();
  static final StreamController<String> onChangeWsUrl = StreamController.broadcast();

  static final supportedLanguages = {
    'en_US': const Locale('en', 'US'),
    'de_DE': const Locale('de', 'DE'),
  };

  const CustomSettingsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CustomSettingsScreenState();
}

class CustomSettingsScreenState extends State<CustomSettingsScreen> {
  String? _locale;

  @override
  Widget build(BuildContext context) {
    var value = true;
    
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
            // leading: Icon(Icons.language),
            selected: _locale,
            values: languageSettingValues,
            onChange: (String? val) {
              CustomSettingsScreen.onChangeLocale.add(CustomSettingsScreen.supportedLanguages[val]);
              setState(() {
                _locale = val;
              });
            },
          ),
          SwitchSettingsTile(
            title: 'Use fingerprint (Fake setting)',
            leading: const Icon(Icons.fingerprint),
            defaultValue: value,
            onChange: (bool? value) {},
            settingKey: 'key-fingerprint',
          ),
          TextInputSettingsTile(
            title: AppLocalizations.of(context)!.apiUrl,
            settingKey: CustomSettingsScreen.keyApiUrl,
          ),
        ],
      ),
    ]);
  }
}
