import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/season.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/weight_class_edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/form.dart';
import 'package:wrestling_scoreboard_client/view/widgets/formatter.dart';
import 'package:wrestling_scoreboard_client/view/widgets/toggle_buttons.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class DivisionWeightClassEdit extends WeightClassEdit {
  final DivisionWeightClass? divisionWeightClass;
  final Division initialDivision;

  DivisionWeightClassEdit({this.divisionWeightClass, required this.initialDivision, super.key})
    : super(weightClass: divisionWeightClass?.weightClass);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => DivisionWeightClassEditState();
}

class DivisionWeightClassEditState extends WeightClassEditState<DivisionWeightClassEdit> {
  int _pos = 0;
  late int _seasonPartition;

  @override
  void initState() {
    super.initState();
    _seasonPartition = widget.divisionWeightClass?.seasonPartition ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    return buildEdit(
      context,
      id: widget.divisionWeightClass?.id,
      classLocale: localizations.weightClass,
      fields: [
        NumericalInput(
          iconData: Icons.format_list_numbered,
          initialValue: widget.divisionWeightClass?.pos,
          label: localizations.position,
          inputFormatter: NumericalRangeFormatter(min: 1, max: 1000),
          isMandatory: true,
          onSaved: (int? value) => _pos = value ?? 0,
        ),
        if (widget.initialDivision.seasonPartitions > 1)
          ListTile(
            leading: const Icon(Icons.sunny_snowing),
            title: IndexedToggleButtons(
              label: localizations.seasonPartition,
              onPressed: (e) => setState(() => _seasonPartition = e),
              selected: _seasonPartition,
              numOptions: widget.initialDivision.seasonPartitions,
              getTitle: (e) => e.asSeasonPartition(context, widget.initialDivision.seasonPartitions),
            ),
          ),
      ],
    );
  }

  @override
  Future<void> handleNested(weightClass) async {
    var divisionWeightClass = DivisionWeightClass(
      id: widget.divisionWeightClass?.id,
      division: widget.initialDivision,
      pos: _pos,
      weightClass: weightClass,
      seasonPartition: _seasonPartition,
    );
    divisionWeightClass = divisionWeightClass.copyWithId(
      await (await ref.read(dataManagerProvider)).createOrUpdateSingle(divisionWeightClass),
    );
  }
}
