import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/weight_class_edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/formatter.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class CompetitionWeightCategoryEdit extends WeightClassEdit {
  final CompetitionWeightCategory? competitionWeightCategory;
  final Competition initialCompetition;

  CompetitionWeightCategoryEdit({this.competitionWeightCategory, required this.initialCompetition, super.key})
    : super(weightClass: competitionWeightCategory?.weightClass);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => CompetitionWeightCategoryEditState();
}

class CompetitionWeightCategoryEditState extends WeightClassEditState<CompetitionWeightCategoryEdit> {
  Iterable<AgeCategory>? _availableAgeCategories;
  AgeCategory? _ageCategory;
  CompetitionSystem? _competitionSystem;
  late int _poolGroupCount;

  @override
  void initState() {
    super.initState();
    _ageCategory = widget.competitionWeightCategory?.ageCategory;
    _competitionSystem = widget.competitionWeightCategory?.competitionSystem;
    _poolGroupCount = widget.competitionWeightCategory?.poolGroupCount ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    return buildEdit(
      context,
      id: widget.competitionWeightCategory?.id,
      classLocale: localizations.weightClass,
      fields: [
        ListTile(
          title: SearchableDropdown<AgeCategory>(
            icon: const Icon(Icons.school),
            selectedItem: _ageCategory,
            label: localizations.ageCategory,
            context: context,
            onSaved:
                (value) => setState(() {
                  _ageCategory = value;
                }),
            allowEmpty: false,
            itemAsString: (u) => u.name,
            asyncItems: (String filter) async {
              _availableAgeCategories ??= await (await ref.read(
                dataManagerNotifierProvider,
              )).readMany<AgeCategory, Organization>(filterObject: widget.initialCompetition.organization);
              return _availableAgeCategories!.toList();
            },
          ),
        ),
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
      ],
    );
  }

  @override
  Future<void> handleNested(weightClass) async {
    var competitionWeightCategory = CompetitionWeightCategory(
      id: widget.competitionWeightCategory?.id,
      weightClass: weightClass,
      competition: widget.competitionWeightCategory?.competition ?? widget.initialCompetition,
      ageCategory: _ageCategory!,
      poolGroupCount: _poolGroupCount,
      competitionSystem: _competitionSystem,
    );
    competitionWeightCategory = competitionWeightCategory.copyWithId(
      await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(competitionWeightCategory),
    );
  }
}
