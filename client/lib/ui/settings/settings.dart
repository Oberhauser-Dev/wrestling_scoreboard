import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool value = true;

    return SettingsScreen(children: [
      SettingsGroup(
        title: 'General',
        children: [
          DropDownSettingsTile<int>(
            settingKey: 'key-language',
            title: 'Language (Not implemented yet)',
            subtitle: 'English',
            // leading: Icon(Icons.language),
            selected: 0,
            values: const <int, String>{
              0: 'English',
              1: 'German',
            },
            onChange: (int val) {},
          ),
          SwitchSettingsTile(
            title: 'Use fingerprint (Fake setting)',
            leading: const Icon(Icons.fingerprint),
            defaultValue: value,
            onChange: (bool value) {},
            settingKey: 'key-fingerprint',
          ),
        ],
      ),
    ]);
  }
}
