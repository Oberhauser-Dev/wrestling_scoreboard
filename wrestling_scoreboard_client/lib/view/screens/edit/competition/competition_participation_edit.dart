import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/contestant_status.dart';
import 'package:wrestling_scoreboard_client/provider/data_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/utils/provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/components/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/form.dart';
import 'package:wrestling_scoreboard_client/view/widgets/formatter.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class CompetitionParticipationEdit extends ConsumerStatefulWidget {
  final CompetitionParticipation? competitionParticipation;
  final CompetitionLineup? initialLineup;
  final CompetitionWeightCategory? initialWeightCategory;
  final Competition initialCompetition;

  const CompetitionParticipationEdit({
    this.competitionParticipation,
    this.initialLineup,
    this.initialWeightCategory,
    required this.initialCompetition,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => CompetitionParticipationEditState();
}

class CompetitionParticipationEditState extends ConsumerState<CompetitionParticipationEdit> {
  final _formKey = GlobalKey<FormState>();

  Iterable<CompetitionLineup>? _availableLineups;
  Iterable<Membership>? _availableMemberships;
  Iterable<CompetitionWeightCategory>? _availableWeightCategories;

  Membership? _membership;
  CompetitionLineup? _lineup;
  CompetitionWeightCategory? _weightCategory;
  ContestantStatus? _contestantStatus;
  double? _weight;

  @override
  void initState() {
    super.initState();
    _membership = widget.competitionParticipation?.membership;
    _lineup = widget.competitionParticipation?.lineup ?? widget.initialLineup;
    _weightCategory = widget.competitionParticipation?.weightCategory ?? widget.initialWeightCategory;
    _weight = widget.competitionParticipation?.weight;
    _contestantStatus = widget.competitionParticipation?.contestantStatus;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    final navigator = Navigator.of(context);

    final items = [
      ListTile(
        title: SearchableDropdown<CompetitionLineup>(
          allowEmpty: false,
          icon: const Icon(Icons.view_list),
          selectedItem: _lineup,
          label: localizations.lineup,
          context: context,
          onSaved:
              (value) => setState(() {
                _lineup = value;
              }),
          onChanged: (value) {
            _lineup = value;
            // Reset Memberships when club has changed.
            setState(() {
              _availableMemberships = null;
            });
          },
          itemAsString: (u) => u.club.name,
          asyncItems: (String filter) async {
            _availableLineups ??= await (await ref.read(
              dataManagerProvider,
            )).readMany<CompetitionLineup, Competition>(filterObject: widget.initialCompetition);
            return _availableLineups!.toList();
          },
        ),
      ),
      ListTile(
        leading: Icon(Icons.person),
        title: MembershipDropdown(
          label: localizations.membership,
          getOrSetMemberships: () async => _getMemberships(),
          organization: widget.initialCompetition.organization,
          selectedItem: _membership,
          allowEmpty: false,
          onSave:
              (value) => setState(() {
                _membership = value;
              }),
        ),
      ),
      ListTile(
        title: SearchableDropdown<CompetitionWeightCategory>(
          allowEmpty: false,
          icon: const Icon(Icons.category),
          selectedItem: _weightCategory,
          label: localizations.weightCategory,
          context: context,
          onSaved:
              (value) => setState(() {
                _weightCategory = value;
              }),
          itemAsString: (w) => w.name,
          asyncItems: (String filter) async {
            _availableWeightCategories ??= await (await ref.read(
              dataManagerProvider,
            )).readMany<CompetitionWeightCategory, Competition>(filterObject: widget.initialCompetition);
            return _availableWeightCategories!.toList();
          },
        ),
      ),
      NumericalInput(
        iconData: Icons.fitness_center,
        label: localizations.weight,
        isMandatory: false,
        initialValue: _weight,
        inputFormatter: NumericalRangeFormatter(min: 1, max: 1000),
        onSaved: (value) => _weight = value,
      ),
      ListTile(
        leading: const Icon(Icons.cancel_outlined),
        title: ButtonTheme(
          alignedDropdown: true,
          child: SimpleDropdown<ContestantStatus>(
            label: localizations.result,
            isNullable: true,
            selected: _contestantStatus,
            options: ContestantStatus.values.map((status) => MapEntry(status, Text(status.localize(context)))),
            onSaved: (newValue) => _contestantStatus = newValue,
          ),
        ),
      ),
    ];

    return Form(
      key: _formKey,
      child: EditWidget(
        typeLocalization: localizations.participation,
        id: widget.competitionParticipation?.id,
        onSubmit: () => handleSubmit(navigator),
        items: items,
      ),
    );
  }

  Future<Iterable<Membership>> _getMemberships() async {
    if (_availableMemberships == null && _lineup != null) {
      _availableMemberships = await ref.readAsync(
        manyDataStreamProvider<Membership, Club>(
          ManyProviderData<Membership, Club>(filterObject: _lineup!.club),
        ).future,
      );
    }
    return _availableMemberships ?? [];
  }

  Future<void> handleSubmit(NavigatorState navigator) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final CompetitionParticipation cParticipation = CompetitionParticipation(
        id: widget.competitionParticipation?.id,
        lineup: _lineup!,
        membership: _membership!,
        weightCategory: _weightCategory,
        weight: _weight,
        contestantStatus: _contestantStatus,
        poolDrawNumber: widget.competitionParticipation?.poolDrawNumber,
        poolGroup: widget.competitionParticipation?.poolDrawNumber,
      );
      await (await ref.read(dataManagerProvider)).createOrUpdateSingle(cParticipation);
      navigator.pop();
    }
  }
}
