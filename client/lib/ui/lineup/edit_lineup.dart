import 'dart:collection';

import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/data/lineup.dart';
import 'package:wrestling_scoreboard/ui/components/dropdown.dart';
import 'package:wrestling_scoreboard/ui/components/edit.dart';
import 'package:wrestling_scoreboard/ui/components/font.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';

class EditLineup extends StatefulWidget {
  final String title;
  final ClientLineup lineup;
  final Iterable<Participation> participations;
  final Iterable<WeightClass> weightClasses;
  final Iterable<Membership> memberships;
  final Function()? onSubmit;

  const EditLineup(
      {Key? key,
      required this.title,
      required this.weightClasses,
      required this.lineup,
      required this.participations,
      required this.memberships,
      this.onSubmit})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => EditLineupState();
}

class EditLineupState extends State<EditLineup> {
  final _formKey = GlobalKey<FormState>();

  Membership? _leader;
  Membership? _coach;
  late Map<WeightClass, Participation?> _participations;
  final HashSet<Participation> _deleteParticipations = HashSet();
  final HashSet<Participation> _createOrUpdateParticipations = HashSet();

  Future<List<Membership>> filterMemberships(String? filter) async {
    return (filter == null
            ? widget.memberships
            : widget.memberships.where((element) => element.person.fullName.contains(filter)))
        .toList();
  }

  void handleSubmit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await dataProvider.createOrUpdateSingle(
          ClientLineup(id: widget.lineup.id, team: widget.lineup.team, leader: _leader, coach: _coach));
      await Future.forEach(_deleteParticipations, (Participation element) => dataProvider.deleteSingle(element));
      await Future.forEach(
          _createOrUpdateParticipations, (Participation element) => dataProvider.createOrUpdateSingle(element));
      if (widget.onSubmit != null) widget.onSubmit!();
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    _leader = widget.lineup.leader;
    _coach = widget.lineup.coach;
    _participations = Map.fromEntries(widget.weightClasses.map((e) {
      final weightParticipations = widget.participations.where((participation) => participation.weightClass == e);
      final participation = weightParticipations.isEmpty ? null : weightParticipations.single;
      return MapEntry(e, participation);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: EditWidget(
          title: widget.title,
          onSubmit: () => handleSubmit(context),
          items: [
            ListTile(title: HeadingText(widget.lineup.team.name)),
            ListTile(
              title: getDropdown<Membership>(
                selectedItem: _leader,
                label: AppLocalizations.of(context)!.leader,
                context: context,
                onSaved: (Membership? value) => setState(() {
                  _leader = value;
                }),
                itemAsString: (u) => u.person.fullName,
                onFind: filterMemberships,
              ),
            ),
            ListTile(
              title: getDropdown<Membership>(
                selectedItem: _coach,
                label: AppLocalizations.of(context)!.coach,
                context: context,
                onSaved: (Membership? value) => setState(() {
                  _coach = value;
                }),
                itemAsString: (u) => u.person.fullName,
                onFind: filterMemberships,
              ),
            ),
            ..._participations.entries.map((mapEntry) {
              final weightClass = mapEntry.key;
              final participation = mapEntry.value;
              return ListTile(
                title: Row(
                  children: [
                    Expanded(
                      flex: 80,
                      child: Container(
                        padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                        child: getDropdown<Membership>(
                          selectedItem: participation?.membership,
                          label: '${AppLocalizations.of(context)!.weightClass} ${weightClass.name}',
                          context: context,
                          onSaved: (Membership? newMembership) {
                            final oldParticipation = _participations[weightClass];
                            if (oldParticipation?.membership == newMembership) return;
                            if (oldParticipation?.id != null) {
                              _deleteParticipations.add(oldParticipation!);
                            }
                            final addParticipation = newMembership == null
                                ? null
                                : Participation(
                                    membership: newMembership,
                                    lineup: widget.lineup,
                                    weightClass: weightClass,
                                  );
                            if (addParticipation != null) {
                              _createOrUpdateParticipations.add(addParticipation);
                              // _removeParticipations.remove(addParticipation); -> Cannot remove new participation, so Participant will be removed and added again
                            }
                            _participations[weightClass] = addParticipation;
                          },
                          itemAsString: (u) => u.person.fullName,
                          onFind: filterMemberships,
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
                              labelText: AppLocalizations.of(context)!.weight),
                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
                          onSaved: (String? value) {
                            final participation = _participations[weightClass];
                            if (participation != null) {
                              final newValue = value == null || value.isEmpty ? null : double.parse(value);
                              if (participation.weight == newValue) return;
                              participation.weight = newValue;
                              _createOrUpdateParticipations.add(participation);
                              print('save: $value');
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList()
          ],
        ));
  }
}
