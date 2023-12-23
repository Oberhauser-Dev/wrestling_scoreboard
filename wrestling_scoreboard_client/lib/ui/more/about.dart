import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:wrestling_scoreboard_client/main.dart';
import 'package:wrestling_scoreboard_client/ui/components/card.dart';
import 'package:wrestling_scoreboard_client/ui/components/responsive_container.dart';

const loadCompleteChangelog = false;

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<String> _loadChangelog() async {
    if (loadCompleteChangelog) {
      final globalChangelogUrl =
          Uri.https('raw.githubusercontent.com', '/Oberhauser-Dev/wrestling_scoreboard/main/CHANGELOG.md');
      return http.read(globalChangelogUrl);
    } else {
      return rootBundle.loadString('CHANGELOG.md');
    }
  }

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
          PaddedCard(
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
                  onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      actions: [
                        TextButton(
                          child: Text(localizations.ok),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                      content: FutureBuilder(
                        future: _loadChangelog(),
                        builder: (context, snapshot) {
                          return snapshot.hasData
                              ? SingleChildScrollView(
                                  child: MarkdownBody(
                                    listItemCrossAxisAlignment: MarkdownListItemCrossAxisAlignment.start,
                                    shrinkWrap: true,
                                    selectable: true,
                                    data: snapshot.data!,
                                    onTapLink: (text, href, title) => launchUrl(Uri.parse(href!)),
                                  ),
                                )
                              : const Center(child: CircularProgressIndicator());
                        },
                      ),
                    ),
                  ),
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
            ),
          ),
          PaddedCard(
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
          )),
          PaddedCard(
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
        ],
      ),
    );
  }
}
