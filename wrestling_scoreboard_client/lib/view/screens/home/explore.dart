import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/view/screens/home/organizations_view.dart';

class Explore extends ConsumerWidget {
  static const route = '';

  const Explore({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.explore),
      ),
      body: const OrganizationsView(),
    );
  }
}
