import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String? _eligibilityStatusText;

  @override
  void initState() {
    super.initState();
    _membership = widget.competitionParticipation?.membership;
    _lineup = widget.competitionParticipation?.lineup ?? widget.initialLineup;
    _weightCategory = widget.competitionParticipation?.weightCategory ?? widget.initialWeightCategory;
    _weight = widget.competitionParticipation?.weight;
    _contestantStatus = widget.competitionParticipation?.contestantStatus;
    // Existing participations are shown as stored, a new one is prefilled when selecting the membership.
    _eligibilityStatusText = widget.competitionParticipation?.eligibilityStatusText;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    final navigator = Navigator.of(context);

    final items = [
      ListTile(
        title: SearchableDropdown<CompetitionLineup>.stringItems(
          allowEmpty: false,
          icon: const Icon(Icons.view_list),
          selectedItem: _lineup,
          label: localizations.lineup,
          context: context,
          onSaved: (value) => setState(() {
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
          onChange: (value) => setState(() {
            _membership = value;
            // Prefill the status of the new wrestler, it can still be adapted by hand.
            _eligibilityStatusText = value == null
                ? null
                : widget.initialCompetition.organization?.suggestEligibilityStatusText(
                    value.person,
                    date: widget.initialCompetition.date,
                  );
          }),
          onSave: (value) => setState(() {
            _membership = value;
          }),
        ),
      ),
      CustomTextInput.icon(
        // Recreate the field to show the prefilled status of a newly selected wrestler.
        key: ValueKey(_membership),
        iconData: Icons.badge,
        label: localizations.status,
        initialValue: _eligibilityStatusText,
        inputFormatters: [LengthLimitingTextInputFormatter(100)],
        onSaved: (value) {
          final trimmed = value?.trim();
          _eligibilityStatusText = (trimmed == null || trimmed.isEmpty) ? null : trimmed;
        },
      ),
      ListTile(
        title: SearchableDropdown<CompetitionWeightCategory>.stringItems(
          allowEmpty: false,
          icon: const Icon(Icons.category),
          selectedItem: _weightCategory,
          label: localizations.weightCategory,
          context: context,
          onSaved: (value) => setState(() {
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
        title: SimpleDropdown<ContestantStatus>(
          label: localizations.result,
          isNullable: true,
          selected: _contestantStatus,
          options: ContestantStatus.values.map(
            (status) => DropdownMenuEntry(value: status, label: status.localize(context)),
          ),
          onSaved: (newValue) => _contestantStatus = newValue,
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
        eligibilityStatusText: _eligibilityStatusText,
        poolDrawNumbers: widget.competitionParticipation?.poolDrawNumbers ?? [],
        poolGroups: widget.competitionParticipation?.poolGroups ?? [],
      );
      await (await ref.read(dataManagerProvider)).createOrUpdateSingle(cParticipation);
      navigator.pop();
    }
  }
}
