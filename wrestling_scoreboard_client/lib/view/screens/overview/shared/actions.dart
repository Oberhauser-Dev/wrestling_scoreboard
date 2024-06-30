import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';

class OrganizationImportAction extends ConsumerWidget {
  final int orgId;
  final int id;
  final OrganizationImportType importType;

  const OrganizationImportAction({required this.id, required this.orgId, required this.importType, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    return IconButton(
      tooltip: localizations.importFromApiProvider,
      onPressed: () async {
        final result = await showOkCancelDialog(
          context: context,
          child: Text(localizations.warningImportFromApiProvider),
          getResult: () => true,
        );
        if (result == true && context.mounted) {
          catchAsync(
            context,
            () => showLoadingDialog(
              label: AppLocalizations.of(context)!.importFromApiProvider,
              runAsync: (BuildContext context) async {
                final dataManager = await ref.read(dataManagerNotifierProvider);
                final authService = (await ref.read(orgAuthNotifierProvider))[orgId];
                switch (importType) {
                  case OrganizationImportType.team:
                    await dataManager.organizationImport(id, authService: authService);
                  case OrganizationImportType.organization:
                    await dataManager.organizationImport(id, authService: authService);
                  case OrganizationImportType.league:
                    await dataManager.organizationLeagueImport(id, authService: authService);
                  case OrganizationImportType.competition:
                    await dataManager.organizationCompetitionImport(id, authService: authService);
                }
                if (context.mounted) {
                  await showOkDialog(context: context, child: Text(localizations.actionSuccessful));
                }
              },
              context: context,
            ),
          );
        }
      },
      icon: const Icon(Icons.import_export),
    );
  }
}

enum OrganizationImportType {
  organization,
  team,
  league,
  competition,
}
