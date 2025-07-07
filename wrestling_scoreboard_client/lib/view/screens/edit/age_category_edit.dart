import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/form.dart';
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
      CustomTextInput(
        iconData: Icons.description,
        label: localizations.name,
        initialValue: widget.ageCategory?.name,
        isMandatory: true,
        onSaved: (newValue) => _name = newValue,
      ),
      NumericalInput(
        initialValue: widget.ageCategory?.minAge,
        iconData: Icons.school,
        label: '${localizations.age} (${localizations.minimum})',
        isMandatory: true,
        onSaved: (int? value) => _minAge = value,
      ),
      NumericalInput(
        initialValue: widget.ageCategory?.maxAge,
        iconData: Icons.school,
        label: '${localizations.age} (${localizations.maximum})',
        isMandatory: true,
        onSaved: (int? value) => _maxAge = value,
      ),
      ListTile(
        title: SearchableDropdown<Organization>(
          icon: const Icon(Icons.corporate_fare),
          selectedItem: _organization,
          label: localizations.organization,
          context: context,
          onSaved:
              (Organization? value) => setState(() {
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
      final AgeCategory ageCategory = AgeCategory(
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
