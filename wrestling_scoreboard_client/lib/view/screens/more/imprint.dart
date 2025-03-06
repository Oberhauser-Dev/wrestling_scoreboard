import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wrestling_scoreboard_client/view/widgets/card.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaffold.dart';

class ImprintScreen extends StatelessWidget {
  static const route = 'imprint';
  const ImprintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;

    return WindowStateScaffold(
      appBarTitle: Text(localizations.imprint),
      body: ResponsiveScrollView(
        child: PaddedCard(
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
    );
  }
}
