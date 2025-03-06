import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/season.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/weight_class_edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/card.dart';
import 'package:wrestling_scoreboard_client/view/widgets/formatter.dart';
import 'package:wrestling_scoreboard_client/view/widgets/toggle_buttons.dart';
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
  late int _seasonPartition;

  @override
  void initState() {
    super.initState();
    _seasonPartition = widget.leagueWeightClass?.seasonPartition ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    return buildEdit(context, id: widget.leagueWeightClass?.id, classLocale: localizations.weightClass, fields: [
      IconCard(icon: const Icon(Icons.info), child: Text(localizations.infoUseDivisionWeightClass)),
      ListTile(
        leading: const Icon(Icons.format_list_numbered),
        title: TextFormField(
          initialValue: widget.leagueWeightClass?.pos.toString() ?? '',
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
      if (widget.initialLeague.division.seasonPartitions > 1)
        ListTile(
          leading: const Icon(Icons.sunny_snowing),
          title: IndexedToggleButtons(
            label: localizations.seasonPartition,
            onPressed: (e) => setState(() => _seasonPartition = e),
            selected: _seasonPartition,
            numOptions: widget.initialLeague.division.seasonPartitions,
            getTitle: (e) => e.asSeasonPartition(context, widget.initialLeague.division.seasonPartitions),
          ),
        ),
    ]);
  }

  @override
  Future<void> handleNested(weightClass) async {
    var leagueWeightClass = LeagueWeightClass(
      id: widget.leagueWeightClass?.id,
      league: widget.initialLeague,
      pos: _pos,
      weightClass: weightClass,
      seasonPartition: _seasonPartition,
    );
    leagueWeightClass = leagueWeightClass
        .copyWithId(await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(leagueWeightClass));
  }
}
