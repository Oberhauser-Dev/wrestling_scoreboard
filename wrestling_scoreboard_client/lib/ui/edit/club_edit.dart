import 'package:wrestling_scoreboard_common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_client/ui/components/edit.dart';
import 'package:wrestling_scoreboard_client/util/network/data_provider.dart';

class ClubEdit extends StatefulWidget {
  final Club? club;

  const ClubEdit({this.club, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ClubEditState();
}

class ClubEditState extends State<ClubEdit> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  String? _no;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);

    final items = [
      ListTile(
        title: TextFormField(
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: localizations.name,
            icon: const Icon(Icons.description),
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
        title: TextFormField(
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: localizations.clubNumber,
            icon: const Icon(Icons.tag),
          ),
          initialValue: widget.club?.no,
          onSaved: (newValue) => _no = newValue,
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
      await dataProvider.createOrUpdateSingle(Club(id: widget.club?.id, name: _name!, no: _no));
      navigator.pop();
    }
  }
}