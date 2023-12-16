import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_client/ui/components/responsive_container.dart';
import 'package:wrestling_scoreboard_client/ui/more/about.dart';
import 'package:wrestling_scoreboard_client/ui/more/imprint.dart';
import 'package:wrestling_scoreboard_client/ui/more/settings/settings.dart';

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

    return ResponsiveScrollView(
      child: Card(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(localizations.settings),
              onTap: () => navigateTo(const CustomSettingsScreen()),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info),
              title: Text(localizations.imprint),
              onTap: () => navigateTo(const ImprintScreen()),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info),
              title: Text(localizations.about),
              onTap: () => navigateTo(const AboutScreen()),
            ),
          ],
        ),
      ),
    );
  }
}
