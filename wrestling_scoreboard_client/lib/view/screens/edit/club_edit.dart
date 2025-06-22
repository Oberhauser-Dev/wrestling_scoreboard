import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/form.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class ClubEdit extends ConsumerStatefulWidget {
  final Club? club;
  final Organization? initialOrganization;
  final Future<void> Function(Club club)? onCreated;

  const ClubEdit({this.club, this.initialOrganization, this.onCreated, super.key});

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
    final localizations = context.l10n;
    final navigator = Navigator.of(context);

    final items = [
      CustomTextInput(
        iconData: Icons.description,
        label: localizations.name,
        initialValue: widget.club?.name,
        isMandatory: true,
        onSaved: (value) => _name = value,
      ),
      CustomTextInput(
        iconData: Icons.tag,
        label: localizations.clubNumber,
        initialValue: widget.club?.no,
        isMandatory: false,
        onSaved: (value) => _no = value,
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
      Club club = Club(
        id: widget.club?.id,
        orgSyncId: widget.club?.orgSyncId,
        name: _name!,
        no: _no,
        organization: _organization!,
      );
      club = club.copyWithId(await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(club));
      if (widget.onCreated != null) {
        await widget.onCreated!(club);
      }
      navigator.pop();
    }
  }
}
