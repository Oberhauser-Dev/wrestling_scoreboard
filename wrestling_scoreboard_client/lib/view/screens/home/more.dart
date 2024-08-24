import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/provider/account_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/more/about.dart';
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

class MoreScreen extends StatelessWidget {
  static const route = 'more';

  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

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
                  onTap: () => context.push('/${MoreScreen.route}/${CustomSettingsScreen.route}'),
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: Text(localizations.imprint),
                  onTap: () => context.push('/${MoreScreen.route}/${ImprintScreen.route}'),
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: Text(localizations.about),
                  onTap: () => context.push('/${MoreScreen.route}/${AboutScreen.route}'),
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const Icon(Icons.policy),
                  title: Text(localizations.privacy_policy),
                  onTap: () => context.push('/${MoreScreen.route}/${PrivacyPolicyScreen.route}'),
                ),
                const Divider(height: 0),
                Consumer(builder: (context, ref, child) {
                  return LoadingBuilder<User?>(
                    future: ref.watch(userNotifierProvider),
                    builder: (context, user) {
                      return ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(user == null ? localizations.auth_signIn : localizations.profile),
                        onTap: () {
                          if (user == null) {
                            context.push('/${MoreScreen.route}/${SignInScreen.route}');
                          } else {
                            context.push('/${MoreScreen.route}/${ProfileScreen.route}');
                          }
                        },
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
                  );
                }),
              ],
            ).toList(),
          ),
        ),
      ),
    );
  }
}
