import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/weight_class_edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/form.dart';
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
  Iterable<CompetitionAgeCategory>? _availableCompetitionAgeCategories;
  CompetitionAgeCategory? _competitionAgeCategory;
  CompetitionSystem? _competitionSystem;
  int? _poolGroupCount;
  int _pos = 0;

  @override
  void initState() {
    super.initState();
    _competitionAgeCategory = widget.competitionWeightCategory?.competitionAgeCategory;
    _competitionSystem = widget.competitionWeightCategory?.competitionSystem;
    _poolGroupCount = widget.competitionWeightCategory?.poolGroupCount;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    return buildEdit(
      context,
      id: widget.competitionWeightCategory?.id,
      classLocale: localizations.weightClass,
      fields: [
        NumericalInput(
          iconData: Icons.format_list_numbered,
          initialValue: widget.competitionWeightCategory?.pos,
          label: localizations.position,
          inputFormatter: NumericalRangeFormatter(min: 1, max: 1000),
          isMandatory: true,
          onSaved: (int? value) => _pos = value ?? 0,
        ),
        ListTile(
          title: SearchableDropdown<CompetitionAgeCategory>(
            icon: const Icon(Icons.school),
            selectedItem: _competitionAgeCategory,
            label: localizations.ageCategory,
            context: context,
            onSaved:
                (value) => setState(() {
                  _competitionAgeCategory = value;
                }),
            allowEmpty: false,
            itemAsString: (u) => u.ageCategory.name,
            asyncItems: (String filter) async {
              _availableCompetitionAgeCategories ??= (await (await ref.read(
                dataManagerProvider,
              )).readMany<CompetitionAgeCategory, Competition>(filterObject: widget.initialCompetition));
              return _availableCompetitionAgeCategories!.toList();
            },
          ),
        ),
        ListTile(
          leading: const Icon(Icons.label),
          title: ButtonTheme(
            alignedDropdown: true,
            child: SimpleDropdown<CompetitionSystem>(
              label: localizations.competitionSystem,
              isNullable: true,
              selected: _competitionSystem,
              options: CompetitionSystem.values.map(
                (system) => MapEntry(system, Tooltip(message: system.name, child: Text(system.name))),
              ),
              onSaved: (newValue) => _competitionSystem = newValue,
            ),
          ),
        ),
        NumericalInput(
          iconData: Icons.pool,
          initialValue: _poolGroupCount,
          label: localizations.poolGroupCount,
          inputFormatter: NumericalRangeFormatter(min: 1, max: 1000),
          isMandatory: false,
          onSaved: (int? value) => _poolGroupCount = value,
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
      competitionAgeCategory: _competitionAgeCategory!,
      poolGroupCount: _poolGroupCount ?? 1,
      competitionSystem: _competitionSystem,
      pos: _pos,
    );
    competitionWeightCategory = competitionWeightCategory.copyWithId(
      await (await ref.read(dataManagerProvider)).createOrUpdateSingle(competitionWeightCategory),
    );
  }
}
