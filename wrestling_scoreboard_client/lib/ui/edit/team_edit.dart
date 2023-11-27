import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_client/ui/components/dropdown.dart';
import 'package:wrestling_scoreboard_client/ui/components/edit.dart';
import 'package:wrestling_scoreboard_client/util/network/data_provider.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class TeamEdit extends StatefulWidget {
  final Team? team;
  final Club? initialClub;

  const TeamEdit({this.team, this.initialClub, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TeamEditState();
}

class TeamEditState extends State<TeamEdit> {
  final _formKey = GlobalKey<FormState>();

  List<Club>? availableClubs;
  String? _name;
  String? _description;
  Club? _club;

  @override
  void initState() {
    super.initState();
    _club = widget.team?.club ?? widget.initialClub;
  }

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
            icon: const Icon(Icons.short_text),
          ),
          initialValue: widget.team?.name,
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
            labelText: localizations.description,
            icon: const Icon(Icons.subject),
          ),
          initialValue: widget.team?.description,
          onSaved: (newValue) => _description = newValue,
        ),
      ),
      ListTile(
        title: getDropdown<Club>(
          icon: const Icon(Icons.foundation),
          selectedItem: _club,
          label: AppLocalizations.of(context)!.club,
          context: context,
          onSaved: (Club? value) => setState(() {
            _club = value;
          }),
          itemAsString: (u) => u.name,
          onFind: (String? filter) async {
            availableClubs ??= await dataProvider.readMany<Club, DataObject>();
            return (filter == null
                    ? availableClubs!
                    : availableClubs!.where((element) => element.name.contains(filter)))
                .toList();
          },
        ),
      ),
    ];

    return Form(
      key: _formKey,
      child: EditWidget(
        typeLocalization: localizations.team,
        id: widget.team?.id,
        onSubmit: () => handleSubmit(navigator),
        items: items,
      ),
    );
  }

  Future<void> handleSubmit(NavigatorState navigator) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await dataProvider.createOrUpdateSingle(Team(
        id: widget.team?.id,
        name: _name!,
        description: _description,
        club: _club!,
      ));
      navigator.pop();
    }
  }
}
