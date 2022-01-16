import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/data/league.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';

class EditLeague extends StatefulWidget {
  final String title;
  late final ClientLeague league;

  EditLeague({required this.title, ClientLeague? league, Key? key}) : super(key: key) {
    this.league = league ?? ClientLeague(name: '', startDate: DateTime.now());
  }

  @override
  State<StatefulWidget> createState() => EditLeagueState();
}

class EditLeagueState extends State<EditLeague> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  late DateTime _startDate;

  @override
  void initState() {
    super.initState();
    _startDate = widget.league.startDate;
  }

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
        initialValue: widget.league.name,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return localizations.mandatoryField;
          }
        },
        onSaved: (newValue) => _name = newValue,
      ),
      TextFormField(
        readOnly: true,
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          labelText: localizations.date,
          icon: const Icon(Icons.date_range),
        ),
        onTap: () => showDatePicker(
          initialDatePickerMode: DatePickerMode.year,
          context: context,
          initialDate: _startDate,
          firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
          lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
        ).then((value) {
          if (value != null) {
            setState(() => _startDate = value);
          }
        }),
        initialValue: _startDate.toIso8601String(),
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
      await dataProvider.createOrUpdateSingle(ClientLeague(id: widget.league.id, name: _name!, startDate: _startDate));
      Navigator.of(context).pop();
    }
  }
}
