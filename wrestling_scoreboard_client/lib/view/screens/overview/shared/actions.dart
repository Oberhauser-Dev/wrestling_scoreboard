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
    ref.read(dataManagerNotifierProvider).then((dataManager) async {
      DateTime? lastUpdated;
      switch (widget.importType) {
        case OrganizationImportType.organization:
          lastUpdated = await dataManager.organizationLastImportUtcDateTime(widget.id);
        case OrganizationImportType.team:
          lastUpdated = await dataManager.organizationTeamLastImportUtcDateTime(widget.id);
        case OrganizationImportType.league:
          lastUpdated = await dataManager.organizationLeagueLastImportUtcDateTime(widget.id);
        case OrganizationImportType.competition:
          lastUpdated = await dataManager.organizationCompetitionLastImportUtcDateTime(widget.id);
        case OrganizationImportType.teamMatch:
          lastUpdated = await dataManager.organizationTeamMatchLastImportUtcDateTime(widget.id);
      }
      lastUpdated = lastUpdated?.toLocal();
      // TODO: make it configurable via Duration picker in settings
      if (lastUpdated == null || lastUpdated.compareTo(DateTime.now().subtract(const Duration(hours: 48))) < 0) {
        final context = this.context;
        if (context.mounted) {
          final localizations = AppLocalizations.of(context)!;
          final result = await showOkCancelDialog(
            context: context,
            child: Text(lastUpdated == null
                ? localizations.recommendFirstImportFromApiProvider
                : localizations.recommendImportFromApiProvider(lastUpdated, lastUpdated)),
            getResult: () => true,
          );
          if (result == true && context.mounted) {
            await _import(localizations);
          }
        }
      }
    });
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
          await _import(localizations);
        }
      },
      icon: const Icon(Icons.import_export),
    );
  }

  Future<void> _import(AppLocalizations localizations) async {
    await catchAsync(
      context,
      () => showLoadingDialog(
        label: AppLocalizations.of(context)!.importFromApiProvider,
        runAsync: (BuildContext context) async {
          final dataManager = await ref.read(dataManagerNotifierProvider);
          final authService = (await ref.read(orgAuthNotifierProvider))[widget.orgId];
          switch (widget.importType) {
            case OrganizationImportType.organization:
              await dataManager.organizationImport(widget.id, authService: authService);
            case OrganizationImportType.team:
              await dataManager.organizationTeamImport(widget.id, authService: authService);
            case OrganizationImportType.league:
              await dataManager.organizationLeagueImport(widget.id, authService: authService);
            case OrganizationImportType.competition:
              await dataManager.organizationCompetitionImport(widget.id, authService: authService);
            case OrganizationImportType.teamMatch:
              await dataManager.organizationTeamMatchImport(widget.id, authService: authService);
          }
          if (context.mounted) {
            await showOkDialog(context: context, child: Text(localizations.actionSuccessful));
          }
        },
        context: context,
      ),
    );
  }
}

enum OrganizationImportType {
  organization,
  team,
  league,
  competition,
  teamMatch,
}
