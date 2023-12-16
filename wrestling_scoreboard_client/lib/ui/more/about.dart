import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wrestling_scoreboard_client/main.dart';
import 'package:wrestling_scoreboard_client/ui/components/responsive_container.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
      appBar: AppBar(title: Text(localizations.about)),
      body: ResponsiveColumn(
        children: [
          Card(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                        title: Text(
                      localizations.about_Application,
                      style: Theme.of(context).textTheme.headlineSmall,
                    )),
                    ListTile(
                      leading: Image.asset('assets/images/icons/launcher.png'),
                      title: Text(localizations.appName),
                      subtitle: Text('Version: ${packageInfo.version}+${packageInfo.buildNumber}'),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.list),
                      title: Text(localizations.about_Changelog),
                      onTap: () => launchUrl(Uri.parse(
                        'https://github.com/Oberhauser-Dev/wrestling_scoreboard/blob/main/CHANGELOG.md',
                      )),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.api),
                      title: Text(localizations.about_Licenses),
                      onTap: () => navigateTo(LicensePage(
                        applicationName: localizations.appName,
                        applicationIcon: Image.asset('assets/images/icons/launcher.png'),
                        applicationVersion: '${packageInfo.version}+${packageInfo.buildNumber}',
                      )),
                    ),
                  ],
                )),
          ),
          Card(
              child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ListTile(
                          title: Text(
                        localizations.about_Contact,
                        style: Theme.of(context).textTheme.headlineSmall,
                      )),
                      ListTile(
                        title: MarkdownBody(
                          shrinkWrap: true,
                          selectable: true,
                          data: localizations.about_contact_phrase,
                          onTapLink: (text, href, title) => launchUrl(Uri.parse(href!)),
                        ),
                      ),
                    ],
                  ))),
          Card(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ListTile(
                      title: Text(
                    localizations.about_Development,
                    style: Theme.of(context).textTheme.headlineSmall,
                  )),
                  ListTile(
                    title: MarkdownBody(
                      shrinkWrap: true,
                      selectable: true,
                      data: localizations.about_development_phrase,
                      onTapLink: (text, href, title) => launchUrl(Uri.parse(href!)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
