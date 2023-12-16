import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wrestling_scoreboard_client/ui/components/responsive_container.dart';

class ImprintScreen extends StatelessWidget {
  const ImprintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.imprint)),
      body: ResponsiveScrollView(
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ListTile(
                    title: Text(
                  localizations.imprint,
                  style: Theme.of(context).textTheme.headlineSmall,
                )),
                ListTile(
                  title: MarkdownBody(
                    shrinkWrap: true,
                    selectable: true,
                    data: localizations.imprint_phrase,
                    onTapLink: (text, href, title) => launchUrl(Uri.parse(href!)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
