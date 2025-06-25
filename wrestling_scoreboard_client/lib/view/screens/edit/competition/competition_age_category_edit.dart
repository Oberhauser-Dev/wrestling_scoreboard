import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/form.dart';
import 'package:wrestling_scoreboard_client/view/widgets/formatter.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class CompetitionAgeCategoryEdit extends ConsumerStatefulWidget {
  final CompetitionAgeCategory? competitionAgeCategory;
  final Competition initialCompetition;

  const CompetitionAgeCategoryEdit({this.competitionAgeCategory, required this.initialCompetition, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => CompetitionAgeCategoryEditState();
}

class CompetitionAgeCategoryEditState extends ConsumerState<CompetitionAgeCategoryEdit> {
  final _formKey = GlobalKey<FormState>();

  Iterable<AgeCategory>? _availableAgeCategories;
  AgeCategory? _ageCategory;
  late Competition _competition;
  int _pos = 0;

  @override
  void initState() {
    super.initState();
    _ageCategory = widget.competitionAgeCategory?.ageCategory;
    _competition = widget.competitionAgeCategory?.competition ?? widget.initialCompetition;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    final navigator = Navigator.of(context);

    final items = [
      NumericalInput(
        iconData: Icons.format_list_numbered,
        initialValue: widget.competitionAgeCategory?.pos,
        label: localizations.position,
        inputFormatter: NumericalRangeFormatter(min: 1, max: 1000),
        isMandatory: true,
        onSaved: (int? value) => _pos = value ?? 0,
      ),
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
    ];
    return Form(
      key: _formKey,
      child: EditWidget(
        typeLocalization: localizations.lineup,
        id: widget.competitionAgeCategory?.id,
        onSubmit: () => handleSubmit(navigator),
        items: items,
      ),
    );
  }

  Future<void> handleSubmit(NavigatorState navigator) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      CompetitionAgeCategory competitionAgeCategory = CompetitionAgeCategory(
        id: widget.competitionAgeCategory?.id,
        competition: _competition,
        ageCategory: _ageCategory!,
        pos: _pos,
      );
      competitionAgeCategory = competitionAgeCategory.copyWithId(
        await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(competitionAgeCategory),
      );
      navigator.pop();
    }
  }
}
