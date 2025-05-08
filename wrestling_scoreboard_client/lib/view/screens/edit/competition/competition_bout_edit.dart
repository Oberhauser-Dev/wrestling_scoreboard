import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/data_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/utils/provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/bout_edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/formatter.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class CompetitionBoutEdit extends BoutEdit {
  final CompetitionBout? competitionBout;
  final Competition initialCompetition;

  CompetitionBoutEdit({this.competitionBout, required this.initialCompetition, super.key})
    : super(bout: competitionBout?.bout, boutConfig: initialCompetition.boutConfig);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => CompetitionBoutEditState();
}

class CompetitionBoutEditState extends BoutEditState<CompetitionBoutEdit> {
  int _pos = 0;
  int? _mat;
  int? _round;
  CompetitionWeightCategory? _weightCategory;

  Iterable<Membership>? _memberships;

  @override
  void initState() {
    super.initState();
    _weightCategory = widget.competitionBout?.weightCategory;
    _mat = widget.competitionBout?.mat;
    _round = widget.competitionBout?.round;
  }

  Future<Iterable<Membership>> _getMemberships() async {
    final lineups = await ref.readAsync(
      manyDataStreamProvider<CompetitionLineup, Competition>(
        ManyProviderData<CompetitionLineup, Competition>(filterObject: widget.initialCompetition),
      ).future,
    );

    final participations = await Future.wait(
      lineups.map((lineup) async {
        return await ref.readAsync(
          manyDataStreamProvider<CompetitionParticipation, CompetitionLineup>(
            ManyProviderData<CompetitionParticipation, CompetitionLineup>(filterObject: lineup),
          ).future,
        );
      }),
    );

    return participations.expand((participations) => participations).map((e) => e.membership);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    return buildEdit(
      context,
      id: widget.competitionBout?.id,
      classLocale: localizations.bout,
      getRedMemberships: () async {
        _memberships ??= await _getMemberships();
        return _memberships!;
      },
      getBlueMemberships: () async {
        _memberships ??= await _getMemberships();
        return _memberships!;
      },
      fields: [
        ListTile(
          leading: const Icon(Icons.format_list_numbered),
          title: TextFormField(
            initialValue: widget.competitionBout?.pos.toString() ?? '',
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 20),
              labelText: localizations.position,
            ),
            inputFormatters: <TextInputFormatter>[NumericalRangeFormatter(min: 1, max: 1000)],
            onSaved: (String? value) {
              _pos = int.tryParse(value ?? '') ?? 0;
            },
          ),
        ),
        ListTile(
          leading: const Icon(Icons.adjust), // Replace with square_dot
          title: TextFormField(
            initialValue: _mat?.toString() ?? '',
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 20),
              labelText: localizations.mat,
            ),
            inputFormatters: <TextInputFormatter>[NumericalRangeFormatter(min: 1, max: 1000)],
            onSaved: (String? value) {
              _mat = int.tryParse(value ?? '') ?? 0;
            },
          ),
        ),
        ListTile(
          leading: const Icon(Icons.restart_alt),
          title: TextFormField(
            initialValue: _round?.toString() ?? '',
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 20),
              labelText: localizations.round,
            ),
            inputFormatters: <TextInputFormatter>[NumericalRangeFormatter(min: 1, max: 1000)],
            onSaved: (String? value) {
              _round = int.tryParse(value ?? '') ?? 0;
            },
          ),
        ),
        ListTile(
          title: SearchableDropdown<CompetitionWeightCategory>(
            icon: const Icon(Icons.fitness_center),
            selectedItem: _weightCategory,
            label: context.l10n.weightCategory,
            context: context,
            onSaved:
                (value) => setState(() {
                  _weightCategory = value;
                }),
            itemAsString: (u) => u.name,
            asyncItems: (String filter) async {
              final boutWeightClasses = await availableWeightCategories;
              return boutWeightClasses.toList();
            },
          ),
        ),
      ],
    );
  }

  @override
  Future<void> handleNested(bout) async {
    var competitionBout = CompetitionBout(
      id: widget.competitionBout?.id,
      competition: widget.initialCompetition,
      pos: _pos,
      bout: bout,
      weightCategory: _weightCategory,
      mat: _mat,
      round: _round,
    );
    competitionBout = competitionBout.copyWithId(
      await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(competitionBout),
    );
  }

  Future<List<CompetitionWeightCategory>> get availableWeightCategories async => (await ref.read(
    dataManagerNotifierProvider,
  )).readMany<CompetitionWeightCategory, Competition>(filterObject: widget.initialCompetition);
}
