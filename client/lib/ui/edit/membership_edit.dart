import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/ui/edit/person_edit.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';

class MembershipEdit extends PersonEdit {
  final Membership? membership;
  final Club initialClub;

  MembershipEdit({this.membership, required this.initialClub, Key? key}) : super(person: membership?.person, key: key);

  @override
  State<StatefulWidget> createState() => MembershipEditState();
}

class MembershipEditState extends PersonEditState<MembershipEdit> {
  String? _no;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return buildEdit(context, classLocale: localizations.membership, fields: [
      ListTile(
        title: TextFormField(
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: localizations.membershipNumber,
            icon: const Icon(Icons.tag),
          ),
          initialValue: widget.membership?.no,
          onSaved: (newValue) => _no = newValue,
        ),
      ),
    ]);
  }

  @override
  Future<void> handleNested(person) async {
    final membership = Membership(id: widget.membership?.id, person: person, club: widget.initialClub, no: _no);
    membership.id = await dataProvider.createOrUpdateSingle(membership);
  }
}
