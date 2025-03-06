import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/form.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class OrganizationEdit extends ConsumerStatefulWidget {
  final Organization? organization;
  final Organization? initialParent;

  const OrganizationEdit({this.organization, this.initialParent, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrganizationEditState();
}

class _OrganizationEditState extends ConsumerState<OrganizationEdit> {
  final _formKey = GlobalKey<FormState>();
  Iterable<Organization>? _availableOrganizations;

  String? _name;
  String? _abbreviation;
  Organization? _parent;
  WrestlingApiProvider? _apiProvider;
  WrestlingReportProvider? _reportProvider;

  // Auth for API provider
  AuthService? _apiProviderAuth;

  @override
  void initState() {
    super.initState();
    _parent = widget.organization?.parent ?? widget.initialParent;
    _apiProvider = widget.organization?.apiProvider;
    _reportProvider = widget.organization?.reportProvider;

    if (widget.organization?.id != null) {
      ref.read(orgAuthNotifierProvider).then((value) {
        setState(() {
          _apiProviderAuth = value[widget.organization!.id];
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    final navigator = Navigator.of(context);

    final items = [
      ListTile(
        leading: const Icon(Icons.description),
        title: TextFormField(
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: localizations.name,
          ),
          initialValue: widget.organization?.name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return localizations.mandatoryField;
            }
            return null;
          },
          onSaved: (newValue) => _name = newValue,
        ),
      ),
      ListTile(
        leading: const Icon(Icons.short_text),
        title: TextFormField(
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: localizations.abbreviation,
          ),
          initialValue: widget.organization?.abbreviation,
          onSaved: (newValue) => _abbreviation = newValue,
        ),
      ),
      ListTile(
        title: SearchableDropdown<Organization>(
          icon: const Icon(Icons.corporate_fare),
          selectedItem: _parent,
          label: localizations.umbrellaOrganization,
          context: context,
          onSaved: (Organization? value) => setState(() {
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
            hint: localizations.apiProvider,
            isExpanded: true,
            options: WrestlingApiProvider.values.map((value) => MapEntry(
                  value,
                  Text(value.name),
                )),
            selected: _apiProvider,
            onChange: (newValue) => setState(() {
              _apiProvider = newValue;
            }),
          ),
        ),
      ),
      if (_apiProvider == WrestlingApiProvider.deByRingenApi)
        ListTile(
          leading: const Icon(Icons.account_circle),
          title: TextFormField(
            key: Key(_apiProviderAuth.toString()),
            // Workaround to update initialValue
            autofillHints: const [AutofillHints.username],
            decoration: InputDecoration(
              border: const UnderlineInputBorder(),
              labelText: localizations.username,
            ),
            initialValue: _apiProviderAuth is BasicAuthService ? (_apiProviderAuth as BasicAuthService).username : null,
            onSaved: (newValue) {
              final currentAuth = _apiProviderAuth;
              if (currentAuth is BasicAuthService) {
                _apiProviderAuth = currentAuth.copyWith(username: newValue ?? '');
              } else {
                _apiProviderAuth = BasicAuthService(username: newValue ?? '', password: '');
              }
            },
          ),
        ),
      if (_apiProvider == WrestlingApiProvider.deByRingenApi)
        PasswordInput(
          isMandatory: true,
          key: Key(_apiProviderAuth.toString()), // Workaround to update initialValue
          initialValue: _apiProviderAuth is BasicAuthService ? (_apiProviderAuth as BasicAuthService).password : null,
          onSaved: (newValue) {
            final currentAuth = _apiProviderAuth;
            if (currentAuth is BasicAuthService) {
              _apiProviderAuth = currentAuth.copyWith(password: newValue ?? '');
            } else {
              _apiProviderAuth = BasicAuthService(username: '', password: newValue ?? '');
            }
          },
        ),
      ListTile(
        leading: const Icon(Icons.description),
        title: ButtonTheme(
          alignedDropdown: true,
          child: SimpleDropdown<WrestlingReportProvider>(
            isNullable: true,
            hint: localizations.reportProvider,
            isExpanded: true,
            options: WrestlingReportProvider.values.map((value) => MapEntry(
                  value,
                  Text(value.name),
                )),
            selected: _reportProvider,
            onChange: (newValue) => setState(() {
              _reportProvider = newValue;
            }),
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
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(Organization(
        id: widget.organization?.id,
        name: _name!,
        abbreviation: _abbreviation,
        parent: _parent,
        reportProvider: _reportProvider,
        apiProvider: _apiProvider,
      ));
      if (widget.organization?.id != null && _apiProviderAuth != null) {
        ref.read(orgAuthNotifierProvider.notifier).addOrgAuthService(widget.organization!.id!, _apiProviderAuth!);
      }
      navigator.pop();
    }
  }
}
