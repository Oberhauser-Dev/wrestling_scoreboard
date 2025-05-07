import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/bout_config.dart';
import 'package:wrestling_scoreboard_client/localization/bout_result.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/formatter.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class BoutResultRuleEdit extends ConsumerStatefulWidget {
  final BoutResultRule? boutResultRule;
  final BoutConfig? initialBoutConfig;
  final Future<void> Function(BoutResultRule boutResultRule)? onCreated;

  const BoutResultRuleEdit({this.boutResultRule, this.initialBoutConfig, this.onCreated, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => BoutResultRuleEditState();
}

class BoutResultRuleEditState extends ConsumerState<BoutResultRuleEdit> {
  final _formKey = GlobalKey<FormState>();
  Iterable<BoutConfig>? _availableBoutConfigs;

  BoutConfig? _boutConfig;
  late BoutResult _boutResult;
  late int _winnerClassificationPoints;
  late int _loserClassificationPoints;
  int? _winnerTechnicalPoints;
  int? _loserTechnicalPoints;
  int? _technicalPointsDifference;

  @override
  void initState() {
    _boutConfig = widget.boutResultRule?.boutConfig ?? widget.initialBoutConfig;
    _boutResult = widget.boutResultRule?.boutResult ?? BoutResult.vpo;
    _winnerClassificationPoints = widget.boutResultRule?.winnerClassificationPoints ?? 4;
    _loserClassificationPoints = widget.boutResultRule?.loserClassificationPoints ?? 0;
    _winnerTechnicalPoints = widget.boutResultRule?.winnerTechnicalPoints;
    _loserTechnicalPoints = widget.boutResultRule?.loserTechnicalPoints;
    _technicalPointsDifference = widget.boutResultRule?.technicalPointsDifference;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    final navigator = Navigator.of(context);

    final items = [
      ListTile(
        leading: const Icon(Icons.label),
        title: ButtonTheme(
          alignedDropdown: true,
          child: SimpleDropdown<BoutResult>(
            hint: localizations.result,
            isNullable: false,
            selected: _boutResult,
            options: BoutResult.values.map(
              (BoutResult boutResult) => MapEntry(
                boutResult,
                Tooltip(message: boutResult.description(context), child: Text(boutResult.abbreviation(context))),
              ),
            ),
            onChange:
                (BoutResult? newValue) => setState(() {
                  _boutResult = newValue!;
                }),
          ),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.pin),
        title: TextFormField(
          initialValue: widget.boutResultRule?.winnerClassificationPoints.toString() ?? '',
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
            labelText: '${localizations.classificationPoints} ${localizations.winner}',
          ),
          inputFormatters: <TextInputFormatter>[NumericalRangeFormatter(min: 0, max: 1000)],
          onSaved: (String? value) {
            _winnerClassificationPoints = int.tryParse(value ?? '') ?? 0;
          },
        ),
      ),
      ListTile(
        leading: const Icon(Icons.pin),
        title: TextFormField(
          initialValue: widget.boutResultRule?.loserClassificationPoints.toString() ?? '',
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
            labelText: '${localizations.classificationPoints} ${localizations.loser}',
          ),
          inputFormatters: <TextInputFormatter>[NumericalRangeFormatter(min: 0, max: 1000)],
          onSaved: (String? value) {
            _loserClassificationPoints = int.tryParse(value ?? '') ?? 0;
          },
        ),
      ),
      ListTile(
        leading: const Icon(Icons.pin_outlined),
        title: TextFormField(
          initialValue: widget.boutResultRule?.winnerTechnicalPoints?.toString() ?? '',
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
            labelText: '${localizations.technicalPoints} ${localizations.winner}',
          ),
          inputFormatters: <TextInputFormatter>[NumericalRangeFormatter(min: 0, max: 1000)],
          onSaved: (String? value) {
            _winnerTechnicalPoints = int.tryParse(value ?? '');
          },
        ),
      ),
      ListTile(
        leading: const Icon(Icons.pin_outlined),
        title: TextFormField(
          initialValue: widget.boutResultRule?.loserTechnicalPoints?.toString() ?? '',
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
            labelText: '${localizations.technicalPoints} ${localizations.loser}',
          ),
          inputFormatters: <TextInputFormatter>[NumericalRangeFormatter(min: 0, max: 1000)],
          onSaved: (String? value) {
            _loserTechnicalPoints = int.tryParse(value ?? '');
          },
        ),
      ),
      ListTile(
        leading: const Icon(Icons.difference),
        title: TextFormField(
          initialValue: widget.boutResultRule?.technicalPointsDifference?.toString() ?? '',
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
            labelText: '${localizations.technicalPoints} ${localizations.difference}',
          ),
          inputFormatters: <TextInputFormatter>[NumericalRangeFormatter(min: 0, max: 1000)],
          onSaved: (String? value) {
            _technicalPointsDifference = int.tryParse(value ?? '');
          },
        ),
      ),
      ListTile(
        title: SearchableDropdown<BoutConfig>(
          icon: const Icon(Icons.tune),
          selectedItem: _boutConfig,
          label: localizations.boutConfig,
          context: context,
          onSaved:
              (BoutConfig? value) => setState(() {
                _boutConfig = value;
              }),
          allowEmpty: false,
          itemAsString: (u) => u.localize(context),
          asyncItems: (String filter) async {
            _availableBoutConfigs ??= await (await ref.read(dataManagerNotifierProvider)).readMany<BoutConfig, Null>();
            return _availableBoutConfigs!.toList();
          },
        ),
      ),
    ];

    return Form(
      key: _formKey,
      child: EditWidget(
        typeLocalization: localizations.boutResultRule,
        id: widget.boutResultRule?.id,
        onSubmit: () => handleSubmit(navigator),
        items: items,
      ),
    );
  }

  Future<void> handleSubmit(NavigatorState navigator) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      BoutResultRule boutResultRule = BoutResultRule(
        id: widget.boutResultRule?.id,
        boutResult: _boutResult,
        winnerClassificationPoints: _winnerClassificationPoints,
        loserClassificationPoints: _loserClassificationPoints,
        winnerTechnicalPoints: _winnerTechnicalPoints,
        loserTechnicalPoints: _loserTechnicalPoints,
        technicalPointsDifference: _technicalPointsDifference,
        boutConfig: _boutConfig!,
      );
      boutResultRule = boutResultRule.copyWithId(
        await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle<BoutResultRule>(boutResultRule),
      );
      if (widget.onCreated != null) {
        await widget.onCreated!(boutResultRule);
      }
      navigator.pop();
    }
  }
}
