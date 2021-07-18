import 'package:common/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';

import 'fight.dart';
import 'lineup.dart';
import 'participant_state.dart';

/// For team matches only.
class ClientTeamMatch extends TeamMatch with ChangeNotifier {
  ClientTeamMatch(
      {int? id,
      required ClientLineup home,
      required ClientLineup guest,
      required List<WeightClass> weightClasses,
      required List<Person> referees,
      String? location,
      DateTime? date})
      : super(
            id: id,
            home: home,
            guest: guest,
            weightClasses: weightClasses,
            referees: referees,
            location: location,
            date: date);

  ClientTeamMatch.from(TeamMatch obj)
      : this(
            id: obj.id,
            home: ClientLineup.from(obj.home),
            guest: ClientLineup.from(obj.guest),
            weightClasses: obj.weightClasses,
            referees: obj.referees,
            location: obj.location,
            date: obj.date);

  factory ClientTeamMatch.fromJson(Map<String, dynamic> json) => ClientTeamMatch.from(TeamMatch.fromJson(json));

  List<ClientFight> get fights => super.fights.cast<ClientFight>();

  set fights(List<Fight> newFights) {
    if (newFights is List<ClientFight>)
      super.fights = newFights;
    else
      super.fights = newFights.map((e) => ClientFight.from(e)).toList();
  }

  Future<void> generateFights() async {
    super.fights = [];
    final homeParticipations = await dataProvider.fetchMany<Participation>(filterObject: home);
    final guestParticipations = await dataProvider.fetchMany<Participation>(filterObject: guest);
    for (final weightClass in weightClasses) {
      final homePartList = homeParticipations.where((el) => el.weightClass == weightClass);
      if (homePartList.length > 1)
        throw Exception(
            'Home team has two or more participants in the same weight class ${weightClass.name}: ${homePartList.map((e) => e.membership.person.fullName).join(', ')}');
      final guestPartList = guestParticipations.where((el) => (el.weightClass == weightClass));
      if (guestPartList.length > 1)
        throw Exception(
            'Guest team has two or more participants in the same weight class ${weightClass.name}: ${guestPartList.map((e) => e.membership.person.fullName).join(', ')}');
      final red = homePartList.isNotEmpty ? homePartList.single : null;
      final blue = guestPartList.isNotEmpty ? guestPartList.single : null;

      var fight = ClientFight(
        r: red == null ? null : ClientParticipantState(participation: red),
        b: blue == null ? null : ClientParticipantState(participation: blue),
        weightClass: weightClass,
      );
      fight.addListener(() {
        notifyListeners();
      });
      fights.add(fight);
    }
  }
}
