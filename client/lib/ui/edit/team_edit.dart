import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/ui/components/dropdown.dart';
import 'package:wrestling_scoreboard/ui/components/edit.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';

class TeamEdit extends StatefulWidget {
  final Team? team;
  final Club? initialClub;
  final League? initialLeague;

  const TeamEdit({this.team, this.initialClub, this.initialLeague, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TeamEditState();
}

class TeamEditState extends State<TeamEdit> {
  final _formKey = GlobalKey<FormState>();

  List<Club>? clubs;
  List<League>? leagues;
  String? _name;
  String? _description;
  Club? _club;
  League? _league;

  @override
  void initState() {
    super.initState();
    _club = widget.team?.club ?? widget.initialClub;
    _league = widget.team?.league ?? widget.initialLeague;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

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
            clubs ??= await dataProvider.readMany<Club>();
            return (filter == null ? clubs! : clubs!.where((element) => element.name.contains(filter))).toList();
          },
        ),
      ),
      ListTile(
        title: getDropdown<League>(
          icon: const Icon(Icons.emoji_events),
          selectedItem: _league,
          label: AppLocalizations.of(context)!.league,
          context: context,
          onSaved: (League? value) => setState(() {
            _league = value;
          }),
          itemAsString: (u) => u.name,
          onFind: (String? filter) async {
            leagues ??= await dataProvider.readMany<League>();
            return (filter == null ? leagues! : leagues!.where((element) => element.name.contains(filter))).toList();
          },
        ),
      ),
    ];

    return Form(
      key: _formKey,
      child: EditWidget(
        typeLocalization: localizations.team,
        id: widget.team?.id,
        onSubmit: () => handleSubmit(context),
        items: items,
      ),
    );
  }

  Future<void> handleSubmit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await dataProvider.createOrUpdateSingle(Team(
        id: widget.team?.id,
        name: _name!,
        description: _description,
        club: _club!,
        league: _league,
      ));
      Navigator.of(context).pop();
    }
  }
}
