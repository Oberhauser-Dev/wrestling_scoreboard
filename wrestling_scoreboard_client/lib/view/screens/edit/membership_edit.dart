import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/person_edit.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class MembershipEdit extends PersonEdit {
  final Membership? membership;
  final Club initialClub;

  MembershipEdit({this.membership, required this.initialClub, super.key}) : super(person: membership?.person);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => MembershipEditState();
}

class MembershipEditState extends PersonEditState<MembershipEdit> {
  String? _no;

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
    membership = membership.copyWithId(await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(membership));
  }
}
