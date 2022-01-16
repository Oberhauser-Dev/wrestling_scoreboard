import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/data/club.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';

class EditClub extends StatefulWidget {
  final String title;
  late final ClientClub club;

  EditClub({required this.title, ClientClub? club, Key? key}) : super(key: key) {
    this.club = club ?? ClientClub(name: '');
  }

  @override
  State<StatefulWidget> createState() => EditClubState();
}

class EditClubState extends State<EditClub> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  String? _no;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final items = [
      TextFormField(
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          labelText: localizations.name,
          icon: const Icon(Icons.description),
        ),
        initialValue: widget.club.name,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return localizations.mandatoryField;
          }
        },
        onSaved: (newValue) => _name = newValue,
      ),
      TextFormField(
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          labelText: localizations.clubNumber,
          icon: const Icon(Icons.tag),
        ),
        initialValue: widget.club.no,
        onSaved: (newValue) => _no = newValue,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                onPressed: () => handleSubmit(context),
                label: Text(AppLocalizations.of(context)!.save),
              ))
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1140),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: items,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void handleSubmit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await dataProvider.createOrUpdateSingle(ClientClub(id: widget.club.id, name: _name!, no: _no));
      Navigator.of(context).pop();
    }
  }
}
