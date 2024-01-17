import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/ui/edit/weight_class_edit.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class LeagueWeightClassEdit extends WeightClassEdit {
  final LeagueWeightClass? leagueWeightClass;
  final League initialLeague;

  LeagueWeightClassEdit({this.leagueWeightClass, required this.initialLeague, super.key})
      : super(weightClass: leagueWeightClass?.weightClass);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => LeagueWeightClassEditState();
}

class LeagueWeightClassEditState extends WeightClassEditState<LeagueWeightClassEdit> {
  int _pos = 0;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return buildEdit(context, id: widget.leagueWeightClass?.id, classLocale: localizations.weightClass, fields: [
      ListTile(
        leading: const Icon(Icons.format_list_numbered),
        title: TextFormField(
          initialValue: widget.leagueWeightClass?.pos.toString() ?? '',
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
            labelText: localizations.position,
          ),
          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^\d{1,3}'))],
          onSaved: (String? value) {
            _pos = int.tryParse(value ?? '') ?? 0;
          },
        ),
      ),
    ]);
  }

  @override
  Future<void> handleNested(weightClass) async {
    var leagueWeightClass = LeagueWeightClass(
        id: widget.leagueWeightClass?.id, league: widget.initialLeague, pos: _pos, weightClass: weightClass);
    leagueWeightClass =
        leagueWeightClass.copyWithId(await (await ref.read(dataManagerProvider)).createOrUpdateSingle(leagueWeightClass));
  }
}
