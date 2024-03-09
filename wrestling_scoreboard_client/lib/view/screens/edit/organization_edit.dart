import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class OrganizationEdit extends ConsumerStatefulWidget {
  final Organization? organization;

  const OrganizationEdit({this.organization, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrganizationEditState();
}

class _OrganizationEditState extends ConsumerState<OrganizationEdit> {
  final _formKey = GlobalKey<FormState>();

  String? _name;

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
      await (await ref.read(dataManagerNotifierProvider))
          .createOrUpdateSingle(Organization(id: widget.organization?.id, name: _name!));
      navigator.pop();
    }
  }
}
