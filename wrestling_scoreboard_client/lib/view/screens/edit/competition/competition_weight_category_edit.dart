import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/competition.dart';
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
  Iterable<CompetitionSystemAffiliation>? _availableCompetitionSystemAffiliations;
  CompetitionAgeCategory? _competitionAgeCategory;
  CompetitionSystemAffiliation? _competitionSystemAffiliation;
  int _pos = 0;

  @override
  void initState() {
    super.initState();
    _competitionAgeCategory = widget.competitionWeightCategory?.competitionAgeCategory;
    _competitionSystemAffiliation = widget.competitionWeightCategory?.competitionSystemAffiliation;
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
          title: SearchableDropdown<CompetitionSystemAffiliation>(
            icon: const Icon(Icons.account_tree),
            selectedItem: _competitionSystemAffiliation,
            label: localizations.competitionSystem,
            context: context,
            onSaved: (value) => setState(() => _competitionSystemAffiliation = value),
            allowEmpty: true,
            itemAsString: (u) => u.localize(context),
            asyncItems: (String filter) async {
              _availableCompetitionSystemAffiliations ??= (await (await ref.read(
                dataManagerProvider,
              )).readMany<CompetitionSystemAffiliation, Competition>(filterObject: widget.initialCompetition));
              return _availableCompetitionSystemAffiliations!.toList();
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
      competitionAgeCategory: _competitionAgeCategory!,
      competitionSystemAffiliation: _competitionSystemAffiliation,
      pos: _pos,
    );
    competitionWeightCategory = competitionWeightCategory.copyWithId(
      await (await ref.read(dataManagerProvider)).createOrUpdateSingle(competitionWeightCategory),
    );
  }
}
