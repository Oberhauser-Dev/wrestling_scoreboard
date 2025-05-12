import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/formatter.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class CompetitionSystemAffiliationEdit extends ConsumerStatefulWidget {
  final CompetitionSystemAffiliation? competitionSystemAffiliation;
  final Competition initialCompetition;

  const CompetitionSystemAffiliationEdit({
    this.competitionSystemAffiliation,
    required this.initialCompetition,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => CompetitionSystemAffiliationEditState();
}

class CompetitionSystemAffiliationEditState extends ConsumerState<CompetitionSystemAffiliationEdit> {
  final _formKey = GlobalKey<FormState>();
  CompetitionSystem? _competitionSystem;
  late int _poolGroupCount;
  int? _maxContestants;

  @override
  void initState() {
    super.initState();
    _competitionSystem = widget.competitionSystemAffiliation?.competitionSystem;
    _poolGroupCount = widget.competitionSystemAffiliation?.poolGroupCount ?? 1;
    _maxContestants = widget.competitionSystemAffiliation?.maxContestants;
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
            hint: localizations.result,
            isNullable: true,
            selected: _competitionSystem,
            options: CompetitionSystem.values.map(
              (system) => MapEntry(system, Tooltip(message: system.name, child: Text(system.name))),
            ),
            onChange:
                (newValue) => setState(() {
                  _competitionSystem = newValue;
                }),
          ),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.pool),
        title: TextFormField(
          initialValue: _poolGroupCount.toString(),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
            labelText: localizations.poolGroupCount,
          ),
          inputFormatters: <TextInputFormatter>[NumericalRangeFormatter(min: 1, max: 1000)],
          onSaved: (String? value) {
            _poolGroupCount = int.tryParse(value ?? '') ?? 1;
          },
        ),
      ),
      ListTile(
        leading: const Icon(Icons.vertical_align_top),
        title: TextFormField(
          initialValue: _maxContestants?.toString() ?? '',
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
            labelText: localizations.maximum,
          ),
          inputFormatters: <TextInputFormatter>[NumericalRangeFormatter(min: 1, max: 1000)],
          onSaved: (String? value) {
            _maxContestants = int.tryParse(value ?? '');
          },
        ),
      ),
    ];

    return Form(
      key: _formKey,
      child: EditWidget(
        typeLocalization: localizations.competitionSystem,
        id: widget.competitionSystemAffiliation?.id,
        onSubmit: () => handleSubmit(navigator),
        items: items,
      ),
    );
  }

  Future<void> handleSubmit(NavigatorState navigator) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      CompetitionSystemAffiliation csa = CompetitionSystemAffiliation(
        id: widget.competitionSystemAffiliation?.id,
        competition: widget.competitionSystemAffiliation?.competition ?? widget.initialCompetition,
        competitionSystem: _competitionSystem!,
        maxContestants: _maxContestants,
        poolGroupCount: _poolGroupCount,
      );
      await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(csa);
      navigator.pop();
    }
  }
}
