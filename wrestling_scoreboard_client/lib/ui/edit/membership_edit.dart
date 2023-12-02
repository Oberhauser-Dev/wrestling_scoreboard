import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_client/ui/edit/person_edit.dart';
import 'package:wrestling_scoreboard_client/util/network/data_provider.dart';
import 'package:wrestling_scoreboard_common/common.dart';

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
    return buildEdit(context, id: widget.membership?.id, classLocale: localizations.membership, fields: [
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
    var membership = Membership(id: widget.membership?.id, person: person, club: widget.initialClub, no: _no);
    membership = membership.copyWithId(await dataProvider.createOrUpdateSingle(membership));
  }
}
