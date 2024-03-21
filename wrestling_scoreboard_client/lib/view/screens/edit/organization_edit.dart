import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
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

  @override
  void initState() {
    _parent = widget.organization?.parent ?? widget.initialParent;
    _apiProvider = widget.organization?.apiProvider;
    _reportProvider = widget.organization?.reportProvider;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
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
        title: getDropdown<Organization>(
          icon: const Icon(Icons.corporate_fare),
          selectedItem: _parent,
          label: localizations.organization,
          context: context,
          onSaved: (Organization? value) => setState(() {
            _parent = value;
          }),
          allowEmpty: true,
          itemAsString: (u) => u.name,
          onFind: (String? filter) async {
            _availableOrganizations ??=
                await (await ref.read(dataManagerNotifierProvider)).readMany<Organization, Null>();
            return (filter == null
                    ? _availableOrganizations!
                    : _availableOrganizations!.where((element) => element.name.contains(filter)))
                .toList();
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
      ListTile(
        leading: const Icon(Icons.description),
        title: ButtonTheme(
          alignedDropdown: true,
          child: SimpleDropdown<WrestlingReportProvider>(
            isNullable: true,
            hint: localizations.apiProvider,
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
      navigator.pop();
    }
  }
}
