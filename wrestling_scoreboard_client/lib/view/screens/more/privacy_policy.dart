import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wrestling_scoreboard_client/view/widgets/card.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaffold.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  static const route = 'privacy-policy';

  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;

    return WindowStateScaffold(
      appBarTitle: Text(localizations.privacy_policy),
      body: ResponsiveScrollView(
        child: PaddedCard(
          child: ListTile(
            title: LoadingBuilder(
                future: DefaultAssetBundle.of(context).loadString('assets/docs/privacy-policy-en.md'),
                builder: (context, data) {
                  return MarkdownBody(
                    shrinkWrap: true,
                    selectable: true,
                    data: data,
                    onTapLink: (text, href, title) => launchUrl(Uri.parse(href!)),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
