import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class TeamClubAffiliationEdit extends ConsumerStatefulWidget {
  final TeamClubAffiliation? affiliation;
  final Team? initialTeam;
  final Club? initialClub;

  const TeamClubAffiliationEdit({
    this.affiliation,
    this.initialTeam,
    this.initialClub,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => TeamEditState();
}

class TeamEditState extends ConsumerState<TeamClubAffiliationEdit> {
  final _formKey = GlobalKey<FormState>();

  List<Team>? _availableTeams;
  List<Club>? _availableClubs;
  Team? _team;
  Club? _club;

  @override
  void initState() {
    super.initState();
    _team = widget.affiliation?.team ?? widget.initialTeam;
    _club = widget.affiliation?.club ?? widget.initialClub;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    final navigator = Navigator.of(context);

    final items = [
      ListTile(
        title: SearchableDropdown<Team>(
          icon: const Icon(Icons.group),
          selectedItem: _team,
          label: localizations.team,
          context: context,
          onSaved: (Team? value) => setState(() {
            _team = value;
          }),
          itemAsString: (u) => u.name,
          asyncItems: (String filter) async {
            _availableTeams ??= await (await ref.read(dataManagerNotifierProvider)).readMany<Team, Null>();
            return _availableTeams!.toList();
          },
        ),
      ),
      ListTile(
        title: SearchableDropdown<Club>(
          icon: const Icon(Icons.foundation),
          selectedItem: _club,
          label: localizations.club,
          context: context,
          onSaved: (Club? value) => setState(() {
            _club = value;
          }),
          itemAsString: (u) => u.name,
          asyncItems: (String filter) async {
            _availableClubs ??= await (await ref.read(dataManagerNotifierProvider)).readMany<Club, Null>();
            return _availableClubs!.toList();
          },
        ),
      ),
    ];

    return Form(
      key: _formKey,
      child: EditWidget(
        typeLocalization: localizations.teamClubAffiliation,
        id: widget.affiliation?.id,
        onSubmit: () => handleSubmit(navigator),
        items: items,
      ),
    );
  }

  Future<void> handleSubmit(NavigatorState navigator) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(TeamClubAffiliation(
        id: widget.affiliation?.id,
        team: _team!,
        club: _club!,
      ));
      navigator.pop();
    }
  }
}
