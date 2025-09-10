import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/person_role.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class CompetitionPersonEdit extends ConsumerStatefulWidget {
  final CompetitionPerson? competitionPerson;
  final Competition? initialCompetition;
  final Organization initialOrganization;
  final Person? initialPerson;

  const CompetitionPersonEdit({
    this.competitionPerson,
    this.initialCompetition,
    this.initialPerson,
    required this.initialOrganization,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => CompetitionPersonEditState();
}

class CompetitionPersonEditState extends ConsumerState<CompetitionPersonEdit> {
  final _formKey = GlobalKey<FormState>();

  Iterable<Competition>? _availableCompetitions;
  Iterable<Person>? _availablePersons;
  Competition? _competition;
  Person? _person;
  late PersonRole? _personRole;

  @override
  void initState() {
    super.initState();
    _competition = widget.competitionPerson?.competition ?? widget.initialCompetition;
    _person = widget.competitionPerson?.person ?? widget.initialPerson;
    _personRole = widget.competitionPerson?.role;
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
        title: SearchableDropdown<Competition>(
          icon: const Icon(Icons.leaderboard),
          selectedItem: _competition,
          label: localizations.competition,
          context: context,
          allowEmpty: false,
          onSaved:
              (Competition? value) => setState(() {
                _competition = value;
              }),
          itemAsString: (u) => u.name,
          asyncItems: (String filter) async {
            _availableCompetitions ??= await (await ref.read(
              dataManagerNotifierProvider,
            )).readMany<Competition, Organization>(filterObject: widget.initialOrganization);
            return _availableCompetitions!.toList();
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
        typeLocalization: '${localizations.person} (${localizations.competition})',
        id: widget.competitionPerson?.id,
        onSubmit: () => handleSubmit(navigator),
        items: items,
      ),
    );
  }

  Future<void> handleSubmit(NavigatorState navigator) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(
        CompetitionPerson(
          id: widget.competitionPerson?.id,
          person: _person!,
          competition: _competition!,
          role: _personRole!,
        ),
      );
      navigator.pop();
    }
  }
}
