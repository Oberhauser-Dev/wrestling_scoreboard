import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/data/wrestling_style.dart';
import 'package:wrestling_scoreboard_client/provider/data_provider.dart';
import 'package:wrestling_scoreboard_client/ui/components/dropdown.dart';
import 'package:wrestling_scoreboard_client/ui/components/edit.dart';
import 'package:wrestling_scoreboard_client/ui/components/font.dart';
import 'package:wrestling_scoreboard_client/ui/components/ok_dialog.dart';
import 'package:wrestling_scoreboard_client/util/network/data_provider.dart';
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
      await dataProvider
          .createOrUpdateSingle(Lineup(id: widget.lineup.id, team: widget.lineup.team, leader: _leader, coach: _coach));
      await Future.forEach(
          _deleteParticipations, (Participation element) => dataProvider.deleteSingle<Participation>(element));
      await Future.forEach(
          _createOrUpdateParticipations, (Participation element) => dataProvider.createOrUpdateSingle(element));
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
            builder: (context) => OkDialog(
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

class ParticipationEditTile extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    return ListTile(
      title: Row(
        children: [
          Expanded(
            flex: 80,
            child: Container(
              padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
              child: getDropdown<Membership>(
                selectedItem: participation?.membership,
                label: '${localizations.weightClass} ${weightClass.name} ${styleToAbbr(weightClass.style, context)}',
                context: context,
                onSaved: (Membership? newMembership) {
                  if (participation?.membership == newMembership) return;

                  // Delete old participation, if not null
                  if (participation?.id != null) {
                    deleteParticipation(participation!);
                  }

                  // Add new participation, if not null
                  final addParticipation = newMembership == null
                      ? null
                      : Participation(
                          membership: newMembership,
                          lineup: lineup,
                          weightClass: weightClass,
                        );
                  if (addParticipation != null) {
                    createOrUpdateParticipation(addParticipation);
                  }
                },
                itemAsString: (u) => u.person.fullName,
                onFind: (String? filter) => ParticipationEditTile.filterMemberships(ref, filter, lineup),
              ),
            ),
          ),
          Expanded(
            flex: 20,
            child: Container(
              padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
              child: TextFormField(
                initialValue: participation?.weight?.toString() ?? '',
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 20),
                  labelText: localizations.weight,
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d{1,3}(\.\d{0,2})?'))
                ],
                onSaved: (String? value) {
                  if (participation != null) {
                    final newValue = (value == null || value.isEmpty) ? null : double.parse(value);
                    if (participation!.weight == newValue) return;
                    createOrUpdateParticipation(participation!.copyWith(weight: newValue));
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
