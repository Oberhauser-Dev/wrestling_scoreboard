import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/account_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/more/about.dart';
import 'package:wrestling_scoreboard_client/view/screens/more/admin/admin_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/more/imprint.dart';
import 'package:wrestling_scoreboard_client/view/screens/more/privacy_policy.dart';
import 'package:wrestling_scoreboard_client/view/screens/more/profile/profile.dart';
import 'package:wrestling_scoreboard_client/view/screens/more/profile/sign_in.dart';
import 'package:wrestling_scoreboard_client/view/screens/more/settings.dart';
import 'package:wrestling_scoreboard_client/view/widgets/exception.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaffold.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class MoreScreen extends ConsumerWidget {
  static const route = 'more';

  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = context.l10n;

    return WindowStateScaffold(
      appBarTitle: Text(localizations.more),
      body: ResponsiveScrollView(
        child: Card(
          child: LoadingBuilder<User?>(
            future: ref.watch(userNotifierProvider),
            builder: (context, user) {
              return Column(
                children:
                    ListTile.divideTiles(
                      context: context,
                      tiles: [
                        ListTile(
                          leading: const Icon(Icons.settings),
                          title: Text(localizations.settings),
                          onTap: () => context.push('/${MoreScreen.route}/${CustomSettingsScreen.route}'),
                        ),
                        if (user?.privilege == UserPrivilege.admin)
                          ListTile(
                            leading: const Icon(Icons.admin_panel_settings),
                            title: Text(localizations.administration),
                            onTap: () => context.push('/${MoreScreen.route}/${AdminOverview.route}'),
                          ),
                        ListTile(
                          leading: const Icon(Icons.info),
                          title: Text(localizations.imprint),
                          onTap: () => context.push('/${MoreScreen.route}/${ImprintScreen.route}'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.info),
                          title: Text(localizations.about),
                          onTap: () => context.push('/${MoreScreen.route}/${AboutScreen.route}'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.policy),
                          title: Text(localizations.privacy_policy),
                          onTap: () => context.push('/${MoreScreen.route}/${PrivacyPolicyScreen.route}'),
                        ),
                        ListTile(
                          leading: Icon(user == null ? Icons.login : Icons.account_circle),
                          title: Text(
                            user == null ? localizations.auth_signIn : '${localizations.profile}: ${user.username}',
                          ),
                          onTap: () {
                            if (user == null) {
                              context.push('/${MoreScreen.route}/${SignInScreen.route}');
                            } else {
                              context.push('/${MoreScreen.route}/${ProfileScreen.route}');
                            }
                          },
                        ),
                      ],
                    ).toList(),
              );
            },
            onException: (context, exception, {stackTrace}) {
              return ExceptionCard(
                exception ?? '',
                stackTrace: stackTrace,
                onRetry: () async {
                  await ref.read(userNotifierProvider.notifier).signOut();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
