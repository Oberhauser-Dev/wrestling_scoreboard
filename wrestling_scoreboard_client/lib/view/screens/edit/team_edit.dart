import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class TeamEdit extends ConsumerStatefulWidget {
  final Team? team;
  final Club? initialClub;

  const TeamEdit({this.team, this.initialClub, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => TeamEditState();
}

class TeamEditState extends ConsumerState<TeamEdit> {
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
        leading: const Icon(Icons.short_text),
        title: TextFormField(
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: localizations.name,
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
        leading: const Icon(Icons.subject),
        title: TextFormField(
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: localizations.description,
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
            availableClubs ??= await (await ref.read(dataManagerNotifierProvider)).readMany<Club, Null>();
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
      await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(Team(
            id: widget.team?.id,
            name: _name!,
            description: _description,
            club: _club!,
          ));
      navigator.pop();
    }
  }
}
