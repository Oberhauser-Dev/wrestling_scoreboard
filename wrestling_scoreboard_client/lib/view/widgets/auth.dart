import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/provider/account_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class Restricted extends ConsumerWidget {
  final Widget child;
  final UserPrivilege privilege;

  const Restricted({super.key, required this.child, this.privilege = UserPrivilege.write});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LoadingBuilder.icon(
      future: ref.watch(userProvider),
      // Center widget has no size, so use CircularProgressIndicator directly.
      onLoad: (context) => const CircularProgressIndicator(),
      builder: (context, user) {
        return Visibility(visible: user != null && user.privilege >= privilege, child: child);
      },
      onRetry: () => ref.refresh(userProvider),
    );
  }
}

class RestrictedBuilder extends ConsumerWidget {
  final Widget Function(BuildContext context, bool hasPrivilege) builder;
  final UserPrivilege privilege;

  const RestrictedBuilder({super.key, required this.builder, this.privilege = UserPrivilege.write});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LoadingBuilder.icon(
      future: ref.watch(userProvider),
      // Center widget has no size, so use CircularProgressIndicator directly.
      onLoad: (context) => const CircularProgressIndicator(),
      builder: (context, user) {
        return builder(context, user != null && user.privilege >= privilege);
      },
      onRetry: () => ref.refresh(userProvider),
    );
  }
}

class RestrictedAddButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final UserPrivilege privilege;

  const RestrictedAddButton({super.key, this.onPressed, this.privilege = UserPrivilege.write});

  @override
  Widget build(BuildContext context) {
    return Restricted(privilege: privilege, child: IconButton(icon: const Icon(Icons.add), onPressed: onPressed));
  }
}
