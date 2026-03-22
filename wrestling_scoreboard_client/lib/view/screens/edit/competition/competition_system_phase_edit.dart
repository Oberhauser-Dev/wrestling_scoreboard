import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/form.dart';
import 'package:wrestling_scoreboard_client/view/widgets/formatter.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class CompetitionSystemPhaseEdit extends ConsumerStatefulWidget {
  final CompetitionSystemPhase? competitionSystemPhase;
  final CompetitionSystemAffiliation initialCompetitionSystemAffiliation;

  const CompetitionSystemPhaseEdit({
    this.competitionSystemPhase,
    required this.initialCompetitionSystemAffiliation,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => CompetitionSystemAffiliationEditState();
}

class CompetitionSystemAffiliationEditState extends ConsumerState<CompetitionSystemPhaseEdit> {
  final _formKey = GlobalKey<FormState>();
  late CompetitionSystem _competitionSystem;
  late int _poolGroupCount;
  int? _maxRank;
  late bool _isCrossOver;
  int? _pos;

  @override
  void initState() {
    super.initState();
    _competitionSystem = widget.competitionSystemPhase?.competitionSystem ?? CompetitionSystem.nordic;
    _poolGroupCount = widget.competitionSystemPhase?.poolGroupCount ?? 1;
    _maxRank = widget.competitionSystemPhase?.maxRank ?? 3;
    _isCrossOver = widget.competitionSystemPhase?.isCrossOver ?? false;
    _pos = widget.competitionSystemPhase?.pos;
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
          child: SimpleDropdown<CompetitionSystem>(
            label: localizations.competitionSystem,
            isNullable: false,
            selected: _competitionSystem,
            options: CompetitionSystem.values.map(
              (system) => MapEntry(system, Tooltip(message: system.name, child: Text(system.name))),
            ),
            onSaved: (newValue) {
              if (newValue != null) _competitionSystem = newValue;
            },
          ),
        ),
      ),
      NumericalInput(
        iconData: Icons.pool,
        initialValue: _poolGroupCount,
        label: localizations.poolGroupCount,
        inputFormatter: NumericalRangeFormatter(min: 1, max: 1000),
        isMandatory: true,
        onSaved: (int? value) => _poolGroupCount = value ?? 1,
      ),
      CheckboxListTile(
        secondary: const Icon(Icons.shuffle),
        title: Text(localizations.crossOver),
        value: _isCrossOver,
        onChanged: (e) => setState(() => _isCrossOver = e ?? false),
      ),
      NumericalInput(
        iconData: Icons.vertical_align_top,
        initialValue: _maxRank,
        label: '${localizations.rank} (${localizations.maximum})',
        inputFormatter: NumericalRangeFormatter(min: 0, max: 1000),
        isMandatory: true,
        onSaved: (int? value) => _maxRank = value,
        // Display implications of max rank.
        onChanged: (int? value) => setState(() {
          _maxRank = value;
        }),
        subtitle: Text(localizations.holdBoutsForRanks(CompetitionSystemPhase.displayMaxRanks(_maxRank))),
      ),
      NumericalInput(
        iconData: Icons.format_list_numbered,
        initialValue: _pos,
        label: localizations.position,
        inputFormatter: NumericalRangeFormatter(min: 0, max: 1000),
        isMandatory: true,
        onSaved: (int? value) => _pos = value ?? 0,
      ),
    ];

    return Form(
      key: _formKey,
      child: EditWidget(
        typeLocalization: localizations.competitionSystem,
        id: widget.competitionSystemPhase?.id,
        onSubmit: () => handleSubmit(navigator),
        items: items,
      ),
    );
  }

  Future<void> handleSubmit(NavigatorState navigator) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final CompetitionSystemPhase csp = CompetitionSystemPhase(
        id: widget.competitionSystemPhase?.id,
        competitionSystemAffiliation:
            widget.competitionSystemPhase?.competitionSystemAffiliation ?? widget.initialCompetitionSystemAffiliation,
        competitionSystem: _competitionSystem,
        pos: _pos!,
        poolGroupCount: _poolGroupCount,
        isCrossOver: _isCrossOver,
        maxRank: _maxRank,
      );
      await (await ref.read(dataManagerProvider)).createOrUpdateSingle(csp);
      navigator.pop();
    }
  }
}
