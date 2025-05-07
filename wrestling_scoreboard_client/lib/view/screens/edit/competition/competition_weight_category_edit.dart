import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/weight_class_edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
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

  @override
  void initState() {
    super.initState();
    _ageCategory = widget.competitionWeightCategory?.ageCategory;
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
    );
    competitionWeightCategory = competitionWeightCategory.copyWithId(
      await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(competitionWeightCategory),
    );
  }
}
