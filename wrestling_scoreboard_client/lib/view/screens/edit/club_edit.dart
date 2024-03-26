import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class ClubEdit extends ConsumerStatefulWidget {
  final Club? club;
  final Organization? initialOrganization;

  const ClubEdit({this.club, this.initialOrganization, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ClubEditState();
}

class ClubEditState extends ConsumerState<ClubEdit> {
  final _formKey = GlobalKey<FormState>();
  Iterable<Organization>? _availableOrganizations;

  String? _name;
  String? _no;
  late Organization? _organization;

  @override
  void initState() {
    _organization = widget.club?.organization ?? widget.initialOrganization;
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
          initialValue: widget.club?.name,
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
        leading: const Icon(Icons.tag),
        title: TextFormField(
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: localizations.clubNumber,
          ),
          initialValue: widget.club?.no,
          onSaved: (newValue) => _no = newValue,
        ),
      ),
      ListTile(
        title: getDropdown<Organization>(
          icon: const Icon(Icons.corporate_fare),
          selectedItem: _organization,
          label: localizations.organization,
          context: context,
          onSaved: (Organization? value) => setState(() {
            _organization = value;
          }),
          allowEmpty: false,
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
    ];

    return Form(
      key: _formKey,
      child: EditWidget(
        typeLocalization: localizations.club,
        id: widget.club?.id,
        onSubmit: () => handleSubmit(navigator),
        items: items,
      ),
    );
  }

  Future<void> handleSubmit(NavigatorState navigator) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(Club(
        id: widget.club?.id,
        orgSyncId: widget.club?.orgSyncId,
        name: _name!,
        no: _no,
        organization: _organization!,
      ));
      navigator.pop();
    }
  }
}
