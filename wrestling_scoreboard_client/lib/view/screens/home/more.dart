import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/view/screens/more/about.dart';
import 'package:wrestling_scoreboard_client/view/screens/more/imprint.dart';
import 'package:wrestling_scoreboard_client/view/screens/more/privacy_policy.dart';
import 'package:wrestling_scoreboard_client/view/screens/more/settings/settings.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaffold.dart';

class MoreScreen extends StatelessWidget {
  static const route = 'more';

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

    return WindowStateScaffold(
      appBarTitle: Text(localizations.more),
      body: ResponsiveScrollView(
        child: Card(
          child: Column(
            children: ListTile.divideTiles(
              context: context,
              tiles: [
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: Text(localizations.settings),
                  onTap: () => context.go('/${MoreScreen.route}/${CustomSettingsScreen.route}'),
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: Text(localizations.imprint),
                  onTap: () => context.go('/${MoreScreen.route}/${ImprintScreen.route}'),
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: Text(localizations.about),
                  onTap: () => context.go('/${MoreScreen.route}/${AboutScreen.route}'),
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const Icon(Icons.policy),
                  title: Text(localizations.privacy_policy),
                  onTap: () => context.go('/${MoreScreen.route}/${PrivacyPolicyScreen.route}'),
                ),
              ],
            ).toList(),
          ),
        ),
      ),
    );
  }
}
