import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/view/screens/home/organizations_view.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaffold.dart';

class Explore extends ConsumerWidget {
  static const route = '';

  const Explore({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = context.l10n;
    return WindowStateScaffold(appBarTitle: Text(localizations.explore), body: const OrganizationsView());
  }
}
