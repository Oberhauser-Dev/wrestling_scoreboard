import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';
import 'package:wrestling_scoreboard_client/view/screens/more/about.dart';
import 'package:wrestling_scoreboard_client/view/screens/more/imprint.dart';
import 'package:wrestling_scoreboard_client/view/screens/more/settings/settings.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    navigateTo(Widget screen) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => screen,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(localizations.more)),
      body: ResponsiveScrollView(
        child: Card(
          child: Column(
            children: ListTile.divideTiles(
              context: context,
              tiles: [
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: Text(localizations.settings),
                  onTap: () => navigateTo(const CustomSettingsScreen()),
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: Text(localizations.imprint),
                  onTap: () => navigateTo(const ImprintScreen()),
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: Text(localizations.about),
                  onTap: () => navigateTo(const AboutScreen()),
                ),
              ],
            ).toList(),
          ),
        ),
      ),
    );
  }
}
