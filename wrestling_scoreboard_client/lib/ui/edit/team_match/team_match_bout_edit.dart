import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_client/ui/edit/bout_edit.dart';
import 'package:wrestling_scoreboard_client/util/network/data_provider.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class TeamMatchBoutEdit extends BoutEdit {
  final TeamMatchBout? teamMatchBout;
  final TeamMatch initialTeamMatch;

  TeamMatchBoutEdit({this.teamMatchBout, required this.initialTeamMatch, super.key})
      : super(
          bout: teamMatchBout?.bout,
          lineupRed: initialTeamMatch.home,
          lineupBlue: initialTeamMatch.guest,
        );

  @override
  State<StatefulWidget> createState() => TeamMatchBoutEditState();
}

class TeamMatchBoutEditState extends BoutEditState<TeamMatchBoutEdit> {
  int _pos = 0;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return buildEdit(context, id: widget.teamMatchBout?.id, classLocale: localizations.bout, fields: [
      ListTile(
        leading: const Icon(Icons.format_list_numbered),
        title: TextFormField(
          initialValue: widget.teamMatchBout?.pos.toString() ?? '',
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
            labelText: localizations.position,
          ),
          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^\d{1,3}'))],
          onSaved: (String? value) {
            _pos = value != null ? int.parse(value) : 0;
          },
        ),
      ),
    ]);
  }

  @override
  Future<void> handleNested(bout) async {
    var teamMatchBout = TeamMatchBout(
        id: widget.teamMatchBout?.id, teamMatch: widget.initialTeamMatch, pos: _pos, bout: bout);
    teamMatchBout = teamMatchBout.copyWithId(await dataProvider.createOrUpdateSingle(teamMatchBout));
  }
}
