import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/ui/edit/weight_class_edit.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';

class LeagueWeightClassEdit extends WeightClassEdit {
  final LeagueWeightClass? leagueWeightClass;
  final League initialLeague;

  LeagueWeightClassEdit({this.leagueWeightClass, required this.initialLeague, Key? key})
      : super(weightClass: leagueWeightClass?.weightClass, key: key);

  @override
  State<StatefulWidget> createState() => LeagueWeightClassEditState();
}

class LeagueWeightClassEditState extends WeightClassEditState<LeagueWeightClassEdit> {
  int _pos = 0;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return buildEdit(context, classLocale: localizations.weightClass, fields: [
      ListTile(
        title: TextFormField(
          initialValue: widget.leagueWeightClass?.pos.toString() ?? '',
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              icon: const Icon(Icons.format_list_numbered),
              contentPadding: const EdgeInsets.symmetric(vertical: 20),
              labelText: localizations.position),
          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^\d{1,3}'))],
          onSaved: (String? value) {
            _pos = value != null ? int.parse(value) : 0;
          },
        ),
      ),
    ]);
  }

  @override
  Future<void> handleNested(weightClass) async {
    final leagueWeightClass = LeagueWeightClass(
        id: widget.leagueWeightClass?.id, league: widget.initialLeague, pos: _pos, weightClass: weightClass);
    leagueWeightClass.id = await dataProvider.createOrUpdateSingle(leagueWeightClass);
  }
}
