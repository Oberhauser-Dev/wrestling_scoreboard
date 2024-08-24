import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/provider/account_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class Restricted extends ConsumerWidget {
  final Widget child;
  final UserPrivilege privilege;

  const Restricted({
    super.key,
    required this.child,
    this.privilege = UserPrivilege.write,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LoadingBuilder(
      future: ref.read(userNotifierProvider),
      // Center widget has no size, so use CircularProgressIndicator directly.
      onLoad: (context) => const CircularProgressIndicator(),
      onException: (context, exception, {stackTrace}) => IconButton(
          onPressed: () => showExceptionDialog(context: context, exception: exception ?? '', stackTrace: stackTrace),
          icon: const Icon(Icons.warning)),
      builder: (context, user) {
        return Visibility(
          visible: user != null && user.privilege >= privilege,
          child: child,
        );
      },
    );
  }
}

class RestrictedAddButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final UserPrivilege privilege;

  const RestrictedAddButton({
    super.key,
    this.onPressed,
    this.privilege = UserPrivilege.write,
  });

  @override
  Widget build(BuildContext context) {
    return Restricted(
      privilege: privilege,
      child: IconButton(
        icon: const Icon(Icons.add),
        onPressed: onPressed,
      ),
    );
  }
}
