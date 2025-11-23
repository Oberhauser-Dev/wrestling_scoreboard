import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';
import 'package:wrestling_scoreboard_client/provider/account_provider.dart';
import 'package:wrestling_scoreboard_client/provider/data_provider.dart';
import 'package:wrestling_scoreboard_client/utils/provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/home/more.dart';
import 'package:wrestling_scoreboard_client/view/screens/more/profile/change_password.dart';
import 'package:wrestling_scoreboard_client/view/screens/more/profile/profile_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/more/profile/user_verification.dart';
import 'package:wrestling_scoreboard_client/view/widgets/card.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
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
        child: PaddedCard(
          child: LoadingBuilder<User?>(
            future: ref.watch(userProvider),
            builder: (context, user) {
              if (user != null) {
                return Column(
                  children: [
                    // Keep in sync with [UserOverview]
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(user.username),
                      subtitle: Text(localizations.username),
                      trailing: IconButton(
                        tooltip: localizations.edit,
                        onPressed: () async {
                          final user = await ref.readAsync(userProvider);
                          if (context.mounted && user != null) {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProfileEditScreen(user: user)),
                            );
                          }
                        },
                        icon: const Icon(Icons.edit),
                      ),
                    ),
                    if (!user.isEmailVerified && user.email != null && user.email!.isNotEmpty)
                      LoadingBuilder(
                        future: ref.watch(remoteConfigProvider.future),
                        builder: (context, remoteConfig) {
                          if (!remoteConfig.hasEmailVerification) return SizedBox.shrink();
                          return IconCard(
                            icon: const Icon(Icons.warning),
                            child: Wrap(
                              runSpacing: 16,
                              alignment: WrapAlignment.center,
                              children: [
                                Text(localizations.auth_warning_email_not_verified),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => UserVerificationScreen(username: user.username),
                                        ),
                                      );
                                    },
                                    child: Text(localizations.auth_verfication),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: Text(user.email ?? '-'),
                      subtitle: Text(localizations.email),
                    ),
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
                    Column(
                      spacing: 16,
                      children: [
                        InkWell(
                          onTap: () => context.push('/${MoreScreen.route}/${ChangePasswordScreen.route}'),
                          child: Text(localizations.auth_change_password),
                        ),
                        ElevatedButton(
                          onPressed:
                              () => catchAsync(context, () async {
                                await ref.read(userProvider.notifier).signOut();
                                if (context.mounted) Navigator.of(context).pop();
                              }),
                          child: Text(localizations.auth_signOut),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.errorContainer,
                          ),
                          onPressed:
                              () => catchAsync(context, () async {
                                final result = await showOkCancelDialog(
                                  title: Text(localizations.auth_delete),
                                  context: context,
                                  child: Text(localizations.auth_delete_confirmation),
                                );
                                if (result && context.mounted) {
                                  await ref.read(userProvider.notifier).deleteUser();
                                  if (context.mounted) Navigator.of(context).pop();
                                }
                              }),
                          child: Text(localizations.auth_delete),
                        ),
                      ],
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
