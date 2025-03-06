import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';
import 'package:wrestling_scoreboard_client/provider/account_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/home/more.dart';
import 'package:wrestling_scoreboard_client/view/screens/more/profile/change_password.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class ProfileScreen extends ConsumerWidget {
  static const route = 'profile';

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.profile)),
      body: ResponsiveScrollView(
        child: Card(
          child: LoadingBuilder<User?>(
            future: ref.watch(userNotifierProvider),
            builder: (context, user) {
              if (user != null) {
                return Column(
                  children: [
                    // Keep in sync with [UserOverview]
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(user.username),
                      subtitle: Text(localizations.username),
                    ),
                    // ListTile(
                    //   leading: const Icon(Icons.email),
                    //   title: Text(user.email ?? '-'),
                    //   subtitle: Text(localizations.email),
                    // ),
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: Text(user.createdAt.toDateTimeString(context)),
                      subtitle: Text(localizations.joinedOn),
                    ),
                    ListTile(
                      leading: const Icon(Icons.key),
                      title: Text(user.privilege.name),
                      subtitle: Text(localizations.privilege),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: InkWell(
                        onTap: () => context.push('/${MoreScreen.route}/${ChangePasswordScreen.route}'),
                        child: Text(localizations.auth_change_password),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton(
                        onPressed: () async {
                          await ref.read(userNotifierProvider.notifier).signOut();
                          if (context.mounted) Navigator.of(context).pop();
                        },
                        child: Text(localizations.auth_signOut),
                      ),
                    ),
                  ],
                );
              }
              return const Text('No data available');
            },
          ),
        ),
      ),
    );
  }
}
