import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/formatter.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class AgeCategoryEdit extends ConsumerStatefulWidget {
  final AgeCategory? ageCategory;
  final Organization? initialOrganization;

  const AgeCategoryEdit({this.ageCategory, this.initialOrganization, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => AgeCategoryEditState();
}

class AgeCategoryEditState extends ConsumerState<AgeCategoryEdit> {
  final _formKey = GlobalKey<FormState>();
  Iterable<Organization>? _availableOrganizations;

  String? _name;
  int? _minAge;
  int? _maxAge;
  late Organization? _organization;

  @override
  void initState() {
    _organization = widget.ageCategory?.organization ?? widget.initialOrganization;
    super.initState();
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
          initialValue: widget.ageCategory?.name,
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
        leading: const Icon(Icons.school),
        title: TextFormField(
          initialValue: widget.ageCategory?.minAge.toString(),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
            labelText: '${localizations.age} (${localizations.minimum})',
          ),
          inputFormatters: <TextInputFormatter>[NumericalRangeFormatter(min: 0, max: 1000)],
          onSaved: (String? value) {
            _minAge = int.tryParse(value ?? '') ?? 0;
          },
        ),
      ),
      ListTile(
        leading: const Icon(Icons.school),
        title: TextFormField(
          initialValue: widget.ageCategory?.maxAge.toString(),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
            labelText: '${localizations.age} (${localizations.maximum})',
          ),
          inputFormatters: <TextInputFormatter>[NumericalRangeFormatter(min: 0, max: 1000)],
          onSaved: (String? value) {
            _maxAge = int.tryParse(value ?? '') ?? 0;
          },
        ),
      ),
      ListTile(
        title: SearchableDropdown<Organization>(
          icon: const Icon(Icons.corporate_fare),
          selectedItem: _organization,
          label: localizations.organization,
          context: context,
          onSaved: (Organization? value) => setState(() {
            _organization = value;
          }),
          allowEmpty: false,
          itemAsString: (u) => u.name,
          asyncItems: (String filter) async {
            _availableOrganizations ??=
                await (await ref.read(dataManagerNotifierProvider)).readMany<Organization, Null>();
            return _availableOrganizations!.toList();
          },
        ),
      ),
    ];

    return Form(
      key: _formKey,
      child: EditWidget(
        typeLocalization: localizations.ageCategory,
        id: widget.ageCategory?.id,
        onSubmit: () => handleSubmit(navigator),
        items: items,
      ),
    );
  }

  Future<void> handleSubmit(NavigatorState navigator) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      AgeCategory ageCategory = AgeCategory(
        id: widget.ageCategory?.id,
        orgSyncId: widget.ageCategory?.orgSyncId,
        name: _name!,
        minAge: _minAge!,
        maxAge: _maxAge!,
        organization: _organization!,
      );
      await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(ageCategory);
      navigator.pop();
    }
  }
}
