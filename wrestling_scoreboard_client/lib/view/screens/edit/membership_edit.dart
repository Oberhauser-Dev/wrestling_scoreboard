import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/person_edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class MembershipEdit extends AbstractPersonEdit {
  final Membership? membership;
  final Club? initialClub;
  final Person? initialPerson;

  MembershipEdit({
    this.membership,
    this.initialClub,
    this.initialPerson,
    super.key,
  }) : super(person: membership?.person ?? initialPerson, initialOrganization: initialClub?.organization);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => MembershipEditState();
}

class MembershipEditState extends AbstractPersonEditState<MembershipEdit> {
  Iterable<Club>? _availableClubs;
  String? _no;
  Club? _club;

  @override
  void initState() {
    super.initState();
    _club = widget.membership?.club ?? widget.initialClub;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return buildEdit(context, id: widget.membership?.id, classLocale: localizations.membership, fields: [
      ListTile(
        leading: const Icon(Icons.tag),
        title: TextFormField(
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: localizations.membershipNumber,
            hintText: localizations.optional,
          ),
          initialValue: widget.membership?.no,
          onSaved: (newValue) {
            if (newValue == null || newValue.isEmpty) {
              _no = null;
            } else {
              _no = newValue;
            }
          },
        ),
      ),
      ListTile(
        title: SearchableDropdown<Club>(
          icon: const Icon(Icons.foundation),
          selectedItem: _club,
          label: localizations.club,
          context: context,
          onSaved: (Club? value) => setState(() {
            _club = value;
          }),
          itemAsString: (u) => u.name,
          asyncItems: (String filter) async {
            _availableClubs ??= await (await ref.read(dataManagerNotifierProvider)).readMany<Club, Null>();
            return _availableClubs!.toList();
          },
        ),
      ),
    ]);
  }

  @override
  Future<void> handleNested(person) async {
    var membership = Membership(id: widget.membership?.id, person: person, club: _club!, no: _no);
    membership =
        membership.copyWithId(await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(membership));
  }
}
