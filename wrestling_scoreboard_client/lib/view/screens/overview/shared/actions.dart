import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/auth.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class ConditionalOrganizationImportActionBuilder extends StatelessWidget {
  final Organization? organization;
  final int id;
  final OrganizationImportType importType;
  final Widget Function(BuildContext context, ResponsiveScaffoldActionItem? actionItem) builder;

  const ConditionalOrganizationImportActionBuilder({
    required this.id,
    required this.organization,
    required this.importType,
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    if (organization?.apiProvider == null) {
      return builder(context, null);
    }

    return RestrictedBuilder(
      privilege: UserPrivilege.write,
      builder: (BuildContext context, bool hasPrivilege) {
        if (!hasPrivilege) return builder(context, null);
        return OrganizationImportAction(id: id, orgId: organization!.id!, importType: importType, builder: builder);
      },
    );
  }
}

class OrganizationImportAction extends ConsumerStatefulWidget {
  final int orgId;
  final int id;
  final OrganizationImportType importType;
  final Widget Function(BuildContext context, ResponsiveScaffoldActionItem? actionItem) builder;

  const OrganizationImportAction({
    required this.id,
    required this.orgId,
    required this.importType,
    required this.builder,
    super.key,
  });

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
    final localizations = context.l10n;
    return widget.builder(
      context,
      ResponsiveScaffoldActionItem(
        label: localizations.importFromApiProvider,
        onTap: () async {
          final result = await showDialog<bool>(
            context: context,
            builder: (context) => _IncludeSubjacentDialog(child: Text(localizations.warningImportFromApiProvider)),
          );
          if (result != null && context.mounted) {
            await _processImport(
              context,
              ref,
              orgId: widget.orgId,
              id: widget.id,
              importType: widget.importType,
              includeSubjacent: result,
            );
          }
        },
        icon: const Icon(Icons.import_export),
      ),
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
      final localizations = context.l10n;
      final result = await showDialog<bool>(
        context: context,
        builder:
            (context) => _IncludeSubjacentDialog(
              child: Text(
                lastUpdated == null
                    ? localizations.proposeFirstImportFromApiProvider
                    : localizations.proposeImportFromApiProvider(lastUpdated, lastUpdated),
              ),
            ),
      );
      if (result != null && context.mounted) {
        await _processImport(context, ref, orgId: orgId, id: id, importType: importType, includeSubjacent: result);
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
  required bool includeSubjacent,
}) async {
  await catchAsync(context, () {
    final localizations = context.l10n;
    return showLoadingDialog(
      label: localizations.importFromApiProvider,
      runAsync: (BuildContext context) async {
        final dataManager = await ref.read(dataManagerNotifierProvider);
        final authService = (await ref.read(orgAuthNotifierProvider))[orgId];
        switch (importType) {
          case OrganizationImportType.organization:
            await dataManager.organizationImport(id, includeSubjacent: includeSubjacent, authService: authService);
          case OrganizationImportType.team:
            await dataManager.organizationTeamImport(id, includeSubjacent: includeSubjacent, authService: authService);
          case OrganizationImportType.league:
            await dataManager.organizationLeagueImport(
              id,
              includeSubjacent: includeSubjacent,
              authService: authService,
            );
          case OrganizationImportType.competition:
            await dataManager.organizationCompetitionImport(
              id,
              includeSubjacent: includeSubjacent,
              authService: authService,
            );
          case OrganizationImportType.teamMatch:
            await dataManager.organizationTeamMatchImport(
              id,
              includeSubjacent: includeSubjacent,
              authService: authService,
            );
        }
        if (context.mounted) {
          await showOkDialog(context: context, child: Text(localizations.actionSuccessful));
        }
      },
      context: context,
    );
  });
}

class _IncludeSubjacentDialog extends StatefulWidget {
  final Widget child;

  const _IncludeSubjacentDialog({required this.child});

  @override
  State<_IncludeSubjacentDialog> createState() => _IncludeSubjacentDialogState();
}

class _IncludeSubjacentDialogState extends State<_IncludeSubjacentDialog> {
  bool _includeSubjacent = false;

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    return OkCancelDialog<bool>(
      getResult: () => _includeSubjacent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.child,
          Restricted(
            privilege: UserPrivilege.admin,
            child: CheckboxListTile(
              title: Text(localizations.importIncludeSubjacent),
              value: _includeSubjacent,
              onChanged:
                  (v) => setState(() {
                    _includeSubjacent = v ?? false;
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

enum OrganizationImportType { organization, team, league, competition, teamMatch }
