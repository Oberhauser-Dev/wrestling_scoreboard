import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/form.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class OrganizationEdit extends ConsumerWidget {
  final Organization? organization;
  final Organization? initialParent;

  const OrganizationEdit({this.organization, this.initialParent, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LoadingBuilder(
      future: ref.read(orgAuthNotifierProvider.notifier).getByOrganization(organization?.id),
      builder: (context, authService) {
        return _OrganizationEdit(
          organization: organization,
          initialParent: initialParent,
          initialAuthService: authService is BasicAuthService ? authService : null,
        );
      },
    );
  }
}

class _OrganizationEdit extends ConsumerStatefulWidget {
  final Organization? organization;
  final Organization? initialParent;
  final BasicAuthService? initialAuthService;

  const _OrganizationEdit({this.organization, this.initialParent, this.initialAuthService});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrganizationEditState();
}

class _OrganizationEditState extends ConsumerState<_OrganizationEdit> {
  final _formKey = GlobalKey<FormState>();
  Iterable<Organization>? _availableOrganizations;

  String? _name;
  String? _abbreviation;
  Organization? _parent;
  WrestlingApiProvider? _apiProvider;
  WrestlingReportProvider? _reportProvider;
  String? _authProviderUsername;
  String? _authProviderPassword;
  bool _areCredentialsValid = true;

  @override
  void initState() {
    super.initState();
    _parent = widget.organization?.parent ?? widget.initialParent;
    _apiProvider = widget.organization?.apiProvider;
    _reportProvider = widget.organization?.reportProvider;

    _authProviderUsername = widget.initialAuthService?.username;
    _authProviderPassword = widget.initialAuthService?.password;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    final navigator = Navigator.of(context);

    final items = [
      CustomTextInput(
        iconData: Icons.description,
        label: localizations.name,
        initialValue: widget.organization?.name,
        isMandatory: true,
        onSaved: (value) => _name = value,
      ),
      CustomTextInput(
        iconData: Icons.short_text,
        label: localizations.abbreviation,
        initialValue: widget.organization?.abbreviation,
        isMandatory: false,
        onSaved: (value) => _abbreviation = value,
      ),
      ListTile(
        title: SearchableDropdown<Organization>(
          icon: const Icon(Icons.corporate_fare),
          selectedItem: _parent,
          label: localizations.umbrellaOrganization,
          context: context,
          onSaved:
              (Organization? value) => setState(() {
                _parent = value;
              }),
          allowEmpty: true,
          itemAsString: (u) => u.name,
          asyncItems: (String filter) async {
            _availableOrganizations ??=
                await (await ref.read(dataManagerNotifierProvider)).readMany<Organization, Null>();
            return _availableOrganizations!.toList();
          },
        ),
      ),
      ListTile(
        leading: const Icon(Icons.api),
        title: ButtonTheme(
          alignedDropdown: true,
          child: SimpleDropdown<WrestlingApiProvider>(
            isNullable: true,
            label: localizations.apiProvider,
            isExpanded: true,
            options: WrestlingApiProvider.values.map((value) => MapEntry(value, Text(value.name))),
            selected: _apiProvider,
            onSaved: (newValue) => _apiProvider = newValue,
          ),
        ),
      ),
      CustomTextInput(
        autofillHints: const [AutofillHints.username],
        iconData: Icons.account_circle,
        label: localizations.username,
        initialValue: _authProviderUsername,
        isMandatory: false,
        onSaved: (newValue) => _authProviderUsername = newValue,
        errorText: _areCredentialsValid ? null : 'Credentials are invalid',
      ),
      PasswordInput(
        isMandatory: false,
        initialValue: _authProviderPassword,
        onSaved: (newValue) => _authProviderPassword = newValue,
        errorText: _areCredentialsValid ? null : 'Credentials are invalid',
      ),
      ListTile(
        leading: const Icon(Icons.description),
        title: ButtonTheme(
          alignedDropdown: true,
          child: SimpleDropdown<WrestlingReportProvider>(
            isNullable: true,
            label: localizations.reportProvider,
            isExpanded: true,
            options: WrestlingReportProvider.values.map((value) => MapEntry(value, Text(value.name))),
            selected: _reportProvider,
            onSaved: (newValue) => _reportProvider = newValue,
          ),
        ),
      ),
    ];

    return Form(
      key: _formKey,
      child: EditWidget(
        typeLocalization: localizations.organization,
        id: widget.organization?.id,
        onSubmit: () => handleSubmit(navigator),
        items: items,
      ),
    );
  }

  Future<void> handleSubmit(NavigatorState navigator) async {
    if (!_areCredentialsValid) {
      // Reset error message from last time, if present.
      setState(() => _areCredentialsValid = true);
    }
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final dataManager = await ref.read(dataManagerNotifierProvider);
      if (widget.organization?.id != null) {
        if (_authProviderUsername != null || _authProviderPassword != null) {
          if (_authProviderUsername == null || _authProviderPassword == null) {
            // Both must be set
            setState(() => _areCredentialsValid = false);
            return;
          }
          final authService = BasicAuthService(username: _authProviderUsername!, password: _authProviderPassword!);
          final areCredentialsValid = await dataManager.organizationCheckCredentials(
            widget.organization!.id!,
            authService: authService,
          );
          if (!areCredentialsValid) {
            setState(() => _areCredentialsValid = false);
            return;
          }
          await ref.read(orgAuthNotifierProvider.notifier).addOrgAuthService(widget.organization!.id!, authService);
        } else if (widget.initialAuthService != null) {
          // Delete credentials if they already existed
          await ref.read(orgAuthNotifierProvider.notifier).removeOrgAuthService(widget.organization!.id!);
        }
      }
      await dataManager.createOrUpdateSingle(
        Organization(
          id: widget.organization?.id,
          name: _name!,
          abbreviation: _abbreviation,
          parent: _parent,
          reportProvider: _reportProvider,
          apiProvider: _apiProvider,
        ),
      );
      navigator.pop();
    }
  }
}
