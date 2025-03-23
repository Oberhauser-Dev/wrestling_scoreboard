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

class TeamMatchBoutEdit extends BoutEdit {
  final TeamMatchBout? teamMatchBout;
  final TeamMatch initialTeamMatch;

  TeamMatchBoutEdit({this.teamMatchBout, required this.initialTeamMatch, super.key})
      : super(
          bout: teamMatchBout?.bout,
          boutConfig: initialTeamMatch.league?.division.boutConfig ?? TeamMatch.defaultBoutConfig,
        );

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => TeamMatchBoutEditState();
}

class TeamMatchBoutEditState extends BoutEditState<TeamMatchBoutEdit> {
  int _pos = 0;
  WeightClass? _weightClass;

  Iterable<Membership>? _redMemberships;
  Iterable<Membership>? _blueMemberships;

  @override
  void initState() {
    super.initState();
    _weightClass = widget.teamMatchBout?.weightClass;
  }

  Future<Iterable<Membership>> _getMemberships(TeamLineup lineup) async {
    final clubs = await ref.readAsync(manyDataStreamProvider<Club, Team>(
      ManyProviderData<Club, Team>(filterObject: lineup.team),
    ).future);

    final clubMemberships = await Future.wait(clubs.map((club) async {
      return await ref.readAsync(manyDataStreamProvider<Membership, Club>(
        ManyProviderData<Membership, Club>(filterObject: club),
      ).future);
    }));

    return clubMemberships.expand((membership) => membership);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    return buildEdit(
      context,
      id: widget.teamMatchBout?.id,
      classLocale: localizations.bout,
      getRedMemberships: () async {
        _redMemberships ??= await _getMemberships(widget.initialTeamMatch.home);
        return _redMemberships!;
      },
      getBlueMemberships: () async {
        _blueMemberships ??= await _getMemberships(widget.initialTeamMatch.guest);
        return _blueMemberships!;
      },
      fields: [
        ListTile(
          leading: const Icon(Icons.format_list_numbered),
          title: TextFormField(
            initialValue: widget.teamMatchBout?.pos.toString() ?? '',
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
          title: SearchableDropdown<WeightClass>(
            icon: const Icon(Icons.fitness_center),
            selectedItem: _weightClass,
            label: context.l10n.weightClass,
            context: context,
            onSaved: (WeightClass? value) => setState(() {
              _weightClass = value;
            }),
            itemAsString: (u) => u.name,
            asyncItems: (String filter) async {
              final boutWeightClasses = await availableWeightClasses;
              return boutWeightClasses.toList();
            },
          ),
        ),
      ],
    );
  }

  @override
  Future<void> handleNested(bout) async {
    var teamMatchBout = TeamMatchBout(
      id: widget.teamMatchBout?.id,
      teamMatch: widget.initialTeamMatch,
      pos: _pos,
      bout: bout,
      weightClass: _weightClass,
    );
    teamMatchBout = teamMatchBout
        .copyWithId(await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(teamMatchBout));
  }

  Future<List<WeightClass>> get availableWeightClasses async {
    // TODO: recheck if where the calculation is done for weightClasses: Server or Client
    final List<WeightClass> weightClasses = [];
    weightClasses.addAll(await (await ref.read(dataManagerNotifierProvider))
        .readMany<WeightClass, League>(filterObject: widget.initialTeamMatch.league));
    if (weightClasses.isEmpty) {
      weightClasses.addAll(await (await ref.read(dataManagerNotifierProvider))
          .readMany<WeightClass, Division>(filterObject: widget.initialTeamMatch.league?.division));
    }
    return weightClasses;
  }
}
