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
      required List<WeightClass> weightClasses, // TODO make optional
      required Iterable<Person> referees, // TODO make optional
      String? no,
      String? location,
      DateTime? date})
      : super(
            id: id,
            no: no,
            home: home,
            guest: guest,
            weightClasses: weightClasses,
            referees: referees,
            location: location,
            date: date);

  ClientTeamMatch.from(TeamMatch obj)
      : this(
            id: obj.id,
            no: obj.no,
            home: ClientLineup.from(obj.home),
            guest: ClientLineup.from(obj.guest),
            weightClasses: obj.weightClasses,
            referees: obj.referees,
            location: obj.location,
            date: obj.date);

  factory ClientTeamMatch.fromJson(Map<String, dynamic> json) => ClientTeamMatch.from(TeamMatch.fromJson(json));

  @override
  List<ClientLineup> get lineups => super.lineups.cast<ClientLineup>();

  @override
  List<ClientFight> get fights => super.fights.cast<ClientFight>();

  @override
  set fights(Iterable<Fight> newFights) {
    if (newFights is List<ClientFight>) {
      super.fights = newFights;
    } else {
      super.fights = newFights.map((e) => ClientFight.from(e)).toList();
    }
  }

  @override
  Future<void> generateFights() async {
    List<ClientFight> fights = [];
    final homeParticipations = await dataProvider.readMany<Participation, Participation>(filterObject: home);
    final guestParticipations = await dataProvider.readMany<Participation, Participation>(filterObject: guest);
    for (final weightClass in weightClasses) {
      final homePartList = homeParticipations.where((el) => el.weightClass == weightClass);
      if (homePartList.length > 1) {
        throw Exception(
            'Home team has two or more participants in the same weight class ${weightClass.name}: ${homePartList.map((e) => e.membership.person.fullName).join(', ')}');
      }
      final guestPartList = guestParticipations.where((el) => (el.weightClass == weightClass));
      if (guestPartList.length > 1) {
        throw Exception(
            'Guest team has two or more participants in the same weight class ${weightClass.name}: ${guestPartList.map((e) => e.membership.person.fullName).join(', ')}');
      }
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
    super.fights = fights;
  }
}
