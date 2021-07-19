import 'package:common/common.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditLineup extends StatelessWidget {
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

  Future<List<Membership>> filterMemberships(String filter) async {
    return memberships.where((element) => element.person.fullName.contains(filter)).toList();
  }

  Widget getPersonDropdown(Membership? membership, String label, BuildContext context) {
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
      // onChanged: (Membership data) => print(data),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 1140),
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                getPersonDropdown(lineup.leader, AppLocalizations.of(context)!.leader, context),
                getPersonDropdown(lineup.coach, AppLocalizations.of(context)!.coach, context),
                ...weightClasses.map<Widget>((e) {
                  final weightParticipations = participations.where((participation) => participation.weightClass == e);
                  final participation = weightParticipations.isEmpty ? null : weightParticipations.single;
                  return Row(
                    children: [
                      Expanded(
                        flex: 80,
                        child: Container(
                          padding: EdgeInsets.only(right: 8, top: 8, bottom: 8),
                          child: getPersonDropdown(participation?.membership,
                              '${AppLocalizations.of(context)!.weightClass} ${e.name}', context),
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
                  );
                }).toList()
              ],
            ),
          ),
        ),
      ),
    );
  }

  // TODO implement
  handleSubmit(Lineup newLineup, BuildContext context) async {
    // Without submit button, just on back button
  }
}
