import 'package:common/common.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/ui/components/font.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';

class EditLineup extends StatefulWidget {
  final String title;
  final Lineup lineup;
  final List<Participation> participations;
  final List<WeightClass> weightClasses;
  final List<Membership> memberships;

  EditLineup(
      {required this.title,
      required this.weightClasses,
      required this.lineup,
      required this.participations,
      required this.memberships});

  @override
  State<StatefulWidget> createState() => EditLineupState();
}

class EditLineupState extends State<EditLineup> {
  Membership? _leader;
  Membership? _coach;
  late Map<WeightClass, Participation?> _participations;
  List<Participation> _removeParticipations = [];
  List<Participation> _addParticipations = [];

  Future<List<Membership>> filterMemberships(String filter) async {
    return widget.memberships.where((element) => element.person.fullName.contains(filter)).toList();
  }

  Widget getPersonDropdown(
      {required Membership? membership,
      required String label,
      required void Function(Membership? value) onChanged,
      required BuildContext context}) {
    return DropdownSearch<Membership>(
      dropdownSearchDecoration: InputDecoration(),
      searchBoxDecoration: InputDecoration(prefixIcon: const Icon(Icons.search)),
      mode: Mode.MENU,
      showSearchBox: true,
      showClearButton: true,
      label: label,
      onFind: (String filter) => filterMemberships(filter),
      itemAsString: (Membership u) => u.person.fullName,
      selectedItem: membership,
      onChanged: onChanged,
    );
  }

  void handleSubmit(BuildContext context) async {
    await dataProvider
        .createOrUpdateSingle(Lineup(id: widget.lineup.id, team: widget.lineup.team, leader: _leader, coach: _coach));
    await Future.forEach(_removeParticipations, (Participation element) => dataProvider.deleteSingle(element));
    await Future.forEach(_addParticipations, (Participation element) => dataProvider.createOrUpdateSingle(element));
    Navigator.of(context).pop();
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.title),
        actions: [
          Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                onPressed: () => handleSubmit(context),
                label: Text(AppLocalizations.of(context)!.save),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 1140),
            child: Column(
              children: [
                ListTile(title: HeadingText(widget.lineup.team.name)),
                ListTile(
                    title: getPersonDropdown(
                  membership: _leader,
                  label: AppLocalizations.of(context)!.leader,
                  context: context,
                  onChanged: (Membership? value) => setState(() {
                    _leader = value;
                  }),
                )),
                ListTile(
                    title: getPersonDropdown(
                  membership: _coach,
                  label: AppLocalizations.of(context)!.coach,
                  context: context,
                  onChanged: (Membership? value) => setState(() {
                    _coach = value;
                  }),
                )),
                ..._participations.entries.map((mapEntry) {
                  final weightClass = mapEntry.key;
                  final participation = mapEntry.value;
                  return ListTile(
                    title: Row(
                      children: [
                        Expanded(
                          flex: 80,
                          child: Container(
                            padding: EdgeInsets.only(right: 8, top: 8, bottom: 8),
                            child: getPersonDropdown(
                              membership: participation?.membership,
                              label: '${AppLocalizations.of(context)!.weightClass} ${weightClass.name}',
                              context: context,
                              onChanged: (Membership? value) => setState(() {
                                final removeParticipation = _participations[weightClass];
                                if (removeParticipation != null) {
                                  if(removeParticipation.id != null) {
                                    _removeParticipations.add(removeParticipation);
                                  } else {
                                    // Undo adding participant:
                                    _addParticipations.remove(removeParticipation);
                                  }
                                }
                                final addParticipation = value == null
                                    ? null
                                    : Participation(
                                        membership: value,
                                        lineup: widget.lineup,
                                        weightClass: weightClass,
                                      );
                                if (addParticipation != null) {
                                  _addParticipations.add(addParticipation);
                                  // _removeParticipations.remove(addParticipation); -> Cannot remove new participation, so Participant will be removed and added again
                                }
                                _participations[weightClass] = addParticipation;
                              }),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 20,
                          child: Container(
                            padding: EdgeInsets.only(left: 8, top: 8, bottom: 8),
                            child: TextFormField(
                              initialValue: participation?.weight?.toString() ?? '',
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 20),
                                  labelText: AppLocalizations.of(context)!.weight),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
