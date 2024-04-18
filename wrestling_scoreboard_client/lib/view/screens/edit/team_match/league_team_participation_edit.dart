import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class LeagueTeamParticipationEdit extends ConsumerStatefulWidget {
  final LeagueTeamParticipation? participation;
  final Team? initialTeam;
  final League? initialLeague;

  const LeagueTeamParticipationEdit({
    this.participation,
    this.initialTeam,
    this.initialLeague,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => TeamEditState();
}

class TeamEditState extends ConsumerState<LeagueTeamParticipationEdit> {
  final _formKey = GlobalKey<FormState>();

  List<Team>? availableTeams;
  List<League>? _availableLeagues;
  Team? _team;
  League? _league;

  @override
  void initState() {
    super.initState();
    _team = widget.participation?.team ?? widget.initialTeam;
    _league = widget.participation?.league ?? widget.initialLeague;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
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
            availableTeams ??= await (await ref.read(dataManagerNotifierProvider)).readMany<Team, Null>();
            return availableTeams!.toList();
          },
        ),
      ),
      ListTile(
        title: SearchableDropdown<League>(
          icon: const Icon(Icons.emoji_events),
          selectedItem: _league,
          label: localizations.league,
          context: context,
          onSaved: (League? value) => setState(() {
            _league = value;
          }),
          itemAsString: (u) => u.name,
          asyncItems: (String filter) async {
            _availableLeagues ??= await (await ref.read(dataManagerNotifierProvider)).readMany<League, Null>();
            return _availableLeagues!.toList();
          },
        ),
      ),
    ];

    return Form(
      key: _formKey,
      child: EditWidget(
        typeLocalization: localizations.participatingTeam,
        id: widget.participation?.id,
        onSubmit: () => handleSubmit(navigator),
        items: items,
      ),
    );
  }

  Future<void> handleSubmit(NavigatorState navigator) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(LeagueTeamParticipation(
        id: widget.participation?.id,
        team: _team!,
        league: _league!,
      ));
      navigator.pop();
    }
  }
}
