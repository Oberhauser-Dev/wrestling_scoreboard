import 'package:common/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';

import 'fight.dart';
import 'lineup.dart';
import 'participant_state.dart';

/// For team matches only.
class ClientTeamMatch extends TeamMatch with ChangeNotifier {
  List<ClientFight>? _fights;

  ClientTeamMatch(
      {int? id,
      required ClientLineup home,
      required ClientLineup guest,
      required List<Person> referees,
      String? location,
      DateTime? date})
      : super(id: id, home: home, guest: guest, referees: referees, location: location, date: date);

  ClientTeamMatch.from(TeamMatch obj)
      : this(
            id: obj.id,
            home: ClientLineup.from(obj.home),
            guest: ClientLineup.from(obj.guest),
            referees: obj.referees,
            location: obj.location,
            date: obj.date);

  factory ClientTeamMatch.fromJson(Map<String, dynamic> json) => ClientTeamMatch.from(TeamMatch.fromJson(json));

  List<ClientFight> get fights {
    return _fights!;
  }

  Future<List<Fight>> generateFights() async {
    _fights = [];
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
        red == null ? null : ClientParticipantState(participation: red),
        blue == null ? null : ClientParticipantState(participation: blue),
        weightClass,
      );
      fight.addListener(() {
        notifyListeners();
      });
      _fights!.add(fight);
    }
    return _fights!;
  }
}
