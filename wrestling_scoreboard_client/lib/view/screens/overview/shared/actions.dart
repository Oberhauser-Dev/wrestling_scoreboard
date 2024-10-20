import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/auth.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class ConditionalOrganizationImportAction extends StatelessWidget {
  final Organization organization;
  final int id;
  final OrganizationImportType importType;

  const ConditionalOrganizationImportAction({
    required this.id,
    required this.organization,
    required this.importType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: organization.apiProvider != null,
        child: Restricted(
          privilege: UserPrivilege.write,
          child: OrganizationImportAction(id: id, orgId: organization.id!, importType: importType),
        ));
  }
}

class OrganizationImportAction extends ConsumerStatefulWidget {
  final int orgId;
  final int id;
  final OrganizationImportType importType;

  const OrganizationImportAction({required this.id, required this.orgId, required this.importType, super.key});

  @override
  ConsumerState<OrganizationImportAction> createState() => _OrganizationImportActionState();
}

class _OrganizationImportActionState extends ConsumerState<OrganizationImportAction> {
  @override
  void initState() {
    super.initState();
    checkProposeImport(context, ref, orgId: widget.orgId, id: widget.id, importType: widget.importType);
  }

  @override
  Widget build(BuildContext context) {
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
          await _processImport(context, ref, orgId: widget.orgId, id: widget.id, importType: widget.importType);
        }
      },
      icon: const Icon(Icons.import_export),
    );
  }
}

Future<void> checkProposeImport(
  BuildContext context,
  WidgetRef ref, {
  required int orgId,
  required int id,
  required OrganizationImportType importType,
}) async {
  final dataManager = await ref.read(dataManagerNotifierProvider);
  DateTime? lastUpdated;
  switch (importType) {
    case OrganizationImportType.organization:
      lastUpdated = await dataManager.organizationLastImportUtcDateTime(id);
    case OrganizationImportType.team:
      lastUpdated = await dataManager.organizationTeamLastImportUtcDateTime(id);
    case OrganizationImportType.league:
      lastUpdated = await dataManager.organizationLeagueLastImportUtcDateTime(id);
    case OrganizationImportType.competition:
      lastUpdated = await dataManager.organizationCompetitionLastImportUtcDateTime(id);
    case OrganizationImportType.teamMatch:
      lastUpdated = await dataManager.organizationTeamMatchLastImportUtcDateTime(id);
  }
  lastUpdated = lastUpdated?.toLocal();

  final proposeApiImportDuration = await ref.read(proposeApiImportDurationNotifierProvider);
  if (lastUpdated == null || lastUpdated.compareTo(DateTime.now().subtract(proposeApiImportDuration)) < 0) {
    if (context.mounted) {
      final localizations = AppLocalizations.of(context)!;
      final result = await showOkCancelDialog(
        context: context,
        child: Text(lastUpdated == null
            ? localizations.proposeFirstImportFromApiProvider
            : localizations.proposeImportFromApiProvider(lastUpdated, lastUpdated)),
        getResult: () => true,
      );
      if (result == true && context.mounted) {
        await _processImport(context, ref, orgId: orgId, id: id, importType: importType);
      }
    }
  }
}

Future<void> _processImport(
  BuildContext context,
  WidgetRef ref, {
  required int orgId,
  required int id,
  required OrganizationImportType importType,
}) async {
  await catchAsync(
    context,
    () {
      final localizations = AppLocalizations.of(context)!;
      return showLoadingDialog(
        label: localizations.importFromApiProvider,
        runAsync: (BuildContext context) async {
          final dataManager = await ref.read(dataManagerNotifierProvider);
          final authService = (await ref.read(orgAuthNotifierProvider))[orgId];
          switch (importType) {
            case OrganizationImportType.organization:
              await dataManager.organizationImport(id, authService: authService);
            case OrganizationImportType.team:
              await dataManager.organizationTeamImport(id, authService: authService);
            case OrganizationImportType.league:
              await dataManager.organizationLeagueImport(id, authService: authService);
            case OrganizationImportType.competition:
              await dataManager.organizationCompetitionImport(id, authService: authService);
            case OrganizationImportType.teamMatch:
              await dataManager.organizationTeamMatchImport(id, authService: authService);
          }
          if (context.mounted) {
            await showOkDialog(context: context, child: Text(localizations.actionSuccessful));
          }
        },
        context: context,
      );
    },
  );
}

enum OrganizationImportType {
  organization,
  team,
  league,
  competition,
  teamMatch,
}
