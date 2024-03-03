import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/wrestling_style.dart';
import 'package:wrestling_scoreboard_client/provider/data_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_common/common.dart';

// TODO: dynamically add or remove participants without weight class
class LineupEdit extends ConsumerStatefulWidget {
  final Lineup lineup;
  final List<WeightClass> weightClasses;
  final List<Participation> participations;

  final Function()? onSubmitGenerate;

  const LineupEdit({
    super.key,
    required this.lineup,
    required this.weightClasses,
    required this.participations,
    this.onSubmitGenerate,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => LineupEditState();
}

class LineupEditState extends ConsumerState<LineupEdit> {
  final _formKey = GlobalKey<FormState>();

  Iterable<Membership>? memberships;

  Membership? _leader;
  Membership? _coach;
  late Map<WeightClass, Participation?> _participations;
  final HashSet<Participation> _deleteParticipations = HashSet();
  final HashSet<Participation> _createOrUpdateParticipations = HashSet();

  @override
  void initState() {
    super.initState();
    _leader = widget.lineup.leader;
    _coach = widget.lineup.coach;

    _participations = Map.fromEntries(widget.weightClasses.map((e) {
      final participation = widget.participations.singleWhereOrNull((participation) => participation.weightClass == e);
      return MapEntry(e, participation);
    }));
  }

  Future<void> handleSubmit(NavigatorState navigator, {void Function()? onSubmitGenerate}) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await (await ref.read(dataManagerNotifierProvider))
          .createOrUpdateSingle(Lineup(id: widget.lineup.id, team: widget.lineup.team, leader: _leader, coach: _coach));
      await Future.forEach(
          _deleteParticipations,
          (Participation element) async =>
              (await ref.read(dataManagerNotifierProvider)).deleteSingle<Participation>(element));
      await Future.forEach(_createOrUpdateParticipations,
          (Participation element) async => (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(element));
      if (onSubmitGenerate != null) onSubmitGenerate();
      navigator.pop();
    }
  }

  List<Widget> _buildActions(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);
    return [
      EditAction(
        icon: const Icon(Icons.save),
        label: Text(localizations.save),
        onSubmit: () => handleSubmit(navigator),
      ),
      EditAction(
        icon: const Icon(Icons.autorenew),
        label: Text(localizations.saveAndGenerate),
        onSubmit: () async {
          final hasConfirmed = await showDialog(
            context: context,
            builder: (context) => OkCancelDialog(
              getResult: () => true,
              child: Text(localizations.warningBoutGenerate),
            ),
          );
          if (hasConfirmed == true) {
            await handleSubmit(navigator, onSubmitGenerate: widget.onSubmitGenerate);
          }
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Form(
      key: _formKey,
      child: CustomizableEditWidget(
        typeLocalization: localizations.lineup,
        id: widget.lineup.id,
        buildActions: _buildActions,
        items: [
          ListTile(title: HeadingText(widget.lineup.team.name)),
          ListTile(
            title: getDropdown<Membership>(
              selectedItem: _leader,
              label: localizations.leader,
              context: context,
              onSaved: (Membership? value) => setState(() {
                _leader = value;
              }),
              itemAsString: (u) => u.person.fullName,
              onFind: (String? filter) => ParticipationEditTile.filterMemberships(ref, filter, widget.lineup),
            ),
          ),
          ListTile(
            title: getDropdown<Membership>(
              selectedItem: _coach,
              label: localizations.coach,
              context: context,
              onSaved: (Membership? value) => setState(() {
                _coach = value;
              }),
              itemAsString: (u) => u.person.fullName,
              onFind: (String? filter) => ParticipationEditTile.filterMemberships(ref, filter, widget.lineup),
            ),
          ),
          ..._participations.entries.map((mapEntry) {
            return ParticipationEditTile(
              lineup: widget.lineup,
              participation: mapEntry.value,
              weightClass: mapEntry.key,
              createOrUpdateParticipation: (participation) => _createOrUpdateParticipations.add(participation),
              deleteParticipation: (participation) => _deleteParticipations.add(participation),
            );
          }),
        ],
      ),
    );
  }
}

class ParticipationEditTile extends ConsumerStatefulWidget {
  final Participation? participation;
  final WeightClass weightClass;
  final Lineup lineup;
  final void Function(Participation participation) deleteParticipation;
  final void Function(Participation participation) createOrUpdateParticipation;

  const ParticipationEditTile({
    super.key,
    this.participation,
    required this.weightClass,
    required this.lineup,
    required this.deleteParticipation,
    required this.createOrUpdateParticipation,
  });

  static Future<List<Membership>> filterMemberships(
    WidgetRef ref,
    String? filter,
    Lineup lineup,
  ) async {
    final memberships = await _getMemberships(ref, club: lineup.team.club);
    return (filter == null ? memberships : memberships.where((element) => element.person.fullName.contains(filter)))
        .toList();
  }

  static Future<List<Membership>> _getMemberships(WidgetRef ref, {required Club club}) async {
    return ref.watch(manyDataStreamProvider<Membership, Club>(ManyProviderData(filterObject: club)).future);
  }

  @override
  ConsumerState<ParticipationEditTile> createState() => _ParticipationEditTileState();
}

class _ParticipationEditTileState extends ConsumerState<ParticipationEditTile> {
  Membership? _curMembership;
  double? _curWeight;

  @override
  void initState() {
    super.initState();
    _curMembership = widget.participation?.membership;
    _curWeight = widget.participation?.weight;
  }

  void onSave() {
    if (widget.participation?.membership == _curMembership && widget.participation?.weight == _curWeight) return;

    // Delete old participation, if membership is null
    if (_curMembership == null) {
      if (widget.participation?.id != null) {
        widget.deleteParticipation(widget.participation!);
      }
    } else {
      Participation curParticipation;
      if (widget.participation?.id != null) {
        // Reuse old participation if present
        curParticipation = widget.participation!.copyWith(
          membership: _curMembership!,
          lineup: widget.lineup,
          weightClass: widget.weightClass,
          weight: _curWeight,
        );
      } else {
        curParticipation = Participation(
          membership: _curMembership!,
          lineup: widget.lineup,
          weightClass: widget.weightClass,
          weight: _curWeight,
        );
      }
      widget.createOrUpdateParticipation(curParticipation);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return ListTile(
      title: Row(
        children: [
          Expanded(
            flex: 80,
            child: Container(
              padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
              child: getDropdown<Membership>(
                selectedItem: widget.participation?.membership,
                label:
                    '${localizations.weightClass} ${widget.weightClass.name} ${widget.weightClass.style.abbreviation(context)}',
                context: context,
                onChanged: (Membership? newMembership) {
                  _curMembership = newMembership;
                },
                onSaved: (Membership? newMembership) => onSave(),
                itemAsString: (u) => u.person.fullName,
                onFind: (String? filter) => ParticipationEditTile.filterMemberships(ref, filter, widget.lineup),
              ),
            ),
          ),
          Expanded(
            flex: 20,
            child: Container(
              padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
              child: TextFormField(
                initialValue: widget.participation?.weight?.toString() ?? '',
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 20),
                  labelText: localizations.weight,
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d{1,3}(\.\d{0,2})?'))
                ],
                onChanged: (String? value) {
                  final newValue = (value == null || value.isEmpty) ? null : double.parse(value);
                  _curWeight = newValue;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
