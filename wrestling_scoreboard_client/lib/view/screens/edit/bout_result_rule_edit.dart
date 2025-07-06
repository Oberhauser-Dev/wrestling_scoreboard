import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/bout_config.dart';
import 'package:wrestling_scoreboard_client/localization/bout_result.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/wrestling_style.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/form.dart';
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
  WrestlingStyle? _wrestlingStyle;

  @override
  void initState() {
    _boutConfig = widget.boutResultRule?.boutConfig ?? widget.initialBoutConfig;
    _boutResult = widget.boutResultRule?.boutResult ?? BoutResult.vpo;
    _winnerClassificationPoints = widget.boutResultRule?.winnerClassificationPoints ?? 4;
    _loserClassificationPoints = widget.boutResultRule?.loserClassificationPoints ?? 0;
    _winnerTechnicalPoints = widget.boutResultRule?.winnerTechnicalPoints;
    _loserTechnicalPoints = widget.boutResultRule?.loserTechnicalPoints;
    _technicalPointsDifference = widget.boutResultRule?.technicalPointsDifference;
    _wrestlingStyle = widget.boutResultRule?.style;
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
        leading: const Icon(Icons.style),
        title: ButtonTheme(
          alignedDropdown: true,
          child: SimpleDropdown<WrestlingStyle>(
            isNullable: true,
            hint: localizations.wrestlingStyle,
            isExpanded: true,
            options: WrestlingStyle.values.map((WrestlingStyle style) {
              return MapEntry(style, Text('${style.localize(context)} (${style.abbreviation(context)})'));
            }),
            selected: _wrestlingStyle,
            onChange:
                (newValue) => setState(() {
                  _wrestlingStyle = newValue;
                }),
          ),
        ),
      ),
      NumericalInput(
        iconData: Icons.pin,
        initialValue: widget.boutResultRule?.winnerClassificationPoints,
        label: '${localizations.classificationPoints} ${localizations.winner}',
        inputFormatter: NumericalRangeFormatter(min: 0, max: 1000),
        isMandatory: true,
        onSaved: (int? value) => _winnerClassificationPoints = value ?? 0,
      ),
      NumericalInput(
        iconData: Icons.pin,
        initialValue: widget.boutResultRule?.loserClassificationPoints,
        label: '${localizations.classificationPoints} ${localizations.loser}',
        inputFormatter: NumericalRangeFormatter(min: 0, max: 1000),
        isMandatory: true,
        onSaved: (int? value) => _loserClassificationPoints = value ?? 0,
      ),
      NumericalInput(
        iconData: Icons.pin_outlined,
        initialValue: widget.boutResultRule?.winnerTechnicalPoints,
        label: '${localizations.technicalPoints} ${localizations.winner}',
        inputFormatter: NumericalRangeFormatter(min: 0, max: 1000),
        isMandatory: false,
        onSaved: (int? value) => _winnerTechnicalPoints = value,
      ),
      NumericalInput(
        iconData: Icons.pin_outlined,
        initialValue: widget.boutResultRule?.loserTechnicalPoints,
        label: '${localizations.technicalPoints} ${localizations.loser}',
        inputFormatter: NumericalRangeFormatter(min: 0, max: 1000),
        isMandatory: false,
        onSaved: (int? value) => _loserTechnicalPoints = value,
      ),
      NumericalInput(
        iconData: Icons.difference,
        initialValue: widget.boutResultRule?.technicalPointsDifference,
        label: '${localizations.technicalPoints} ${localizations.difference}',
        inputFormatter: NumericalRangeFormatter(min: 0, max: 1000),
        isMandatory: false,
        onSaved: (int? value) => _technicalPointsDifference = value,
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
        style: _wrestlingStyle,
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
