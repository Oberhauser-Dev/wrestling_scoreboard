import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/bout_edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/formatter.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class TeamMatchBoutEdit extends BoutEdit {
  final TeamMatchBout? teamMatchBout;
  final TeamMatch initialTeamMatch;

  TeamMatchBoutEdit({this.teamMatchBout, required this.initialTeamMatch, super.key})
      : super(
          bout: teamMatchBout?.bout,
          lineupRed: initialTeamMatch.home,
          lineupBlue: initialTeamMatch.guest,
          boutConfig: initialTeamMatch.league?.division.boutConfig ?? TeamMatch.defaultBoutConfig,
        );

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => TeamMatchBoutEditState();
}

class TeamMatchBoutEditState extends BoutEditState<TeamMatchBoutEdit> {
  int _pos = 0;

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
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
          inputFormatters: <TextInputFormatter>[NumericalRangeFormatter(min: 1, max: 1000)],
          onSaved: (String? value) {
            _pos = int.tryParse(value ?? '') ?? 0;
          },
        ),
      ),
    ]);
  }

  @override
  Future<void> handleNested(bout) async {
    var teamMatchBout = TeamMatchBout(
      id: widget.teamMatchBout?.id,
      teamMatch: widget.initialTeamMatch,
      pos: _pos,
      bout: bout,
    );
    teamMatchBout = teamMatchBout
        .copyWithId(await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(teamMatchBout));
  }

  @override
  Future<List<WeightClass>> get availableWeightClasses async => (await ref.read(dataManagerNotifierProvider))
      .readMany<WeightClass, Division>(filterObject: widget.initialTeamMatch.league?.division);
}
