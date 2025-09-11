import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/person_role.dart';
import 'package:wrestling_scoreboard_client/localization/team_match.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class TeamMatchPersonEdit extends ConsumerStatefulWidget {
  final TeamMatchPerson? teamMatchPerson;
  final TeamMatch? initialTeamMatch;
  final Organization initialOrganization;
  final Person? initialPerson;

  const TeamMatchPersonEdit({
    this.teamMatchPerson,
    this.initialTeamMatch,
    this.initialPerson,
    required this.initialOrganization,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => TeamMatchPersonEditState();
}

class TeamMatchPersonEditState extends ConsumerState<TeamMatchPersonEdit> {
  final _formKey = GlobalKey<FormState>();

  Iterable<TeamMatch>? _availableTeamMatchs;
  Iterable<Person>? _availablePersons;
  TeamMatch? _teamMatch;
  Person? _person;
  late PersonRole? _personRole;

  @override
  void initState() {
    super.initState();
    _teamMatch = widget.teamMatchPerson?.teamMatch ?? widget.initialTeamMatch;
    _person = widget.teamMatchPerson?.person ?? widget.initialPerson;
    _personRole = widget.teamMatchPerson?.role;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    final navigator = Navigator.of(context);

    final items = [
      ListTile(
        title: SearchableDropdown<Person>(
          icon: const Icon(Icons.person),
          selectedItem: _person,
          label: localizations.person,
          context: context,
          allowEmpty: false,
          onSaved:
              (Person? value) => setState(() {
                _person = value;
              }),
          itemAsString: (u) => u.fullName,
          asyncItems: (String filter) async {
            _availablePersons ??= await (await ref.read(
              dataManagerNotifierProvider,
            )).readMany<Person, Organization>(filterObject: widget.initialOrganization);
            return _availablePersons!.toList();
          },
        ),
      ),
      ListTile(
        title: SearchableDropdown<TeamMatch>(
          icon: const Icon(Icons.leaderboard),
          selectedItem: _teamMatch,
          label: localizations.match,
          context: context,
          allowEmpty: false,
          onSaved:
              (TeamMatch? value) => setState(() {
                _teamMatch = value;
              }),
          itemAsString: (u) => u.localize(context),
          asyncItems: (String filter) async {
            _availableTeamMatchs ??= await (await ref.read(
              dataManagerNotifierProvider,
            )).readMany<TeamMatch, Organization>(filterObject: widget.initialOrganization);
            return _availableTeamMatchs!.toList();
          },
        ),
      ),
      ListTile(
        leading: const Icon(Icons.label),
        title: ButtonTheme(
          alignedDropdown: true,
          child: SimpleDropdown<PersonRole>(
            isNullable: false,
            label: localizations.role,
            isExpanded: true,
            options: PersonRole.values.map((value) => MapEntry(value, Text(value.localize(context)))),
            selected: _personRole,
            onSaved: (newValue) => _personRole = newValue,
          ),
        ),
      ),
    ];
    return Form(
      key: _formKey,
      child: EditWidget(
        typeLocalization: '${localizations.person} (${localizations.match})',
        id: widget.teamMatchPerson?.id,
        onSubmit: () => handleSubmit(navigator),
        items: items,
      ),
    );
  }

  Future<void> handleSubmit(NavigatorState navigator) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(
        TeamMatchPerson(id: widget.teamMatchPerson?.id, person: _person!, teamMatch: _teamMatch!, role: _personRole!),
      );
      navigator.pop();
    }
  }
}
