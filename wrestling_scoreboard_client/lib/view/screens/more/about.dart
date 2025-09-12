import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/utils/package_info.dart';
import 'package:wrestling_scoreboard_client/view/widgets/card.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaffold.dart';

const loadCompleteChangelog = false;

class AboutScreen extends StatelessWidget {
  static const route = 'about';

  const AboutScreen({super.key});

  Future<String> _loadChangelog() async {
    if (loadCompleteChangelog) {
      final globalChangelogUrl = Uri.https(
        'raw.githubusercontent.com',
        '/Oberhauser-Dev/wrestling_scoreboard/main/CHANGELOG.md',
      );
      return http.read(globalChangelogUrl);
    } else {
      return rootBundle.loadString('CHANGELOG.md');
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;

    navigateTo(Widget screen) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
    }

    return WindowStateScaffold(
      appBarTitle: Text(localizations.about),
      body: ResponsiveColumn(
        children: [
          PaddedCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(localizations.about_Application, style: Theme.of(context).textTheme.headlineSmall),
                ),
                ListTile(
                  leading: Image.asset('assets/images/icons/launcher.png'),
                  title: Text(localizations.appName),
                  subtitle: Text('Version: ${packageInfo.version}+${packageInfo.buildNumber}'),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.list),
                  title: Text(localizations.about_Changelog),
                  onTap:
                      () => showOkDialog(
                        context: context,
                        child: LoadingBuilder(
                          future: _loadChangelog(),
                          builder: (context, data) {
                            return SingleChildScrollView(
                              child: MarkdownBody(
                                listItemCrossAxisAlignment: MarkdownListItemCrossAxisAlignment.start,
                                shrinkWrap: true,
                                selectable: true,
                                data: data,
                                onTapLink: (text, href, title) => launchUrl(Uri.parse(href!)),
                              ),
                            );
                          },
                        ),
                      ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.api),
                  title: Text(localizations.about_Licenses),
                  onTap:
                      () => navigateTo(
                        LicensePage(
                          applicationName: localizations.appName,
                          applicationIcon: Image.asset('assets/images/icons/launcher.png'),
                          applicationVersion: '${packageInfo.version}+${packageInfo.buildNumber}',
                        ),
                      ),
                ),
                Divider(),
                ListTile(
                  leading: const Icon(Icons.code),
                  title: Text(localizations.about_SourceCode),
                  onTap: () => launchUrl(Uri.parse('https://github.com/Oberhauser-Dev/wrestling_scoreboard')),
                ),
              ],
            ),
          ),
          PaddedCard(
            child: Column(
              children: [
                ListTile(title: Text(localizations.about_Contact, style: Theme.of(context).textTheme.headlineSmall)),
                ListTile(
                  title: MarkdownBody(
                    shrinkWrap: true,
                    selectable: true,
                    data: localizations.about_contact_phrase,
                    onTapLink: (text, href, title) => launchUrl(Uri.parse(href!)),
                  ),
                ),
              ],
            ),
          ),
          PaddedCard(
            child: Column(
              children: [
                ListTile(
                  title: Text(localizations.about_Development, style: Theme.of(context).textTheme.headlineSmall),
                ),
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
